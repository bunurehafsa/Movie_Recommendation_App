// lib/favoriteandshare.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:r08fullmovieapp/RepeatedFunction/repttext.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'favorites_manager.dart';
import '../favorites_manager.dart';

class addtofavoriate extends StatefulWidget {
  final id;
  final type;
  final Details;
  addtofavoriate({
    super.key,
    this.id,
    this.type,
    this.Details,
  });

  @override
  State<addtofavoriate> createState() => _addtofavoriateState();
}

class _addtofavoriateState extends State<addtofavoriate> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    isFav = FavoritesManager.isFavorite(widget.id.toString(), widget.type);
  }

  void toggleFavorite() {
    setState(() {
      if (isFav) {
        FavoritesManager.removeFavorite(widget.id.toString(), widget.type);
        Fluttertoast.showToast(
            msg: "Removed from Favorite",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        FavoritesManager.addFavorite({
          "id": widget.id.toString(),
          "type": widget.type,
          "name": widget.Details[0]['title'],
          "rating": widget.Details[0]['vote_average'],
          "image": widget.Details[0]['poster_path'],
        });
        Fluttertoast.showToast(
            msg: "Added to Favorite",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      isFav = !isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: 55,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 50,
                width: 50,
                child: IconButton(
                  icon: Icon(Icons.favorite,
                      color: isFav ? Colors.red : Colors.white, size: 30),
                  onPressed: toggleFavorite,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
                      title: normaltext("MovieLens By Shefa"),
                      content: SizedBox(
                        height: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      Icon(Icons.share,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 10),
                                      normaltext("Share to Social Media")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var url =
                                          "https://www.facebook.com/sharer/sharer.php?u=https://www.themoviedb.org/${widget.type}/${widget.id}";
                                      await launch(url);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Icon(Icons.facebook_rounded,
                                              color: Colors.white, size: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      var url =
                                          "https://wa.me/?text=Check%20out%20this%20link:%20https://www.themoviedb.org/${widget.type}/${widget.id}";
                                      await launch(url);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.whatsapp,
                                              color: Colors.white, size: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      var url =
                                          "https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20https://www.themoviedb.org/${widget.type}/${widget.id}";
                                      await launch(url);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Icon(FontAwesomeIcons.twitter,
                                              color: Colors.white, size: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(
                                    text:
                                        "https://www.themoviedb.org/${widget.type}/${widget.id}"));
                                Navigator.pop(context);

                                Fluttertoast.showToast(
                                    msg: "Link Copied to Clipboard",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                    fontSize: 16.0);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(Icons.copy,
                                        color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    normaltext("Copy Link")
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(Icons.share, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  normaltext("Share")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
