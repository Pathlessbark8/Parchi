import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/cardVideos.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class MyVideos extends StatefulWidget {
  @override
  _MyVideosState createState() => _MyVideosState();
}

class _MyVideosState extends State<MyVideos> {
  bool isLoading=true;
  bool showEmpty=false;
  Firestore _firestore = Firestore.instance;
  QuerySnapshot videos;
  getMyDoubts() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('videos')
        .where("userUid", isEqualTo: globals.currentUser.uid)
        .getDocuments();


    if(querySnapshot==null ){
      setState(() {
        showEmpty = true;
        isLoading = false;
      });
    }
    else if (querySnapshot.documents.length==0) {
      setState(() {
        showEmpty = true;
        isLoading = false;
      });
    }else {
      setState(() {
        videos = querySnapshot;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getMyDoubts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading==true?Loading():Scaffold(
        appBar: AppBar(
          title: Text(
            'My Videos',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body:showEmpty?
        Center(
          child: Text("Sorry, nothing to show here."),
        ): ListView.builder(
            itemCount: videos.documents.length,
            itemBuilder: (context, index) {
              return CardVideos(
                Title: videos.documents[index].data["title"],
                Description: videos.documents[index].data["description"],
                UploadDate: videos.documents[index].data["UploadDate"],
                Username: videos.documents[index].data["Username"],
                URL: videos.documents[index].data["file URL"],
                Tags: videos.documents[index].data["tags"],
                Uid: videos.documents[index].data["UID"],
                context: context,
                userUid: videos.documents[index].data["userUid"],
              );
            }));
  }
}
