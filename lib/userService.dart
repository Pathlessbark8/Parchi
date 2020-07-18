import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/user.dart';

class UserService {
   final String uid;
final  String username;
  UserService({this.uid,this.username});

  // user collection
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  Future updateUserData(String email, String username, bool gmail_user) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'email': email,
      'username': username,
      'gmail_user': gmail_user,
      'url': "https://firebasestorage.googleapis.com/v0/b/notes-forum-8e15b.appspot.com/o/profilepic.jpg?alt=media&token=ead8c2bd-59ff-459e-95b8-e3295ac1b8cd",
      'interests': List<dynamic>(),
    });
  }

  Future getData() async {
    try {
      DocumentSnapshot doc = await userCollection.document(uid).get();
      return User_Data.fromDocument(doc);
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future setUrl(String url) async {
    try {
      return userCollection.document(uid).updateData({
        'url': url,
      });
    } catch (e) {
      return null;
    }
  }

  Future setInterests(List<dynamic> interests) async {
    try {
      return userCollection.document(uid).updateData({
        'interests': interests,
      });
    } catch (e) {
      return null;
    }
  }
}
