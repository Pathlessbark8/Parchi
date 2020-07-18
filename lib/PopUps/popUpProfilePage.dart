import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/Profile.dart';
import 'package:feedpage/uploader.dart';
import 'package:feedpage/userService.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:feedpage/home.dart';
import 'package:feedpage/globals.dart' as globals;
import 'package:path/path.dart';

class PopUpProfilePage extends StatefulWidget {
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUpProfilePage> {
  File _imageFile;

  bool loading = false;

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      // ignore: deprecated_member_use
      var result = await ImagePicker.pickImage(source: ImageSource.camera);
      image = File(result.path);
    } else {
      var result = await ImagePicker().getImage(source: ImageSource.gallery);
      image = File(result.path);
    }
    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("PopUp");

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_imageFile.path);
      StorageReference fireBaseStorage =
          FirebaseStorage.instance.ref().child(fileName);

      StorageUploadTask uploadTask = fireBaseStorage.putFile(_imageFile);
//  print("a upload");
      StorageTaskSnapshot takeSnapShot = await uploadTask.onComplete;
//  print("b upload");
      UserService(uid: globals.currentUser.uid)
          .setUrl(await fireBaseStorage.getDownloadURL());
//  print("c upload");
    }

    return loading == true
        ? Loading()
        : AlertDialog(
            title: Text('Select from where you want to import picture'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Camera'),
                    onPressed: () {
                      getImage(true);
                    },
                  ),
                  RaisedButton(
                    child: Text('Gallery'),
                    onPressed: () {
                      getImage(false);
                    },
                  ),
                  _imageFile == null ? Container() : Image.file(_imageFile),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    textColor: Theme.of(context).primaryColor,
                    child: Text('Back'),
                  ),
                  FlatButton(
                    onPressed: _imageFile == null
                        ? null
                        : () async {
                            Navigator.of(context).pop();
//                setState(() {
//                  loading=true;
//                  print("mm");
//                });
                            await uploadPic(context);

//                                Navigator.pushReplacement(context,  MaterialPageRoute(
//                    builder: (context) =>
//                     Uploader(imageFile: _imageFile))
//                );
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          },
                    textColor: Colors.black,
                    child: Text('Done'),
                  ),
                ],
              ),
            ],
          );
  }
}
