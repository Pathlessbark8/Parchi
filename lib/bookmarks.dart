import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/Loading.dart';
import 'package:feedpage/bookmarksService.dart';
import 'package:feedpage/cardNotes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/globals.dart' as globals;

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  ShowDeleteFileDialog(String name) async{
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: FlatButton(
                onPressed: () async{
                  await ShowDeleteFileConfirmationDialog(name);
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete this file?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red),
                )),
          );
        });
  }

  ShowDeleteFileConfirmationDialog(String name) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning!'),
            content: Text('All the bookmarks in this file will be deleted'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue),
                  )),
              FlatButton(
                  onPressed: () async{
                    globals.bookmarkFiles.remove(name);
                    List temp = globals.bookmarkStructure[name];
                    for(var itr in temp){
                      globals.bookmarkUIDs.remove(itr);
                    }
                    globals.bookmarkStructure.remove(name);
                    await bookmarksService(
                        Uid: globals.currentUser.uid)
                        .setData();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.red),
                  )),
            ],
          );
        });
  }

  bool islistView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text("My Bookmarks"),
          actions: <Widget>[
            IconButton(
              icon: islistView
                  ? Icon(
                Icons.grid_on,
                size: 30,
              )
                  : Icon(
                Icons.list,
                size: 35,
              ),
              onPressed: () {
                setState(() {
                  islistView = !islistView;
                });
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: islistView
              ? GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            children:
            List.generate(globals.bookmarkFiles.length, (index) {
              return GestureDetector(
                onLongPress: () {
                  if(globals.bookmarkFiles[index]!='Default'){
                    ShowDeleteFileDialog(globals.bookmarkFiles[index]);
                    setState(() {
                      globals.bookmarkFiles=globals.bookmarkFiles;
                    });
                  }
                },
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new InsideFile(
                            filename: globals.bookmarkFiles[index],
                          )));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(),
                    child: Center(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.folder,
                            size: 100,
                            color: Colors.amber,
                          ),
                          Text(
                            globals.bookmarkFiles[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
              : ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemCount: globals.bookmarkFiles.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    onLongPress: () {
                      if(globals.bookmarkFiles[index]!='Default'){ShowDeleteFileDialog(globals.bookmarkFiles[index]);
                      setState(() {
                        globals.bookmarkFiles=globals.bookmarkFiles;
                      });}
                    },
                    leading: Icon(
                      Icons.folder,
                      size: 40,
                      color: Colors.amber,
                    ),
                    title: Text(globals.bookmarkFiles[index]),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new InsideFile(
                                filename:
                                globals.bookmarkFiles[index],
                              )));
                    },
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class InsideFile extends StatefulWidget {
  String filename;
  InsideFile({this.filename});

  @override
  _InsideFileState createState() => _InsideFileState();
}

class _InsideFileState extends State<InsideFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename),
        backgroundColor: Colors.blue[400],
      ),
      body: FileList(filename: widget.filename),
    );
  }
}

class FileList extends StatefulWidget {
  String filename;
  FileList({this.filename});

  @override
  _FileListState createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  bool showEmpty = false;
  QuerySnapshot notes;

  @override
  void initState() {
    if(globals.bookmarkStructure[widget.filename]==null){
      setState(() {
        showEmpty = true;
      });
    }
    else if (globals.bookmarkStructure[widget.filename].isEmpty) {
      setState(() {
        showEmpty = true;
      });
    }
    else {
      Firestore.instance
          .collection('notes')
          .where('UID', whereIn: globals.bookmarkStructure[widget.filename])
          .getDocuments()
          .then((value) {
        setState(() {
          notes = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showEmpty) {
      return Center(
        child: Text("Sorry no files to show"),
      );
    } else {
      if (notes == null) {
        return Loading();
      } else {
        return ListView.builder(
            itemCount: notes.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return CardNotes(
                Title: notes.documents[index].data["title"],
                Description: notes.documents[index].data["description"],
                UploadDate: notes.documents[index].data["UploadDate"],
                Username: notes.documents[index].data["Username"],
                URL: notes.documents[index].data["file URL"],
                Tags: notes.documents[index].data["tags"],
                Uid: notes.documents[index].data["UID"],
              );
            });
      }
    }
  }
}
