import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/cardVideos.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/globals.dart'as globals;



class WatchLaterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Later"),
        backgroundColor: Colors.blue[400],
      ),
      body: WatchLater(),
    );
  }
}


class WatchLater extends StatefulWidget {
  @override
  _WatchLaterState createState() => _WatchLaterState();
}

class _WatchLaterState extends State<WatchLater> {


  bool showEmpty = false;
  QuerySnapshot notes;

  @override
  void initState() {
    if(globals.watchLaterUids==null){
      setState(() {
        showEmpty = true;
      });
    }
    else if (globals.watchLaterUids.isEmpty) {
      setState(() {
        showEmpty = true;
      });
    }
    else {
      Firestore.instance
          .collection('videos')
          .where('UID', whereIn: globals.watchLaterUids)
          .getDocuments()
          .then((value) {
        setState(() {
          notes = value;
        });
      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if (showEmpty) {
      return Center(
        child: Text("Sorry, nothing to show here."),
      );
    } else {
      if (notes == null) {
        return Loading();
      } else {
        return ListView.builder(
            itemCount: notes.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return CardVideos(
                Title: notes.documents[index].data["title"],
                Description: notes.documents[index].data["description"],
                UploadDate: notes.documents[index].data["UploadDate"],
                Username: notes.documents[index].data["Username"],
                URL: notes.documents[index].data["file URL"],
                Tags: notes.documents[index].data["tags"],
                Uid: notes.documents[index].data["UID"],
              );
            });
      }
    }
  }
}
