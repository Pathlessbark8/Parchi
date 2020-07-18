import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cardNotes.dart';

class OthersNotes extends StatefulWidget {
  final uid;
  OthersNotes({this.uid});
  @override
  _OthersNotesState createState() => _OthersNotesState();
}

class _OthersNotesState extends State<OthersNotes> {
  bool  isLoading=true;
  Firestore _firestore = Firestore.instance;
  QuerySnapshot notes;
  getMyNotes() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('notes')
        .where("userUid", isEqualTo: widget.uid)
        .getDocuments();
    if(this.mounted)
    setState(() {
      notes = querySnapshot;
      isLoading=false;
    });
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
            'Notes',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
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
