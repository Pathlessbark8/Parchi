import 'dart:async';
import 'dart:io';
import 'package:feedpage/othersVideos.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/userService.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_view/photo_view.dart';
import 'package:feedpage/user.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'othersDoubt.dart';
import 'othersNotes.dart';


class OthersProfilePage extends StatefulWidget {
  final uid;

  OthersProfilePage({this.uid});

  @override
  _OthersProfilePageState createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends State<OthersProfilePage> {
  File image;
  String url;
  List chips = [];
  bool isLoading = true;
  String profileImage = "";
  User_Data otherUser;

  Future<void> pushPage() {
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OthersProfilePage(uid: widget.uid)));
  }

  void getOtherUserData() async {
    UserService currentUser = UserService(uid: widget.uid);
    await currentUser.getData().then((result) {
      otherUser = result;
      print("got it");
      print(otherUser);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getOtherUserData();
    super.initState();
  }

  Widget line() {
    return SizedBox(
      height: 10.0,
      child: new Center(
        child: new Container(
          margin: new EdgeInsetsDirectional.only(
              start: MediaQuery.of(context).size.width / 4,
              end: MediaQuery.of(context).size.width / 4),
          height: 5.0,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("uid");
    print(widget.uid);
    print("here");

    print("yo");
    if (otherUser != null) {
      print("in");
      print(otherUser);
    }
    return isLoading == true
        ? Loading()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue[400],
//        shape: CustomShapeBorder(),
                centerTitle: true,
                title: Text(
                  'Profile',
                ),
              ),
              backgroundColor: Colors.blue[50],
              body: LiquidPullToRefresh(
                onRefresh: pushPage,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 30.0),
                    Center(
                      child: Hero(
                        tag: 'ProfileImageView',
                        child: GestureDetector(
                          onTap: () {
                            if (otherUser != null)
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePhotoPageView(otherUser.url)));
                          },
                          child: CircularProfileAvatar(
//globals.currentUser.url, //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                            otherUser == null ? '' : otherUser.url,
                            radius: 80,
                            // sets radius, default 50.0
                            backgroundColor: Colors.transparent,
                            // sets background color, default Colors.white
                            borderWidth: 0,
                            // sets border, default 0.0
                            initialsText: Text(
                              otherUser == null
                                  ? ""
                                  : otherUser.username
                                      .substring(0, 1)
                                      .toUpperCase(),
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                            // sets initials text, set your own style, default Text('')
                            borderColor: Colors.black,
                            elevation: 5.0,
                            cacheImage: true,

                            showInitialTextAbovePicture: false,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: AutoSizeText(otherUser.username,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Museo',
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: AutoSizeText(
                        "Email ID : " + otherUser.email,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    line(),
                    SizedBox(height: 2),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OthersDoubts(
                                          uid: widget.uid,
                                        )));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[200],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Doubts Asked',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Icon(Icons.question_answer)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    line(),
                    SizedBox(height: 2),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        OthersNotes(uid: widget.uid)));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[400],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Notes Posted',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Icon(Icons.library_books)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    line(),
                    SizedBox(height: 2),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OthersVideos(
                                          uid: widget.uid,
                                        )));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[600],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Videos Uploaded',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Icon(Icons.videocam)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          );
  }
}

class ProfilePhotoPageView extends StatelessWidget {
  String imageURL;

  ProfilePhotoPageView(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'ProfileImageView',
      child:
            Container(
              padding: EdgeInsets.all(20),
                color: Colors.black,
                child: PhotoView(
                  imageProvider: NetworkImage(imageURL),
                )),

    );
  }
}
