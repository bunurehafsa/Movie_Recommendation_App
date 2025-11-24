import 'dart:convert';
import 'package:r08fullmovieapp/RepeatedFunction/sliderlist.dart';
import 'package:r08fullmovieapp/apikey/apikey.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:r08fullmovieapp/HomePage/HomePage.dart';
import '../RepeatedFunction/TrailerUI.dart';
import '../RepeatedFunction/favoriateandshare.dart';
import '../RepeatedFunction/repttext.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:r08fullmovieapp/Recommendation/recommender.dart';
//import '../RepeatedFunction/reviewui.dart';

class MovieDetails extends StatefulWidget {
  var id;
  MovieDetails({super.key, this.id});
  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String, dynamic>> movieDetails = [];
  List<Map<String, dynamic>> UserREviews = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List<Map<String, dynamic>> movietrailerslist = [];

  List MoviesGeneres = [];

  Future<void> fetchMovieDetails() async {
    //using apikey/apikey.dart file to get api key
    var moviedetailurl =
        'https://api.themoviedb.org/3/movie/${widget.id}?api_key=${api_key}';
    // var UserReviewurl =
    // 'https://api.themoviedb.org/3/movie/${widget.id}/reviews?api_key=${api_key}';
    var similarmoviesurl =
        'https://api.themoviedb.org/3/movie/${widget.id}/similar?api_key=${api_key}';
    //var recommendedmoviesurl =
    // 'https://api.themoviedb.org/3/movie/${widget.id}/recommendations?api_key=${api_key}';
    var movietrailersurl =
        'https://api.themoviedb.org/3/movie/${widget.id}/videos?api_key=${api_key}';

    var moviedetailresponse = await http.get(Uri.parse(moviedetailurl));
    if (moviedetailresponse.statusCode == 200) {
      var moviedetailjson = jsonDecode(moviedetailresponse.body);
      for (var i = 0; i < 1; i++) {
        movieDetails.add({
          "backdrop_path": moviedetailjson['backdrop_path'],
          "title": moviedetailjson['title'],
          "vote_average": moviedetailjson['vote_average'],
          "overview": moviedetailjson['overview'],
          "release_date": moviedetailjson['release_date'],
          "runtime": moviedetailjson['runtime'],
          "budget": moviedetailjson['budget'],
          "revenue": moviedetailjson['revenue'],
        });
      }
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGeneres.add(moviedetailjson['genres'][i]['name']);
      }
    } else {}

    /////////////////////////////similar movies
    var similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
    if (similarmoviesresponse.statusCode == 200) {
      var similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarmovieslist.add({
          "poster_path": similarmoviesjson['results'][i]['poster_path'],
          "name": similarmoviesjson['results'][i]['title'],
          "vote_average": similarmoviesjson['results'][i]['vote_average'],
          "Date": similarmoviesjson['results'][i]['release_date'],
          "id": similarmoviesjson['results'][i]['id'],
        });
      }
    } else {}

    /////////////////////////////recommended movies (from precomputed JSON + TMDB metadata)
    // Load recommender asset (mapping movieId -> [recommendedIds]) and fetch metadata
    try {
      await Recommender.instance.loadFromAsset();
      final recIds =
          Recommender.instance.getRecommendationsFor(widget.id, max: 15);
      if (recIds.isNotEmpty) {
        // Fetch details in parallel for the recommended ids
        final futures = recIds
            .map((rid) => http.get(Uri.parse(
                'https://api.themoviedb.org/3/movie/$rid?api_key=$api_key')))
            .toList();
        final responses = await Future.wait(futures);
        for (var resp in responses) {
          if (resp.statusCode == 200) {
            final d = jsonDecode(resp.body);
            recommendedmovieslist.add({
              "poster_path": d['poster_path'],
              "name": d['title'],
              "vote_average": d['vote_average'],
              "Date": d['release_date'],
              "id": d['id'],
            });
          }
        }
      }
    } catch (e) {
      // If anything fails, leave recommendedmovieslist empty (or fall back to API)
    }
    /////////////////////////////movie trailers
    var movietrailersresponse = await http.get(Uri.parse(movietrailersurl));
    if (movietrailersresponse.statusCode == 200) {
      var movietrailersjson = jsonDecode(movietrailersresponse.body);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        if (movietrailersjson['results'][i]['type'] == "Trailer") {
          movietrailerslist.add({
            "key": movietrailersjson['results'][i]['key'],
          });
        }
      }
      movietrailerslist.add({'key': 'aJ0cZTcTh90'});
    } else {}
    print(movietrailerslist);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 14, 14, 1),
      body: FutureBuilder(
          future: fetchMovieDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                            onPressed: () {
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.manual,
                                  overlays: [SystemUiOverlay.bottom]);
                              // SystemChrome.setEnabledSystemUIMode(
                              //     SystemUiMode.manual,
                              //     overlays: []);
                              SystemChrome.setPreferredOrientations([
                                DeviceOrientation.portraitUp,
                                DeviceOrientation.portraitDown,
                              ]);
                              Navigator.pop(context);
                            },
                            icon: Icon(FontAwesomeIcons.circleArrowLeft),
                            iconSize: 28,
                            color: Colors.white),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                    (route) => false);
                              },
                              icon: Icon(FontAwesomeIcons.houseUser),
                              iconSize: 25,
                              color: Colors.white)
                        ],
                        backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                        centerTitle: false,
                        pinned: true,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.4,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          background: FittedBox(
                            fit: BoxFit.fill,
                            child: trailerwatch(
                              trailerytid: movietrailerslist[0]['key'],
                            ),
                          ),
                          // background: FittedBox(
                          //   fit: BoxFit.fill,
                          //   child: Container(
                          //     child: trailerwatch(
                          //       trailerytid: movietrailerslist[0]['key'],
                          //     ),
                          //   ),
                          // ),
                        )),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      //add to favoriate button
                      addtofavoriate(
                        id: widget.id,
                        type: 'movie',
                        Details: movieDetails,
                      ),

                      Column(
                        children: [
                          Row(children: [
                            Container(
                                padding: EdgeInsets.only(left: 10, top: 10),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: MoviesGeneres.length,
                                    itemBuilder: (context, index) {
                                      //generes box
                                      return Container(
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(25, 25, 25, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child:
                                              genrestext(MoviesGeneres[index]));
                                    })),
                          ]),
                          Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(25, 25, 25, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: genrestext(
                                      '${movieDetails[0]['runtime']} min'))
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: tittletext('Movie Story :')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: overviewtext(
                              movieDetails[0]['overview'].toString())),

                      // Padding(
                      //   padding: EdgeInsets.only(left: 20, top: 10),
                      //   child: ReviewUI(revdeatils: UserREviews),
                      // ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: normaltext(
                              'Release Date : ${movieDetails[0]['release_date']}')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: normaltext(
                              'Budget : ${movieDetails[0]['budget']}')),
                      Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: normaltext(
                              'Revenue : ${movieDetails[0]['revenue']}')),

                      sliderlist(recommendedmovieslist, "Recommended Movies",
                          "movie", recommendedmovieslist.length),
                      sliderlist(similarmovieslist, "Similar Movies", "movie",
                          similarmovieslist.length),
                    ]))
                  ]);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            }
          }),
    );
  }
}
