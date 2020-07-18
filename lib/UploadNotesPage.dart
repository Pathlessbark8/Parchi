
import 'package:connectivity/connectivity.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/NavigationPage.dart';
import 'notesUploadClass.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'globals.dart' as globals;
import 'crud.dart';
import 'TagsSearchBar.dart';

class UploadNotesPage extends StatefulWidget {
  @override
  _UploadNotesPageState createState() => _UploadNotesPageState();
}

class _UploadNotesPageState extends State<UploadNotesPage> {
  bool isInternet = false;
  File file;
  String pdfStatus = 'Upload a pdf file';
  List fileTags = [];
  String fileString = '';
  bool isPopUpload = false;
  bool isUploading = false;
  String error = "";
  notesCrudMethods crudObj = new notesCrudMethods();
  //WriteTitles titleObj = new WriteTitles();

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

  void UploadPagetoggle() {
    setState(() {
      fileTags = globals.tag;
    });
  }

  Future<bool> exitUploadPageDialog() async {
    if (file != null ||
        globals.title != null ||
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
                    globals.title = null;
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

  void _showDialogSuccess() {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("File was Uploaded Successfully"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => NavigationPage()));
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
              "Feedback could not be submitted. Kindly try doing it again in sometime."),
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

  @override
  Widget build(BuildContext context) {
    print(isUploading);
    return isUploading == true
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
                  await exitUploadPageDialog();
                  if (isPopUpload) Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.lightBlue[700],
              title: Text('Upload Notes'),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await CheckInternetConnectivity();
                if (isInternet) {
                  if (file != null &&
                      globals.title != null &&
                      globals.description != null &&
                      globals.tag.isNotEmpty) {
                    setState(() {
                      isUploading = true;
                    });

                    try {
                      String NotesUrl =
                          await getDownloadURL(file, 'pdf', '${globals.title}');
                      notesUpload ob = notesUpload(
                          globals.title,
                          globals.description,
                          this.fileTags,
                          NotesUrl,
                          this.file);
                      await crudObj.addData(ob);
                      //await titleObj.addData(ob.title);
                      setState(() {
                        isUploading = false;
                        globals.tag = [];
                        fileTags = [];
                        globals.title = null;
                        globals.description = null;
                      });
                      _showDialogSuccess();
                    } catch (e) {
                      _showDialogFailure();
                      setState(() {
                        isUploading = false;
                        globals.tag = [];
                        fileTags = [];
                        globals.title = null;
                        globals.description = null;
                      });
                    }
                  } else {
                    setState(() {
                      error = 'All fields are compulsory';
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
              onWillPop: exitUploadPageDialog,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Container(
                        height: 250,
                        width: 250,
//                        padding: EdgeInsets.fromLTRB(80, 30, 80, 20),
                        child: Center(
                          child: ButtonTheme(
                            height: 150,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                      color: Colors.black, width: 5)),
                              onPressed: () async {
                                file = await FilePicker.getFile(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf']);
                                print('file length:${file.lengthSync()}');
                                setState(
                                  () {
                                    if (file != null) {
                                      if (file.lengthSync() < 800000000) {
                                        pdfStatus = "File uploaded";
                                        fileString = file.toString();
                                      } else {
                                        file = null;
                                        pdfStatus = 'Upload a pdf file';
                                        fileString = "file too big!";
                                      }
                                    }
                                  },
                                );
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                      (file == null)
                                          ? Icons.add
                                          : Icons.insert_drive_file,
                                      size: 80,
                                      color: (file == null)
                                          ? Colors.green
                                          : Colors.grey),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      pdfStatus,
                                    ),
                                  ),
                                ],
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Center(
                        child: Text(
                          fileString,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  (fileString == "file too big!") ? 15 : 10,
                              color: (fileString == "file too big!")
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                      child: TextField(
                        autofocus: false,
                        autocorrect: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.title, color: Colors.lightBlue[900]),
                          hintText: 'Title',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.lightBlue, width: 3),
                          ),
                        ),
                        onChanged: (String str) {
                          globals.title = str;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextField(
                        autofocus: false,
                        autocorrect: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.lightBlue[900],
                          ),
                          hintText: 'Description',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.lightBlue, width: 3),
                          ),
                        ),
                        onChanged: (String str) {
                          globals.description = str;
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
                              color: Colors.lightBlue[700],
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
                            )
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
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
