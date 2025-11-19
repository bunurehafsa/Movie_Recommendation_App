import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r08fullmovieapp/SectionHomeUi/FavoriateList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'repttext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class drawerfunc extends StatefulWidget {
  const drawerfunc({
    super.key,
  });

  @override
  State<drawerfunc> createState() => _drawerfuncState();
}

class _drawerfuncState extends State<drawerfunc> {
  File? _image;

  WebViewController? controllerone;
  WebViewController? controllertwo;

  Future<void> SelectImage() async {
    final pickedfile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: pickedfile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('imagepath', cropped!.path);
      // Note: File conversion on web is not supported; this is mobile behavior.
      _image = File(cropped.path);
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      final path = sp.getString('imagepath');
      if (path != null && path.isNotEmpty) {
        setState(() {
          _image = File(path);
        });
      }
    });

    // Initialize WebView controllers only on non-web platforms to avoid
    // platform-implementation assertions when running on Flutter Web.
    if (!kIsWeb) {
      controllerone = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse('https://niranjandahal.com.np'));

      controllertwo = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse('https://dahalniranjan.com.np'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(18, 18, 18, 0.9),
        child: ListView(
          children: [
            DrawerHeader(
              child: Container(
                height: 100,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await SelectImage();
                        Fluttertoast.showToast(
                            msg: "Image Changed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: _image == null
                          ? CircleAvatar(
                              radius: 45,
                              backgroundImage: AssetImage('assets/user.png'),
                            )
                          : CircleAvatar(
                              radius: 45,
                              backgroundImage: FileImage(_image!),
                            ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            listtilefunc('Home', Icons.home, ontap: () {
              Navigator.pop(context);
            }),
            listtilefunc('Favorite', Icons.favorite, ontap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoriateMovies()));
            }),
            listtilefunc('Our Blogs', FontAwesomeIcons.blogger,
                ontap: () async {
              final url = 'https://niranjandahal.com.np';
              if (kIsWeb) {
                await launch(url);
              } else {
                // controllerone is guaranteed to be non-null on non-web
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                              appBar: AppBar(
                                backgroundColor:
                                    Color.fromRGBO(18, 18, 18, 0.9),
                                title: Text('Our Blogs'),
                              ),
                              body: WebViewWidget(controller: controllerone!),
                            )));
              }
            }),
            listtilefunc('Our Website', FontAwesomeIcons.solidNewspaper,
                ontap: () async {
              final url = 'https://dahalniranjan.com.np';
              if (kIsWeb) {
                await launch(url);
              } else {
                // use second controller on non-web
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Scaffold(
                              backgroundColor: Color.fromRGBO(18, 18, 18, 0.5),
                              appBar: AppBar(
                                backgroundColor:
                                    Color.fromRGBO(18, 18, 18, 0.9),
                                title: Text('flutter content'),
                              ),
                              body: WebViewWidget(controller: controllertwo!),
                            )));
              }
            }),
            listtilefunc('Subscribe US', FontAwesomeIcons.youtube,
                ontap: () async {
              var url =
                  'https://www.youtube.com/channel/UCeJnnsTq-Lh9E16kCEK49rQ?sub_confirmation=1';
              await launch(url);
            }),
            listtilefunc('About', Icons.info, ontap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
                      title: overviewtext(
                          'This App is made by Nure Hafsa Shefa.User can explore,get Details of latest Movies/series.TMDB API is used to fetch data.'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Ok'))
                      ],
                    );
                  });
            }),
            listtilefunc('Quit', Icons.exit_to_app_rounded, ontap: () {
              SystemNavigator.pop();
            }),
          ],
        ),
      ),
    );
  }
}

Widget listtilefunc(String title, IconData icon, {Function? ontap}) {
  return GestureDetector(
    onTap: ontap as void Function()?,
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
