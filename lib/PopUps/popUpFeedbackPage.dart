import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PopUpFeedbackPage extends StatefulWidget {
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUpFeedbackPage> {
  File _imageFile;

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      var result = await ImagePicker().getImage(source: ImageSource.camera);
      image=File(result.path);
    } else {
      var result = await ImagePicker().getImage(source: ImageSource.gallery);
      image=File(result.path);
    }
    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Select from where you want to import picture'),
      content: new SingleChildScrollView(
        child: new Column(
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
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Back'),
            ),
            new FlatButton(
              onPressed: _imageFile == null
                  ? null
                  : () {
                Navigator.pop(context, _imageFile);
//                Navigator.pushReplacementNamed(context, "/Feedback", arguments: {
//                  'imageReceived': _imageFile,
//                });
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}