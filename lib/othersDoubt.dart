import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cardDoubts.dart';

class OthersDoubts extends StatefulWidget {
  final uid;
  OthersDoubts({this.uid});
  @override
  _OthersDoubtsState createState() => _OthersDoubtsState();
}

class _OthersDoubtsState extends State<OthersDoubts> {
  bool isLoading=true;
  Firestore _firestore = Firestore.instance;
  QuerySnapshot doubts;
  getMyDoubts() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('doubts')
        .where("userUid", isEqualTo: widget.uid)
        .getDocuments();

    if(this.mounted) {
      setState(() {
        doubts = querySnapshot;
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
            'Doubts',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
            itemCount: doubts.documents.length,
            itemBuilder: (context, index) {
              return CardDoubts(
                Doubt: doubts.documents[index].data["doubt"],
                UploadDate: doubts.documents[index].data["UploadDate"],
                Username: doubts.documents[index].data["Username"],
                URL1: doubts.documents[index].data["img URL1"],
                URL2: doubts.documents[index].data["img URL2"],
                Tags: doubts.documents[index].data["tags"],
                UID: doubts.documents[index].data["UID"],
                userUid: doubts.documents[index].data["userUid"],
              );
            }));
  }
}
