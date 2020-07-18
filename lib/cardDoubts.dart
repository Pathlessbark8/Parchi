import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'DoubtsPostPage.dart';
import 'package:feedpage/globals.dart' as globals;
import 'package:feedpage/OthersProfilePage.dart';

class upvotes {
  String UID;
  int no;
  int up;
  bool isup;

  upvotes({this.UID});

  getData() async {
    final instance = Firestore.instance
        .collection('doubts')
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
          .collection('doubts')
          .document(UID)
          .collection('upvotes')
          .document(globals.currentUser.uid)
          .setData({
        "value": null,
      });
    } else if (upvote == true) {
      return await Firestore.instance
          .collection('doubts')
          .document(UID)
          .collection('upvotes')
          .document(globals.currentUser.uid)
          .setData({
        "value": 1,
      });
    } else {
      return await Firestore.instance
          .collection('doubts')
          .document(UID)
          .collection('upvotes')
          .document(globals.currentUser.uid)
          .setData({
        "value": -1,
      });
    }
  }
}

class CardDoubts extends StatefulWidget {
  String Doubt;
  String UploadDate;
  String Username;
  String URL1;
  String URL2;
  List<dynamic> Tags;
  String UID;
  String userUid;
  CardDoubts({
    this.Doubt,
    this.UploadDate,
    this.Username,
    this.URL1,
    this.URL2,
    this.Tags,
    this.UID,
    this.userUid,
  });

  @override
  _CardDoubtsState createState() => _CardDoubtsState(
    Doubt: this.Doubt,
    UploadDate: this.UploadDate,
    Username: this.Username,
    up: null,
    bookmark: false,
    loading: true,
    userUid: this.userUid,
  );
}

class _CardDoubtsState extends State<CardDoubts> {
  bool up;
  bool bookmark;
  String Doubt;
  String Username;
  String UploadDate;
  bool loading = true;
  int no;
  String userUid;
  _CardDoubtsState({
    this.Doubt,
    this.UploadDate,
    this.Username,
    this.up,
    this.bookmark,
    this.loading,
    this.userUid,
  });

  @override
  void initState() {
    upvotes Upvotes = upvotes(UID: widget.UID);
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
    return (loading)
        ? Container(
      padding: EdgeInsets.all(10.0),
      height: 150.0,
      child: Loading(),
    )
        : GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DoubtsPostPage(
                    title: Doubt,
                    username: Username,
                    UploadDate: UploadDate,
                    URL1: widget.URL1,
                    URL2: widget.URL2,
                    Tags: widget.Tags,
                    up: this.up,
                    bookmark: this.bookmark,
                    UID: widget.UID,
                    userUid:this.userUid,
                  )));
        },
        child: Card(
          elevation: 1,
          child: Container(
            height: 150,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          upvotes Upvote = upvotes(UID: widget.UID);
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
                      ),
                    ),
                    Container(
                      child: IconButton(
                        tooltip: 'Downvote',
                        icon: Icon(
                          Icons.arrow_downward,
                          color:
                          up == null ? null : (up ? null : Colors.red),
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
                          upvotes Upvote = upvotes(UID: widget.UID);
                          await Upvote.SetData(up);
                          setState(() {
                            loading = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
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
                              Text(
                                'Question by: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.account_circle,
                                size: 12,
                                color: Colors.blue[700],
                              ),
                              Text(
                                Username,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Q: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.red)),
                              TextSpan(
                                  text: ' $Doubt',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
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
                                                                  .UID +
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
