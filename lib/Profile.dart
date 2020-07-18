import 'dart:async';
import 'dart:io';
import 'package:feedpage/MyDoubts.dart';
import 'package:feedpage/MyNotes.dart';
import 'package:feedpage/MyVideos.dart';
import 'package:feedpage/MyWatchlist.dart';
import 'package:feedpage/bookmarks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/authService.dart';
import 'package:feedpage/userService.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:photo_view/photo_view.dart';
import 'NavigationPage.dart';
import 'package:feedpage/customDrawer.dart';
import 'globals.dart' as globals;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _auth = AuthService();
  File image;
  String url;
  List chips = [];
  bool isLoading = false;
  String profileImage = "";

  Future<void> pushPage() {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => NavigationPage(
                  pageToReload: 3,
                )),
        ModalRoute.withName("/Profile"));
  }

  Future selectPhoto() async {
    setState(() {
      isLoading = true;
    });
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (tempImage != null) {
      setState(() {
        image = File(tempImage.path);
      });
      uploadImage();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${globals.currentUser.uid}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(image);
    String downloadUrl = await firebaseStorageRef.getDownloadURL();
    task.onComplete.then((value) {
      setState(() {
        UserService(uid: globals.currentUser.uid)
            .setUrl(downloadUrl)
            .then((val) {
          setState(() {
            profileImage = downloadUrl;
            isLoading = false;
          });
        });
      });
    }).catchError((e) {
      print(e);
    });
  }

  getLoader() {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          )
        : Container();
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
      profileImage = globals.currentUser == null ? "" : globals.currentUser.url;
    return globals.currentUser == null
        ? Loading()
        : SafeArea(
            child: Scaffold(
              drawer: CustomDrawer(image: profileImage),
              backgroundColor: Colors.blue[50],
              body: LiquidPullToRefresh(
                onRefresh: pushPage,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 30.0),
                    Stack(
                      children: [
                        Center(
                          child: Hero(
                            tag: 'MyProfileImageView',
                            child: GestureDetector(
                                onTap: () async {
                                  dynamic result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyProfilePhotoPageView(
                                                  profileImage)));
                                  setState(() {
                                    profileImage = globals.currentUser.url;
                                  });
                                },
                                child:
                                CircularProfileAvatar(
                                  profileImage,
                                  radius: 80,
                                  backgroundColor: Colors.black,
                                  borderWidth: 0,
                                  initialsText: Text(
                                    globals.currentUser.username
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.white),
                                  ),
                                  borderColor: Colors.black,
                                  elevation: 5.0,
                                  cacheImage: false,
                                  showInitialTextAbovePicture: false,
                                )
                            ),
                          ),
                        ),
                        Positioned(
                          left: (MediaQuery.of(context).size.width / 2) + 30,
                          height: 270,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              focusColor: Colors.red,
                              onPressed: selectPhoto,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    getLoader(),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: AutoSizeText(globals.currentUser.username,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontFamily: 'Museo',
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: AutoSizeText(
                        "Email ID : " + globals.currentUser.email,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 20.0),
//                    Container(
//                      width: MediaQuery.of(context).size.width,
//                      height: 200.0,
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: GestureDetector(
//                          onTap: () async {
//                            dynamic result = await Navigator.of(context).push(
//                              MaterialPageRoute(
//                                  builder: (context) => ChangePreference()),
//                            );
//                            print(result);
//                            setState(() {});
//                          },
//                          child: Card(
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(15.0),
//                            ),
//                            color: Colors.blue[200],
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Text(
//                                  'My Interests',
//                                  style: TextStyle(
//                                    fontSize: 20.0,
//                                  ),
//                                ),
//                                Icon(Icons.help)
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
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
                                    builder: (context) => MyDoubts()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'My Doubts',
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
                                    builder: (context) => MyNotes()));
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
                                  'My Notes',
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
                                    builder: (context) => MyVideos()));
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
                                  'My Videos',
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
                                    builder: (context) => Bookmarks()));
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
                                  'Bookmarked Notes ',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Icon(Icons.bookmark)
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
                                    builder: (context) => WatchLaterScreen()));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.blue[800],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'My Watchlist',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Icon(Icons.watch_later)
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

class MyProfilePhotoPageView extends StatefulWidget {
  String imageURL;

  MyProfilePhotoPageView(this.imageURL);

  @override
  _MyProfilePhotoPageViewState createState() => _MyProfilePhotoPageViewState();
}

class _MyProfilePhotoPageViewState extends State<MyProfilePhotoPageView> {
  bool isLoading = false;
  File image;

  Future selectPhoto() async {
    setState(() {
      isLoading = true;
    });
    var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (tempImage != null) {
      setState(() {
        image = File(tempImage.path);
      });
      uploadImage();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future uploadImage() async {
    setState(() {
      isLoading = true;
    });
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profilepics/${globals.currentUser.uid}.jpg');
    StorageUploadTask task = firebaseStorageRef.putFile(image);
    String downloadUrl = await firebaseStorageRef.getDownloadURL();
    task.onComplete.then((value) {
      setState(() {
        UserService(uid: globals.currentUser.uid).setUrl(downloadUrl);
            widget.imageURL = downloadUrl;
            isLoading = false;
        imageCache.clear();
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, widget.imageURL);
                },
              ),
            ),
            body: Container(
                padding: EdgeInsets.all(20),
                color: Colors.black,
                child: Hero(
                  tag: 'MyProfileImageView',
                  child:
                      PhotoView(
                    imageProvider: NetworkImage(widget.imageURL),
                  ),
                )),
            floatingActionButton: FloatingActionButton.extended(
                onPressed: selectPhoto,
                icon: Icon(Icons.edit),
                label: Text('Edit Image')),
          );
  }
}
