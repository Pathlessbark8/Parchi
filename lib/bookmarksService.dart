import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/globals.dart' as globals;

class bookmarksService{
  String Uid;
  bookmarksService({this.Uid});
  getData() async{
    return await Firestore.instance.collection('bookmarks').document(Uid).get();
  }
  setInitialData() async{
    return await Firestore.instance.collection('bookmarks').document(Uid).setData({
      'bookmarkUIDs': [],
      'bookmarkFiles': ['Default'],
      'bookmarkStructure': Map(),
    });
  }
  setData() async{
    return await Firestore.instance.collection('bookmarks').document(Uid).setData({
      'bookmarkUIDs': globals.bookmarkUIDs,
      'bookmarkFiles': globals.bookmarkFiles,
      'bookmarkStructure': globals.bookmarkStructure,
    });
  }
}