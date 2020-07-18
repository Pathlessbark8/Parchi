import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/cardVideos.dart';
import 'package:flutter/material.dart';

class OthersVideos extends StatefulWidget {
  final uid;
  OthersVideos({this.uid});
  @override
  _OthersVideosState createState() => _OthersVideosState();
}

class _OthersVideosState extends State<OthersVideos> {
  bool isLoading=true;
  Firestore _firestore = Firestore.instance;
  QuerySnapshot videos;
  getMyDoubts() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('videos')
        .where("userUid", isEqualTo: widget.uid)
        .getDocuments();

    setState(() {
      videos = querySnapshot;
      isLoading=false;
    });
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
        body: ListView.builder(
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
