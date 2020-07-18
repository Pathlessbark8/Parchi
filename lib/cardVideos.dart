import 'package:feedpage/VideosPostPage.dart';
import 'package:feedpage/globals.dart' as globals;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/OthersProfilePage.dart';
import 'package:flutter/material.dart';

class upvotes {
  String UID;
  int no;
  int up;
  bool isup;

  upvotes({this.UID});

  getData() async {
    final instance = Firestore.instance
        .collection('videos')
        .document(UID)
        .collection('upvotes');
    QuerySnapshot snapshot1 =
    await instance.where("value", isEqualTo: 1).getDocuments();
    QuerySnapshot snapshot2 =
    await instance.where("value", isEqualTo: -1).getDocuments();
    if (snapshot1 != null && snapshot2 != null) {
      no = snapshot1.documents.length - snapshot2.documents.length;
    } else {
      if (snapshot1 != null) {
        no = snapshot1.documents.length;
      } else if (snapshot2 != null) {
        no = snapshot2.documents.length;
      } else {
        no = 0;
      }
    }

    DocumentSnapshot snapshot =
    await instance.document(globals.currentUser.uid).get();
    if (snapshot == null || !snapshot.exists) {
      return null;
    }
    up = snapshot.data["value"];

    if (up == 1) {
      this.isup = true;
    } else {
      this.isup = false;
    }

    return this.isup;
  }

  SetData(bool upvote) async {
    if (upvote == null) {
      return await Firestore.instance
          .collection('videos')
          .document(UID)
          .collection('upvotes')
          .document(globals.currentUser.uid)
          .setData({
        "value": null,
      });
    } else if (upvote == true) {
      return await Firestore.instance
          .collection('videos')
          .document(UID)
          .collection('upvotes')
          .document(globals.currentUser.uid)
          .setData({
        "value": 1,
      });
    } else {
      return await Firestore.instance
          .collection('videos')
          .document(UID)
          .collection('upvotes')
          .document(globals.currentUser.uid)
          .setData({
        "value": -1,
      });
    }
  }
}

class CardVideos extends StatefulWidget {
  String Title;
  String Description;
  String UploadDate;
  String Username;
  String URL;
  List<dynamic> Tags;
  String Uid;
  BuildContext context;
  String userUid;

  CardVideos({
    this.Title,
    this.Description,
    this.UploadDate,
    this.Username,
    this.URL,
    this.Tags,
    this.Uid,
    this.context,
    this.userUid,
  });

  @override
  _CardVideosState createState() => _CardVideosState(
    Title: this.Title,
    Description: this.Description,
    UploadDate: this.UploadDate,
    Username: this.Username,
    up: null,
    bookmark: false,
    loading: true,
    userUid: this.userUid,
    watch: false,
  );
}

class _CardVideosState extends State<CardVideos> {
  bool up;
  bool bookmark;
  String Title;
  String Description;
  String Username;
  String UploadDate;
  bool loading;
  int no;
  String userUid;
  bool watch;

  _CardVideosState(
      {this.Title,
        this.Description,
        this.UploadDate,
        this.Username,
        this.up,
        this.bookmark,
        this.loading,
        this.userUid,
        this.watch});

  @override
  void initState() {
    if (globals.watchLaterUids.contains(widget.Uid)) {
      watch = true;
    }
    upvotes Upvotes = upvotes(UID: widget.Uid);
    Upvotes.getData().then((results) {
      setState(() {
        no = Upvotes.no;
        up = results;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
      padding: EdgeInsets.all(10.0),
      height: 100.0,
      child: Loading(),
    )
        : GestureDetector(
        onLongPress: () async {},
        onTap: () async {
          final result = await Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new VideosPostPage(
                    title: Title,
                    description: Description,
                    username: Username,
                    UploadDate: UploadDate,
                    URL: widget.URL,
                    Tags: widget.Tags,
                    up: this.up,
                    bookmark: this.bookmark,
                    UID: widget.Uid,
                    watch: this.watch,
                    userUid:this.userUid,
                  )));
          setState(() {
            this.up = result[0] != null ? result[0] : null;
            this.watch = result[1];
          });
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.play_circle_filled,
                        size: 40.0,
                        color: Colors.deepPurple,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              tooltip: 'Upvote',
                              icon: Icon(
                                Icons.arrow_upward,
                                color: up == null
                                    ? null
                                    : (up ? Colors.green : null),
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                  if (up == true) {
                                    up = null;
                                    no = no - 1;
                                  } else if (up == false) {
                                    up = true;
                                    no = no + 2;
                                  } else {
                                    up = true;
                                    no = no + 1;
                                  }
                                });
                                upvotes Upvote = upvotes(UID: widget.Uid);
                                await Upvote.SetData(up);
                                setState(() {
                                  loading = false;
                                });
                              },
                            ),
                          ),
                          Container(
                            child: Text(
                              '$no',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              tooltip: 'Downvote',
                              icon: Icon(
                                Icons.arrow_downward,
                                color: up == null
                                    ? null
                                    : (up ? null : Colors.red),
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                  if (up == false) {
                                    up = null;
                                    no = no + 1;
                                  } else if (up == true) {
                                    up = false;
                                    no = no - 2;
                                  } else {
                                    up = false;
                                    no = no - 1;
                                  }
                                });
                                upvotes Upvote = upvotes(UID: widget.Uid);
                                await Upvote.SetData(up);
                                setState(() {
                                  loading = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ]),
                Expanded(
                  flex: 6,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          Title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OthersProfilePage(
                                        uid: widget.userUid)));
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
                                Username,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          Description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        UploadDate,
                        style: TextStyle(
                            fontSize: 7.0,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        tooltip: 'Watch later',
                        icon: Icon(Icons.watch_later),
                        color: !watch ? null : Colors.indigo,
                        onPressed: () async {
                          if (watch) {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Remove this post from watch later?'),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          MaterialButton(
                                              elevation: 5.0,
                                              child: Text('OK'),
                                              onPressed: () {
                                                globals.watchLaterUids
                                                    .remove(widget.Uid);
                                                setState(() {
                                                  watch = false;
                                                });
                                                Navigator.pop(context);
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
                          } else {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Add this post to watch later?'),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          MaterialButton(
                                              elevation: 5.0,
                                              child: Text('OK'),
                                              onPressed: () {
                                                globals.watchLaterUids
                                                    .add(widget.Uid);
                                                setState(() {
                                                  watch = true;
                                                });
                                                Navigator.pop(context);
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
                          }
                          await Firestore.instance
                              .collection('watch_later')
                              .document(globals.currentUser.uid)
                              .setData({'list': globals.watchLaterUids});
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
                                    title:
                                    Text('Remove this post forever?'),
                                    actions: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          MaterialButton(
                                              elevation: 5.0,
                                              child: Text('OK'),
                                              onPressed: () async {
                                                await Firestore.instance
                                                    .collection('videos')
                                                    .document(widget.Uid)
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
                                  content: Text(
                                      'Post Deleted!! Refresh to see changes.'));
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
                                        (BuildContext context,
                                        StateSetter setState) {
                                      return loadingShow
                                          ? Loading()
                                          : Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.5,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.5,
                                        child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 5,
                                                child: ListView(
                                                    shrinkWrap: true,
                                                    children: values
                                                        .keys
                                                        .map((String
                                                    key) {
                                                      return CheckboxListTile(
                                                          title:
                                                          new Text(
                                                              key),
                                                          value:
                                                          values[
                                                          key],
                                                          onChanged: (bool
                                                          value) {
                                                            setState(
                                                                    () {
                                                                  values.forEach((key,
                                                                      value) {
                                                                    values[key] =
                                                                    false;
                                                                  });
                                                                  values[key] =
                                                                      value;
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
                                                child: ButtonBar(
                                                  alignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                          "Report"),
                                                      onPressed:
                                                          () async {
                                                        if (values
                                                            .containsValue(
                                                            true)) {
                                                          var key = values.keys.firstWhere(
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
                                                              _username,
                                                              _password);
                                                          final toSend = "Post with UID " +
                                                              widget
                                                                  .Uid +
                                                              "\nReported for" +
                                                              key;
                                                          final message =
                                                          Message()
                                                            ..from = Address(
                                                                _username)
                                                            ..recipients.add(
                                                                'dudechubs@gmail.com') //recipent email
                                                            ..ccRecipients
                                                                .addAll([
                                                              'dev.moxaj@gmail.com',
                                                              'Saicharanhahaha@gmail.com'
                                                            ]) //cc Recipents emails
                                                            ..subject =
                                                                'Report' //subject of the email
                                                            ..text =
                                                                toSend;
                                                          try {
                                                            setState(
                                                                    () {
                                                                  loadingShow =
                                                                  true;
                                                                });
                                                            await send(
                                                                message,
                                                                smtpServer);
                                                            setState(
                                                                    () {
                                                                  loadingShow =
                                                                  false;
                                                                });
                                                          } on MailerException catch (e) {
                                                            success =
                                                            false;
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        } else {
                                                          setState(
                                                                  () {
                                                                Error =
                                                                "Nothing chosen";
                                                              });
                                                        }
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text(
                                                          "Cancel"),
                                                      onPressed: () {
                                                        cancel = true;
                                                        Navigator.pop(
                                                            context,
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
                                    content: Text('Post reported.'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Something went wrong, try again.'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }
                          }
                        },
                        child: Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return <PopupMenuItem>[
                            (Username == globals.currentUser.username)
                                ? new PopupMenuItem(
                              value: 1,
                              child: Text('Delete'),
                            )
                                : new PopupMenuItem(
                                value: 2, child: Text('report'))
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
