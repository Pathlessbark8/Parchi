import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:feedpage/Profile.dart';
import 'package:feedpage/globals.dart' as globals;
import 'package:feedpage/userService.dart';
import 'package:path/path.dart';
import 'dart:io';

class Uploader extends StatefulWidget {
  final File imageFile;

  Uploader({this.imageFile});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  void uploadPic(context) async {
    String fileName = basename(widget.imageFile.path);
    StorageReference fireBaseStorage =
        FirebaseStorage.instance.ref().child(fileName);

    StorageUploadTask uploadTask = fireBaseStorage.putFile(widget.imageFile);
    print("a upload");
    StorageTaskSnapshot takeSnapShot = await uploadTask.onComplete;
    print("b upload");
    UserService(uid: globals.currentUser.uid)
        .setUrl(await fireBaseStorage.getDownloadURL());
    print("c upload");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Profile()));
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      uploadPic(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitSquareCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
