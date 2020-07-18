import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/loading.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:feedpage/globals.dart' as globals;

import 'crud.dart';

class CommentsList extends StatefulWidget {
  String UID;
  CommentsList({
    this.UID,
  });

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  QuerySnapshot comments;
  int length;

  @override
  void initState() {
    Firestore.instance
        .collection('doubts')
        .document(widget.UID)
        .collection("Comments")
        .getDocuments()
        .then((results) {
      setState(() {
        comments = results;
        length = comments.documents.length;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Answers",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.edit),
          label: Text('Write an Answer'),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new NewComment(
                          postUid: widget.UID,
                        )));
          },
        ),
        body: comments != null
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Comment(
                    userUID: comments.documents[index].data["UID"],
                    date: comments.documents[index].data["date"],
                    username: comments.documents[index].data["username"],
                    content: comments.documents[index].data["content"],
                    URL: comments.documents[index].data["URL"],
                  );
                },
                itemCount: length,
              )
            : Loading());
  }
}

class Comment extends StatefulWidget {
  String date;
  String username;
  String content;
  List<dynamic> URL;
  String userUID;

  Comment({
    this.date,
    this.URL,
    this.username,
    this.content,
    this.userUID,
  });

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Card(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                    label: Text(widget.username),
                  ),
                  Text(widget.date),
                ],
              ),
              Text(widget.content),
              (widget.URL == null)
                  ? Container()
                  : Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Wrap(
                          children: List<Widget>.generate(widget.URL.length,
                              (int index) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new FullImageView(
                                            URL: widget.URL[index].toString(),
                                          )));
                            },
                            child: Chip(
                              avatar: InkWell(
                                child: Icon(Icons.image),
                              ),
                              label: Text("Attachment ${index + 1}"),
                              labelPadding: EdgeInsets.all(8.0),
                              backgroundColor: Colors.blue,
                              labelStyle: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      })),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullImageView extends StatelessWidget {
  String URL;

  FullImageView({this.URL});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              child: PhotoView(
            imageProvider: NetworkImage(URL),
          )),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewComment extends StatefulWidget {
  String postUid;

  NewComment({this.postUid});

  @override
  _NewCommentState createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  File file;
  File ImgFile1;
  File ImgFile2;
  String fileString = '';
  bool isPopUpload = false;
  bool isLoading = false;
  bool isInternet;
  String error = "";
  String content;

  CheckInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        isInternet = false;
      });
    } else {
      setState(() {
        isInternet = true;
      });
    }
  }

  ShowNetConnectivityDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Container(
              height: 100,
              child: Image(
                image: AssetImage('assets/No_internet_image.png'),
                fit: BoxFit.contain,
              ),
            ),
            content: Text(
              'No Internet Connection',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ok',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))
            ],
          );
        });
  }

  Future<bool> exitUploadPage() async {
    if (ImgFile1 != null || ImgFile2 != null || content != null) {
      return showDialog(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Leave this page?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('All the data in this page may be lost'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  setState(() {
                    content = null;
                    globals.description = null;
                    isPopUpload = true;
                    fileString = '';
                  });

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    } else
      Navigator.of(context).pop(true);
  }

  Widget checkUpload1() {
    return ImgFile1 != null
        ? Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(width: 3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Image.file(ImgFile1)),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        ImgFile1 = ImgFile2;
                        ImgFile2 = null;
                      });
                    },
                  )
                ],
              ),
              Container(
                color: Colors.lightBlue[900],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                          onPressed: () async {
                            var result = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            setState(() {
                              ImgFile1 = File(result.path);
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Edit image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              ImgFile1 = ImgFile2;
                              ImgFile2 = null;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Discard image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          )
        : Container(
            child: Center(
              child: ButtonTheme(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lightBlue[900], width: 5)),
                  onPressed: () async {
                    var result = await ImagePicker()
                        .getImage(source: ImageSource.gallery);

                    setState(() {
                      ImgFile1 = File(result.path);
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 60,
                        color: Colors.green,
                      ),
                      Expanded(
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              'Attach an image',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  Widget checkUpload2() {
    return ImgFile2 != null
        ? Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[900],
                            border: Border.all(width: 3),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Image.file(ImgFile2)),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        ImgFile2 = null;
                      });
                    },
                  )
                ],
              ),
              Container(
                color: Colors.lightBlue[900],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                          onPressed: () async {
                            var result = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            setState(() {
                              ImgFile2 = File(result.path);
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Edit image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            setState(() {
                              ImgFile2 = null;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Discard image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          )
        : Container(
            child: Center(
              child: ButtonTheme(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lightBlue[900], width: 5)),
                  onPressed: () async {
                    var result = await ImagePicker()
                        .getImage(source: ImageSource.gallery);

                    setState(() {
                      ImgFile2 = File(result.path);
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 60,
                        color: Colors.green,
                      ),
                      Expanded(
                        child: Wrap(
                          children: <Widget>[
                            Text(
                              'Attach another image',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          );
  }

  void _showDialogSuccess() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Your Answer was Uploaded Successfully"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogFailure() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Failed"),
          content: new Text(
              "Your doubt could not be submitted due to some reason. Kindly try doing it again in sometime."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.lightBlue[50],
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await exitUploadPage();
                  if (isPopUpload) Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.lightBlue[700],
              title: Text('Upload Answer'),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                List<String> URLS = [];
                var dt = DateTime.now();
                String date = "${dt.day}-${dt.month}-${dt.year} ";
                String time =
                    "${dt.day}${dt.year}${dt.month}${dt.minute}${dt.second}${dt.hour}";

                await CheckInternetConnectivity();
                if (isInternet) {
                  if (content != null) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      if (ImgFile1 != null) {
                        final StorageReference firebaseStorageRef =
                            await FirebaseStorage.instance.ref().child(
                                '${globals.currentUser.uid}' +
                                    '$time' +
                                    '1' +
                                    '.jpg');

                        final StorageUploadTask task =
                            firebaseStorageRef.putFile(ImgFile1);
                        StorageTaskSnapshot storageTaskSnapshot =
                            await task.onComplete;
                        String img1Url =
                            await storageTaskSnapshot.ref.getDownloadURL();
                        URLS.add(img1Url);
                      }
                      if (ImgFile2 != null) {
                        final StorageReference firebaseStorageRef =
                            await FirebaseStorage.instance.ref().child(
                                '${globals.currentUser.uid}' +
                                    '$time' +
                                    '2' +
                                    '.jpg');

                        final StorageUploadTask task =
                            firebaseStorageRef.putFile(ImgFile2);
                        StorageTaskSnapshot storageTaskSnapshot =
                            await task.onComplete;
                        String img2Url =
                            await storageTaskSnapshot.ref.getDownloadURL();
                        URLS.add(img2Url);
                      }
                      await Firestore.instance
                          .collection('doubts')
                          .document(widget.postUid)
                          .collection("Comments")
                          .add({
                        "UID": globals.currentUser.uid,
                        "username": globals.currentUser.username,
                        "date": date,
                        "content": content,
                        "URL": URLS,
                      });
                      setState(() {
                        isLoading = false;
                      });
                      _showDialogSuccess();
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                      setState(() {
                        isLoading = false;
                        ImgFile1 = null;
                        ImgFile2 = null;
                        content = null;
                      });
                      _showDialogFailure();
                      Navigator.pop(context);
                    }
                  }
                } else {
                  ShowNetConnectivityDialog();
                }
              },
              backgroundColor: Colors.lightBlue[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.lightBlue[900], width: 3)),
              icon: Icon(Icons.file_upload),
              label: Text('Upload'),
            ),
            body: WillPopScope(
              onWillPop: exitUploadPage,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: TextField(
                        autofocus: false,
                        autocorrect: true,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'Write an answer',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.lightBlue[900]),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.lightBlue[900], width: 3),
                          ),
                        ),
                        onChanged: (String str) {
                          content = str;
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: 2,
                        )),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Optional:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Center(
                        child: checkUpload1(),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ImgFile1 != null
                        ? Container(
                            margin: EdgeInsets.all(10),
                            child: Center(
                              child: checkUpload2(),
                            ),
                          )
                        : SizedBox(
                            height: 5,
                          ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

//FlatButton(
//onPressed: () async {
//setState(() {
//isLoading = true;
//});
//List<String> URLS = [];
//var dt = DateTime.now();
//String date = "${dt.day}-${dt.month}-${dt.year} ";
//String time =
//    "${dt.day}${dt.year}${dt.month}${dt.minute}${dt.second}${dt.hour}";
//if (content != null) {
//try {
//if (img1 != null) {
//final StorageReference firebaseStorageRef =
//await FirebaseStorage.instance.ref().child(
//'${globals.currentUser.uid}' +
//'$time' +
//'1' +
//'.jpg');
//
//final StorageUploadTask task =
//firebaseStorageRef.putFile(img1);
//StorageTaskSnapshot storageTaskSnapshot =
//await task.onComplete;
//String img1Url = await storageTaskSnapshot.ref
//    .getDownloadURL();
//URLS.add(img1Url);
//}
//if (img2 != null) {
//final StorageReference firebaseStorageRef =
//await FirebaseStorage.instance.ref().child(
//'${globals.currentUser.uid}' +
//'$time' +
//'2' +
//'.jpg');
//
//final StorageUploadTask task =
//firebaseStorageRef.putFile(img2);
//StorageTaskSnapshot storageTaskSnapshot =
//await task.onComplete;
//String img2Url = await storageTaskSnapshot.ref
//    .getDownloadURL();
//URLS.add(img2Url);
//}
//await Firestore.instance
//    .collection('doubts')
//    .document(widget.postUid)
//    .collection("Comments")
//    .add({
//"UID": globals.currentUser.uid,
//"username": globals.currentUser.username,
//"date": date,
//"content": content,
//"URL": URLS,
//});
//setState(() {
//isLoading = false;
//completed = true;
//});
//await exitUploadPage();
////                      Navigator.pop(context);
//Navigator.of(context)
//    .pushReplacement(
//MaterialPageRoute(
//builder: (context) => CommentsList(
//UID: widget.postUid,
//),
//),
//)
//    .then((_) {
//setState() {}
//});
//} catch (e) {
//setState(() {
//completed = false;
//isLoading = false;
//});
//await exitUploadPage();
//Navigator.pop(context);
//}
//}
//},
//child: Row(
//children: <Widget>[
//Icon(Icons.add_comment),
//Text("Add comment"),
//],
//),
//),
