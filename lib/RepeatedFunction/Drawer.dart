import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r08fullmovieapp/SectionHomeUi/FavoriateList.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'repttext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;

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
                  MaterialPageRoute(builder: (context) => FavoriteListPage()));
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
            // ← Keep everything above exactly as it is (DrawerHeader, Home, Favorite, About, Exit, etc.)

            listtilefunc('Settings', Icons.settings, ontap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Color.fromARGB(255, 248, 248, 247),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(color: Colors.white24),

                      // 1. App Info / Version
                      ListTile(
                        leading: const Icon(Icons.info_outline,
                            color: Colors.white70),
                        title: const Text('About App',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          showAboutDialog(
                            context: context,
                            applicationName: "MovieLens",
                            applicationVersion: "1.0.0",
                            applicationIcon:
                                Image.asset('assets/icon.png', width: 60),
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  "Made by Nure Hafsa Shefa\n"
                                  "Powered by TMDB API\n"
                                  "Enjoy movies & series!",
                                  style: TextStyle(
                                      color: Color.fromARGB(179, 14, 0, 0)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const Divider(color: Colors.white24),

                      // 2. Rate App (optional)
                      ListTile(
                        leading:
                            const Icon(Icons.star_rate, color: Colors.amber),
                        title: const Text('Rate This App',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: "Thank you for your support!",
                            backgroundColor: Colors.purple,
                            textColor: Colors.white,
                          );
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close',
                          style: TextStyle(
                              color: Color.fromARGB(255, 245, 245, 244))),
                    ),
                  ],
                ),
              );
            }),

            listtilefunc('Exit', Icons.exit_to_app, ontap: () {
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
