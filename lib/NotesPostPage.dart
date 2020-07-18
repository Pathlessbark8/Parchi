import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/bookmarksAlert.dart';
import 'package:feedpage/bookmarksService.dart';
import 'package:feedpage/cardNotes.dart';
import 'package:feedpage/commentsNotes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:feedpage/loading.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:feedpage/globals.dart' as globals;

import 'OthersProfilePage.dart';

class PostPage extends StatefulWidget {
  bool up;
  bool bookmark;
  String title;
  String description;
  String UploadDate;
  String username;
  String URL;
  List<dynamic> Tags;
  String UID;
  final ValueNotifier<bool> comments = ValueNotifier<bool>(false);
  String userUid;

  PostPage({
    this.title,
    this.description,
    this.username,
    this.UploadDate,
    this.URL,
    this.Tags,
    this.up,
    this.bookmark,
    this.UID,
    this.userUid
  });

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isLoading = true;
  PDFDocument document;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.URL);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.UID);
    return MaterialApp(
      home: Scaffold(
        body: _isLoading
            ? Center(child: Loading())
            : Stack(children: <Widget>[
          ListView(
            controller: _scrollController,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                          new PdfView(document: document)));
                },
                child: Container(
                  height: 400.0,
                  child: Stack(children: <Widget>[
                    PDFViewer(
                      document: document,
                      zoomSteps: 1,
                      //uncomment below line to preload all pages
                      // lazyLoad: false,
                      // uncomment below line to scroll vertically
                      // scrollDirection: Axis.vertical,

                      //uncomment below code to replace bottom navigation with your own
                      navigationBuilder: (context, page, totalPages,
                          jumpToPage, animateToPage) {
                        return Container(
                          height: 50.0,
                          color: Colors.grey[200],
                          child: ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                tooltip: 'Upvote',
                                icon: Icon(
                                  Icons.arrow_upward,
                                  color: widget.up == null
                                      ? null
                                      : (widget.up ? Colors.green : null),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                    if (widget.up == true) {
                                      widget.up = null;
                                    } else {
                                      widget.up = true;
                                    }
                                  });
                                  upvotes Upvote =
                                  upvotes(UID: widget.UID);
                                  await Upvote.SetData(widget.up);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                              IconButton(
                                tooltip: 'Downvote',
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: widget.up == null
                                      ? null
                                      : (widget.up ? null : Colors.red),
                                ),
                                onPressed: () async {
                                  _isLoading = true;
                                  setState(() {
                                    if (widget.up == false) {
                                      widget.up = null;
                                    } else {
                                      widget.up = false;
                                    }
                                  });
                                  upvotes Upvote =
                                  upvotes(UID: widget.UID);
                                  await Upvote.SetData(widget.up);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 30.0,
                              ),
                              IconButton(
                                  tooltip: 'Bookmark',
                                  icon: Icon(
                                    widget.bookmark
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: widget.bookmark
                                        ? Colors.yellow
                                        : null,
                                  ),
                                  onPressed: () async {
                                    if (!widget.bookmark) {
                                      var result =
                                      await ShowBookmarkAlert(
                                          context);
                                      if (result != null) {
                                        globals.bookmarkUIDs
                                            .add(widget.UID);
                                        if (globals.bookmarkStructure[
                                        result] ==
                                            null) {
                                          globals.bookmarkStructure[
                                          result] = [widget.UID];
                                        } else {
                                          List temp = globals
                                              .bookmarkStructure[result];
                                          temp.add(widget.UID);
                                          globals.bookmarkStructure[
                                          result] = temp;
                                        }

                                        setState(() {
                                          widget.bookmark = true;
                                        });
                                      }
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Remove this post from bookmarks?'),
                                              actions: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    MaterialButton(
                                                        elevation: 5.0,
                                                        child: Text('OK'),
                                                        onPressed: () {
                                                          globals
                                                              .bookmarkUIDs
                                                              .remove(widget
                                                              .UID);
                                                          globals
                                                              .bookmarkStructure
                                                              .keys
                                                              .forEach(
                                                                  (element) {
                                                                List temp = globals
                                                                    .bookmarkStructure[
                                                                element];
                                                                if (temp.contains(
                                                                    widget
                                                                        .UID)) {
                                                                  temp.remove(
                                                                      widget
                                                                          .UID);
                                                                  globals.bookmarkStructure[
                                                                  element] =
                                                                      temp;
                                                                }
                                                              });
                                                          setState(() {
                                                            widget.bookmark =
                                                            false;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                    MaterialButton(
                                                      elevation: 5.0,
                                                      child:
                                                      Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                    await bookmarksService(
                                        Uid: globals.currentUser.uid)
                                        .setData();
                                  }),
                              IconButton(
                                tooltip: 'Download',
                                icon: Icon(
                                  Icons.file_download,
                                ),
                                onPressed: () async {
                                  disablePathProviderPlatformOverride =
                                  true;
                                  var status =
                                  await Permission.storage.status;

                                  if (status.isUndetermined) {
                                    // You can request multiple permissions at once.
                                    Map<Permission, PermissionStatus>
                                    statuses = await [
                                      Permission.storage,
                                    ].request();
                                    if (statuses[Permission.storage]
                                        .isGranted) {
                                      final externalDir =
                                      await getExternalStorageDirectory();

                                      final id =
                                      await FlutterDownloader.enqueue(
                                        url: widget.URL,
                                        savedDir: externalDir.path,
                                        fileName: widget.title + '.pdf',
                                        showNotification: true,
                                        openFileFromNotification: true,
                                      );
                                    }
                                  } else if (status.isGranted) {
                                    final externalDir =
                                    await getExternalStorageDirectory();

                                    final id =
                                    await FlutterDownloader.enqueue(
                                      url: widget.URL,
                                      savedDir: externalDir.path,
                                      fileName: widget.title,
                                      showNotification: true,
                                      openFileFromNotification: true,
                                    );
                                  } else {
                                    Map<Permission, PermissionStatus>
                                    statuses = await [
                                      Permission.storage,
                                    ].request();
                                    if (statuses[Permission.storage]
                                        .isGranted) {
                                      final externalDir =
                                      await getExternalStorageDirectory();

                                      final id =
                                      await FlutterDownloader.enqueue(
                                        url: widget.URL,
                                        savedDir: externalDir.path,
                                        fileName: widget.title,
                                        showNotification: true,
                                        openFileFromNotification: true,
                                      );
                                    }
                                  }
                                },
                              ),
                              PopupMenuButton(
                                initialValue: 0,
                                onSelected: (value) async {
                                  if (value == 1) {
                                    int result = 0;
                                    await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Remove this post forever?'),
                                            actions: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  MaterialButton(
                                                      elevation: 5.0,
                                                      child: Text('OK'),
                                                      onPressed:
                                                          () async {
                                                        await Firestore
                                                            .instance
                                                            .collection(
                                                            'notes')
                                                            .document(
                                                            widget
                                                                .UID)
                                                            .delete();
                                                        Navigator.pop(
                                                            context);
                                                        result = 1;
                                                      }),
                                                  MaterialButton(
                                                    elevation: 5.0,
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        });
                                    if (result == 1) {
                                      final snackBar = SnackBar(
                                          content: Text(
                                              'Post Deleted!! Refresh to see changes.'));
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  } else if (value == 2) {
                                    bool loadingShow = true;
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
                                            content: StatefulBuilder(
                                                builder:
                                                    (BuildContext context,
                                                    StateSetter
                                                    setState) {
                                                  return loadingShow
                                                      ? Loading()
                                                      : Container(
                                                    width: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .width *
                                                        0.5,
                                                    height: MediaQuery.of(
                                                        context)
                                                        .size
                                                        .height *
                                                        0.5,
                                                    child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize
                                                            .min,
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 5,
                                                            child: ListView(
                                                                shrinkWrap: true,
                                                                children: values.keys.map((String key) {
                                                                  return CheckboxListTile(
                                                                      title: new Text(key),
                                                                      value: values[key],
                                                                      onChanged: (bool value) {
                                                                        setState(() {
                                                                          values.forEach((key, value) {
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
                                                              style: TextStyle(
                                                                  color:
                                                                  Colors.red),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child:
                                                            ButtonBar(
                                                              alignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: <
                                                                  Widget>[
                                                                FlatButton(
                                                                  child:
                                                                  Text("Report"),
                                                                  onPressed:
                                                                      () async {
                                                                    if (values.containsValue(true)) {
                                                                      var key = values.keys.firstWhere((k) => values[k] == true, orElse: () => null);
                                                                      String _username =
                                                                          "junk1234dds@gmail.com";
                                                                      String _password =
                                                                          "dds@1234";
                                                                      final smtpServer = gmail(_username, _password);
                                                                      final toSend = "Post with UID " + widget.UID + "\nReported for" + key;
                                                                      final message =
                                                                      Message()
                                                                        ..from = Address(
                                                                            _username)
                                                                        ..recipients.add(
                                                                            'dudechubs@gmail.com') //recipent email
                                                                        ..ccRecipients.addAll([
                                                                          'dev.moxaj@gmail.com',
                                                                          'Saicharanhahaha@gmail.com'
                                                                        ]) //cc Recipents emails
                                                                        ..subject = 'Report' //subject of the email
                                                                        ..text = toSend;
                                                                      try {
                                                                        setState(() {
                                                                          loadingShow = true;
                                                                        });
                                                                        await send(message, smtpServer);
                                                                        setState(() {
                                                                          loadingShow = false;
                                                                        });
                                                                      } on MailerException catch (e) {
                                                                        success = false;
                                                                      }
                                                                      Navigator.pop(context);
                                                                    } else {
                                                                      setState(() {
                                                                        Error = "Nothing chosen";
                                                                      });
                                                                    }
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child:
                                                                  Text("Cancel"),
                                                                  onPressed:
                                                                      () {
                                                                    cancel =
                                                                    true;
                                                                    Navigator.pop(context,
                                                                        null);
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
                                        final snackBar = SnackBar(
                                            content:
                                            Text('Post reported.'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        final snackBar = SnackBar(
                                            content: Text(
                                                'Something went wrong, try again.'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  }
                                },
                                child: Icon(Icons.more_vert),
                                itemBuilder: (context) {
                                  return <PopupMenuItem>[
                                    (widget.username ==
                                        globals.currentUser.username)
                                        ? new PopupMenuItem(
                                      value: 1,
                                      child: Text('Delete'),
                                    )
                                        : new PopupMenuItem(
                                        value: 2,
                                        child: Text('report'))
                                  ];
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 70,
                      right: 20,
                      child: IconButton(
                        tooltip: 'Full Screen',
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                  new PdfView(document: document)));
                        },
                        icon: Icon(
                          Icons.fullscreen,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OthersProfilePage(uid: widget.userUid)));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          size: 20,
                          color: Colors.blue[700],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.username,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    widget.UploadDate,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[650],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Wrap(
                  children: List<Widget>.generate(widget.Tags.length,
                          (int index) {
                        return Padding(
                          padding: index == 0
                              ? EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0)
                              : EdgeInsets.all(8.0),
                          child: Chip(
                            label: Text(widget.Tags[index].toString()),
                            labelPadding: EdgeInsets.all(8.0),
                            backgroundColor: Colors.blue,
                            labelStyle: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        );
                      })),
              ExpansionTile(
                trailing: Icon(Icons.arrow_drop_down),
                title: GestureDetector(
                    onTap: () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.easeInOut);
                    },
                    child: Text("Comments")),
                children: <Widget>[
                  Container(
                      height: 400.0,
                      child: CommentsList(
                        UID: widget.UID,
                      ))
                ],
              ),
              //       FlatButton(
              //      child: Text("Show comments"),
              //       onPressed: (){
              //         Navigator.push(
              //           context,
              //           new MaterialPageRoute(
              //                builder: (context) => new CommentsList(
              //               UID: widget.UID,
              //            )));
              //      },
              //   ),
            ],
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              tooltip: 'back',
              onPressed: () {
                Navigator.pop(context, [widget.up, widget.bookmark]);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
        ]),
        //      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //      floatingActionButton: FloatingActionButton.extended(
        //       icon: Icon(Icons.view_list),
        //        label: Text('View Answers'),
        //            onPressed: () {
        //          Navigator.push(
        //              context,
        //             new MaterialPageRoute(
        //                  builder: (context) => new CommentsList(
        //                     UID: widget.UID,
        //                      )));
        //        },
        //      ),
      ),
    );
  }
}

class PdfView extends StatefulWidget {
  PDFDocument document;

  PdfView({this.document});

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        PDFViewer(
          document: widget.document,
          zoomSteps: 1,
        ),
        Positioned(
          top: 15,
          left: 10,
          child: IconButton(
            tooltip: 'Exit full screen',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.fullscreen_exit,
            ),
          ),
        ),
      ]),
    );
  }
}
