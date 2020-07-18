
import 'package:flutter/material.dart';
import 'package:feedpage/globals.dart' as globals;

Future<String> ShowBookmarkAlert(BuildContext context) async {
  String txt = '';
  String error = '';
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return SingleChildScrollView(
                child: Container(
                  color: Colors.amber[100],
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                          child: Text(
                        'Choose a folder',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: globals.bookmarkFiles.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                txt = globals.bookmarkFiles[index];
                                Navigator.pop(
                                    context, globals.bookmarkFiles[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                              Icons.folder,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(width: 10.0,),
                                          Text(
                                            globals.bookmarkFiles[index],
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            );
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                      child: Text(error,style: TextStyle(
                        color: Colors.red,
                      ),),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter new folder name',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        onChanged: (String str) {
                          txt = str;
                        },
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        "Add to a new folder",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        if (txt != '') {
                          globals.bookmarkFiles.add(txt);
                          Navigator.pop(context, txt);
                        }
                        else{
                          setState(() {
                            error='please write a name';
                          });
                        }
                      },
                    ),
//                        SizedBox(height: 5),
                    FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        txt = null;
                        Navigator.pop(context, null);
                      },
                    ),
                  ]),
                ),
              );
            }
          ),
        );
      });
  return txt;
}
