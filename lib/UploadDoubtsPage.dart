import 'package:connectivity/connectivity.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/NavigationPage.dart';
import 'doubtsUploadClass.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'globals.dart' as globals;
import 'crud.dart';
import 'TagsSearchBar.dart';

class UploadDoubtsPage extends StatefulWidget {
  @override
  _UploadDoubtsPageState createState() => _UploadDoubtsPageState();
}

class _UploadDoubtsPageState extends State<UploadDoubtsPage> {
  File file;
  File ImgFile1;
  File ImgFile2;
  List fileTags = [];
  String fileString = '';
  bool isPopUpload = false;
  bool isLoading = false;
  bool isInternet;
  String error = "";

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

  doubtsCrudMethods crudObj = new doubtsCrudMethods();

  void UploadPagetoggle() {
    setState(() {
      fileTags = globals.tag;
    });
  }

  Future<bool> exitUploadPage() async {
    if (ImgFile1 != null ||
        ImgFile2 != null ||
        globals.doubt != null ||
        globals.description != null ||
        globals.tag.isNotEmpty) {
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
                    globals.tag = [];
                    fileTags = [];
                    globals.doubt = null;
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
          content: new Text("Doubt was Uploaded Successfully"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => NavigationPage(
                              pageToReload: 1,
                            )));
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
    print(isLoading);
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
              title: Text('Upload Doubts'),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await CheckInternetConnectivity();
                if (isInternet) {
                  print("doubt");
                  print(globals.doubt);
                  print(globals.tag);
                  if (globals.doubt != null && globals.tag.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      String ImgUrl1, ImgUrl2;
                      if (ImgFile2 != null) {
                        ImgUrl1 = await getDownloadURL(
                            ImgFile1, 'jpg', '${globals.doubt}1');
                        ImgUrl2 = await getDownloadURL(
                            ImgFile2, 'jpg', '${globals.doubt}2');
                      } else if (ImgFile1 != null) {
                        ImgUrl1 = await getDownloadURL(
                            ImgFile1, 'jpg', '${globals.doubt}1');
                        ImgUrl2 = 'Image 2 not uploaded';
                      } else {
                        ImgUrl1 = 'Image 1 not uploaded';
                        ImgUrl2 = 'Image 2 not uploaded';
                      }

                      doubtsUpload ob = doubtsUpload(
                          globals.doubt,
                          this.fileTags,
                          ImgUrl1,
                          this.ImgFile1,
                          ImgUrl2,
                          this.ImgFile2);

                      await crudObj.addData(ob);

                      setState(() {
                        isLoading = false;
                        ImgFile1 = null;
                        ImgFile2 = null;
                        globals.tag = [];
                        fileTags = [];
                        globals.doubt = null;
                      });
                      _showDialogSuccess();
                    } catch (e) {
                      print("error");
                      print(e);
                      setState(() {
                        isLoading = false;
                        ImgFile1 = null;
                        ImgFile2 = null;
                        globals.tag = [];
                        fileTags = [];
                        globals.doubt = null;
                      });
                      _showDialogFailure();
                    }
                  } else {
                    setState(() {
                      error = 'Title and Tags are compulsory';
                    });
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
                          hintText: 'Ask a question',
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
                          globals.doubt = str;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Colors.lightBlue[900], width: 3)),
                        onPressed: () {
                          showSearch(
                              context: context,
                              delegate: TagsSearch(UploadPagetoggle));
                        },
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              size: 25,
                              color: Colors.lightBlue[900],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add tags",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: List<Widget>.generate(
                          globals.tag.length,
                          (int index) {
                            return Chip(
                              label: Text(globals.tag[index]),
                              backgroundColor: Colors.lightBlueAccent,
                              onDeleted: () {
                                globals.tag.removeAt(index);
                                UploadPagetoggle();
                              },
                            );
                          },
                        ),
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
