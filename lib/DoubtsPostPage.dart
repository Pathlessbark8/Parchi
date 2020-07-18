import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/OthersProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'cardDoubts.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:feedpage/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'PhotoViewerPage.dart';
import 'commentsDoubts.dart';
import 'package:feedpage/globals.dart' as globals;

class DoubtsPostPage extends StatefulWidget {
  bool up;
  bool bookmark;
  String title;
  String description;
  String UploadDate;
  String username;
  String URL1;
  String URL2;
  List<dynamic> Tags;
  String UID;
  String userUid;

  DoubtsPostPage({
    this.title,
    this.description,
    this.username,
    this.UploadDate,
    this.URL1,
    this.URL2,
    this.Tags,
    this.up,
    this.bookmark,
    this.UID,
    this.userUid,
  });

  @override
  _DoubtsPostPageState createState() => _DoubtsPostPageState();
}

class _DoubtsPostPageState extends State<DoubtsPostPage> {
  String ImageUrl = null;
  int imageNo = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: <Widget>[
            PopupMenuButton(
              color: Colors.black,
              initialValue: 0,
              onSelected: (value) async {
                if (value == 1) {
                  int result = 0;
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Remove this post forever?'),
                          actions: <Widget>[
                            Row(
                              children: <Widget>[
                                MaterialButton(
                                    elevation: 5.0,
                                    child: Text('OK'),
                                    onPressed: () async {
                                      await Firestore.instance
                                          .collection('doubts')
                                          .document(widget.UID)
                                          .delete();
                                      Navigator.pop(context);
                                      result = 1;
                                    }),
                                MaterialButton(
                                  elevation: 5.0,
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                  if (result == 1) {
                    final snackBar = SnackBar(
                        content:
                        Text('Post Deleted!! Refresh to see changes.'));
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                } else if (value == 2) {
                  bool loadingShow = false;
                  bool success = true;
                  bool cancel = false;
                  String Error = '';
                  Map<String, bool> values = {
                    'Inappropriate content': false,
                    'Copyrighted content': false,
                    'Spam or misleading': false,
                  };
                  await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return loadingShow
                                ? Loading()
                                : Container(
                              width:
                              MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height *
                                  0.5,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: ListView(
                                          shrinkWrap: true,
                                          children: values.keys
                                              .map((String key) {
                                            return CheckboxListTile(
                                                title: new Text(key),
                                                value: values[key],
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    values.forEach(
                                                            (key, value) {
                                                          values[key] = false;
                                                        });
                                                    values[key] = value;
                                                  });
                                                });
                                          }).toList()),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        Error,
                                        style:
                                        TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ButtonBar(
                                        alignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text("Report"),
                                            onPressed: () async {
                                              if (values
                                                  .containsValue(true)) {
                                                var key = values.keys
                                                    .firstWhere(
                                                        (k) =>
                                                    values[k] ==
                                                        true,
                                                    orElse: () =>
                                                    null);
                                                String _username =
                                                    "junk1234dds@gmail.com";
                                                String _password =
                                                    "dds@1234";
                                                final smtpServer = gmail(
                                                    _username, _password);
                                                final toSend =
                                                    "Post with UID " +
                                                        widget.UID +
                                                        "\nReported for" +
                                                        key;
                                                final message = Message()
                                                  ..from =
                                                  Address(_username)
                                                  ..recipients.add(
                                                      'dudechubs@gmail.com') //recipent email
                                                  ..ccRecipients.addAll([
                                                    'dev.moxaj@gmail.com',
                                                    'Saicharanhahaha@gmail.com'
                                                  ]) //cc Recipents emails
                                                  ..subject =
                                                      'Report' //subject of the email
                                                  ..text = toSend;
                                                try {
                                                  setState(() {
                                                    loadingShow = true;
                                                  });
                                                  await send(message,
                                                      smtpServer);
                                                  setState(() {
                                                    loadingShow = false;
                                                  });
                                                } on MailerException catch (e) {
                                                  success = false;
                                                }
                                                Navigator.pop(context);
                                              } else {
                                                setState(() {
                                                  Error =
                                                  "Nothing chosen";
                                                });
                                              }
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              cancel = true;
                                              Navigator.pop(
                                                  context, null);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            );
                          }),
                        );
                      });
                  if (!cancel) {
                    if (success) {
                      final snackBar =
                      SnackBar(content: Text('Post reported.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else {
                      final snackBar = SnackBar(
                          content: Text('Something went wrong, try again.'));
                      Scaffold.of(context).showSnackBar(snackBar);
                    }
                  }
                }
              },
              child: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return <PopupMenuItem>[
                  (widget.username == globals.currentUser.username)
                      ? new PopupMenuItem(
                    value: 1,
                    child: Text('Delete'),
                  )
                      : new PopupMenuItem(value: 2, child: Text('report'))
                ];
              },
            ),
          ],
          title: Text(
            'Doubts Post',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            tooltip: 'back',
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(5, 30, 5, 5),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Question by: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OthersProfilePage(uid: widget.userUid,)));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 18,
                          color: Colors.blue[700],
                        ),
                        Text(
                          widget.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'Q. ${widget.title}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red[700]),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (widget.URL1 != 'Image 1 not uploaded' ||
                  widget.URL2 != 'Image 2 not uploaded')
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onHorizontalDragUpdate:
                  (widget.URL2 != 'Image 2 not uploaded')
                      ? (details) {
                    if (details.delta.dx < 0) {
                      setState(() {
                        ImageUrl = widget.URL2;
                        imageNo = 2;
                      });
                    } else if (details.delta.dx > 0) {
                      setState(() {
                        ImageUrl = widget.URL1;
                        imageNo = 1;
                      });
                    }
                  }
                      : (details) {},
                  child: Container(
                    height: 500,
                    padding: EdgeInsets.all(15),
                    color: Colors.blueGrey,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: 'Image$imageNo',
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PhotoViewerPage(
                                                ImageUrl == null
                                                    ? widget.URL1
                                                    : ImageUrl,
                                                imageNo)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: ImageUrl == null
                                    ? Image.network(
                                  widget.URL1,
                                  fit: BoxFit.contain,
                                )
                                    : Image.network(
                                  ImageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.white,
                              child: Text(
                                (widget.URL2 != 'Image 2 not uploaded')
                                    ? '$imageNo/2'
                                    : '$imageNo/1',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text('Tags:'),
                  SizedBox(
                    width: 5,
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: List<Widget>.generate(
                      widget.Tags.length,
                          (int index) {
                        return Chip(
                          label: Text(
                            widget.Tags[index],
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.view_list),
          label: Text('View Answers'),
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new CommentsList(
                  UID: widget.UID,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
