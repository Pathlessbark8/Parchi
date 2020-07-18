import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cardNotes.dart';
import 'globals.dart' as globals;

class MyNotes extends StatefulWidget {
  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  bool  isLoading=true;
  bool showEmpty=false;
  Firestore _firestore = Firestore.instance;
  QuerySnapshot notes;
  getMyNotes() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('notes')
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
        notes = querySnapshot;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getMyNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading==true?Loading():Scaffold(
        appBar: AppBar(
          title: Text(
            'My Notes',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body:showEmpty?
        Center(
          child: Text("Sorry, nothing to show here."),
        ): ListView.builder(
            itemCount: notes.documents.length,
            itemBuilder: (context, index) {
              return CardNotes(
                Title: notes.documents[index].data["title"],
                Description: notes.documents[index].data["description"],
                UploadDate: notes.documents[index].data["UploadDate"],
                Username: notes.documents[index].data["Username"],
                URL: notes.documents[index].data["file URL"],
                Tags: notes.documents[index].data["tags"],
                Uid: notes.documents[index].data["UID"],
                userUid: notes.documents[index].data["userUid"],
              );
            }));
  }
}
