import 'package:cloud_firestore/cloud_firestore.dart';


class User {

  final String uid ;
  bool isVerified;

  User( {this.uid, this.isVerified} );

}

class User_Data {

  final String uid;

  final String email;

  final String username;

  final bool gmail_user;

  String url;
  List<dynamic> interests;

  User_Data(
      { this.uid, this.email, this.username, this.gmail_user, this.url, this.interests });


  factory User_Data.fromDocument(DocumentSnapshot doc) {
    return User_Data(
      uid: doc['uid'],
      email: doc['email'],
      username: doc['username'],
      gmail_user: doc['gmail_user'],
      url: doc['url'],
      interests: doc['interests'],
    );
  }
}