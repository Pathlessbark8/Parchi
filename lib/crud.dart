import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notesUploadClass.dart';
import 'doubtsUploadClass.dart';
import 'videosUploadClass.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'globals.dart' as globals;

class notesCrudMethods {
  Future<void> addData(notesUpload ob) async {
    var dt = DateTime.now();
    String time =
        "${dt.day}${dt.year}${dt.month}${dt.minute}${dt.second}${dt.hour}";
    String UploadDate = "${dt.day}-${dt.month}-${dt.year} ";
    String UID = '${globals.currentUser.uid}$time';
    Firestore.instance.collection('notes').document(UID).setData({
      "title": ob.title,
      "description": ob.description,
      "tags": ob.tags,
      "file URL": ob.fileURL,
      "UID": UID,
      "UploadDate": UploadDate,
      "Username": globals.currentUser.username,
      "userUid": '${globals.currentUser.uid}',
    }).catchError((e) {
      print(e);
    });
  }

  DocumentSnapshot lastDocument;

  getDataRecent() async {
    return await Firestore.instance
        .collection('notes')
        .orderBy("UploadDate", descending: globals.isDescending)
        .limit(5)
        .getDocuments();
  }

  getMoreDataRecent() async {
    return await Firestore.instance
        .collection('notes')
        .orderBy("UploadDate", descending: globals.isDescending)
        .startAfterDocument(lastDocument)
        .limit(5)
        .getDocuments();
  }
}

class doubtsCrudMethods {
  Future<void> addData(doubtsUpload ob) async {
    var dt = DateTime.now();
    String UploadDate = "${dt.day}-${dt.month}-${dt.year} ";
    String time =
        "${dt.day}${dt.year}${dt.month}${dt.minute}${dt.second}${dt.hour}";
    Firestore.instance
        .collection('doubts')
        .document('${globals.currentUser.uid}$time')
        .setData({
      "doubt": ob.doubt,
      "tags": ob.tags,
      "img URL1": ob.imgFileURL1,
      "img URL2": ob.imgFileURL2,
      "UploadDate": UploadDate,
      "Username": globals.currentUser.username,
      "UID": '${globals.currentUser.uid}$time',
      "userUid": '${globals.currentUser.uid}',
    }).catchError((e) {
      print(e);
    });
  }

  getSearchedDataRecent() async {
    return await Firestore.instance
        .collection('doubts')
        .where("tags", arrayContains: globals.SearchDoubtsByTag)
        .getDocuments();
  }
}

Future<String> getDownloadURL(
    File file, String type, String storageName) async {
  final StorageReference firebaseStorageRef =
      await FirebaseStorage.instance.ref().child('${storageName}.$type');

  final StorageUploadTask task = firebaseStorageRef.putFile(file);
  StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
  String Url = await storageTaskSnapshot.ref.getDownloadURL();
  return Url;
}

class videosCrudMethods {
  Future<void> addData(videosUpload ob) async {
    var dt = DateTime.now();
    String time =
        "${dt.day}${dt.year}${dt.month}${dt.minute}${dt.second}${dt.hour}";
    String UploadDate = "${dt.day}-${dt.month}-${dt.year} ";
    String UID = '${globals.currentUser.uid}$time';
    Firestore.instance.collection('videos').document(UID).setData({
      "title": ob.title,
      "description": ob.description,
      "tags": ob.tags,
      "file URL": ob.fileURL,
      "UID": UID,
      "UploadDate": UploadDate,
      "Username": globals.currentUser.username,
      "userUid": '${globals.currentUser.uid}',
    }).catchError((e) {
      print(e);
    });
  }

  DocumentSnapshot lastDocument;

  getDataRecent() async {
    return await Firestore.instance
        .collection('videos')
        .orderBy("UploadDate", descending: globals.isDescending)
        .limit(5)
        .getDocuments();
  }

  getMoreDataRecent() async {
    return await Firestore.instance
        .collection('videos')
        .orderBy("UploadDate", descending: globals.isDescending)
        .startAfterDocument(lastDocument)
        .limit(5)
        .getDocuments();
  }
}
