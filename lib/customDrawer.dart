import 'package:auto_size_text/auto_size_text.dart';
import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/changePassword.dart';
import 'package:photo_view/photo_view.dart';
import 'package:feedpage/authService.dart';
import 'package:feedpage/FeedBackForm.dart';
import 'package:feedpage/wrapper.dart';
import 'package:feedpage/globals.dart' as globals;

class CustomDrawer extends StatefulWidget {
  final String image;
  CustomDrawer({this.image});
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Hero(
                  tag: 'MyProfileImageViewDrawer',
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyProfilePhotoPageView(widget.image)));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.image),
                      radius: 40,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                AutoSizeText(
                  globals.currentUser.username,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => NavigationPage()));
            },
          ),
          ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => FeedbackForm()));
              }),
          if (globals.currentUser.gmail_user == false)
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text('Change Password'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VerifyPassword()));
              },
            ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Not " + globals.currentUser.username + " ? Sign Out!"),
            onTap: () {
              dynamic result = _auth.SignOut();
              NavigatorState navigatorState = Navigator.of(this.context);
              while (navigatorState.canPop()) {
                navigatorState.pop();
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return Wrapper();
                }),
              );
            },
          ),
//          FlatButton(
//            onPressed: () {
//              dynamic result = _auth.SignOut();
//              NavigatorState navigatorState = Navigator.of(this.context);
//              while (navigatorState.canPop()) {
//                navigatorState.pop();
//              }
//
//              Navigator.pushReplacement(
//                context,
//                MaterialPageRoute(builder: (BuildContext context) {
//                  return Wrapper();
//                }),
//              );
//            },
//            child: RichText(
//              text: TextSpan(children: [
//                TextSpan(
//                  text: "Not " + globals.currentUser.username + " ?",
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.black,
//                    fontWeight: FontWeight.w500,
//                  ),
//                ),
//                TextSpan(
//                  text: "Sign out",
//                  style: TextStyle(
//                    fontSize: 18,
//                    color: Colors.black,
//                    decoration: TextDecoration.underline,
//                    fontWeight: FontWeight.w500,
//                  ),
//                ),
//              ]),
//            ),
//          ),
        ],
      ),
    );
  }
}

class MyProfilePhotoPageView extends StatelessWidget {
  String imageURL;

  MyProfilePhotoPageView(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20),
          color: Colors.black,
          child: Hero(
            tag: 'MyProfileImageViewDrawer',
            child: PhotoView(
              imageProvider: NetworkImage(imageURL),
            ),
          )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, icon: Icon(Icons.edit), label: Text('Edit Image')),
    );
  }
}
