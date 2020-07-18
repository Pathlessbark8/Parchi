import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'UploadNotesPage.dart';
import 'SlideFromBottomTransition.dart';
import 'cardNotes.dart';
import 'NotesSliverAppBar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> notes = [];
  bool _loadingNotes = true;
  bool gettingMoreData = false;
  bool moreDataAvailable = true;
  int perPage = 10;
  DocumentSnapshot lastDocument;
  Firestore _firestore = Firestore.instance;
  bool isInternet = true;

  CheckInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (this.mounted) {
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
  }

  Future<void> pushPage() {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => NavigationPage(pageToReload: 0)),
        ModalRoute.withName("/Profile"));
  }

  getData() async {
    print('called getData');
    CheckInternetConnectivity();
    if (this.mounted)
      setState(() {
        _loadingNotes = true;
      });

    QuerySnapshot querySnapshot = await _firestore
        .collection('notes')
        .orderBy("UID")
        .limit(perPage)
        .getDocuments();
    if (querySnapshot.documents.length != 0)
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];
    print('querysnapshot.documents.length:${querySnapshot.documents.length}');
    if (this.mounted) {
      if (querySnapshot.documents.length < perPage) {
        setState(() {
          moreDataAvailable = false;
          print('moreDataAvailable:$moreDataAvailable');
        });
      }
    }
    if (this.mounted)
      setState(() {
        _loadingNotes = false;
        notes = querySnapshot.documents;
      });
  }

  getSearchByTagData() async {
    CheckInternetConnectivity();
    if (this.mounted)
      setState(() {
        _loadingNotes = true;
      });

    QuerySnapshot querySnapshot = await _firestore
        .collection('notes')
        .where("tags", arrayContains: globals.SearchNotesByTag)
        .getDocuments();
    if (this.mounted)
      setState(() {
        _loadingNotes = false;
        moreDataAvailable = false;
        notes = querySnapshot.documents;
      });
  }

  getSearchByTitleData() async {
    CheckInternetConnectivity();
    if (this.mounted)
      setState(() {
        _loadingNotes = true;
      });

    QuerySnapshot querySnapshot = await _firestore
        .collection('notes')
        .where("title", isEqualTo: globals.SearchNotesByTitle)
        .getDocuments();
    if (this.mounted)
      setState(() {
        _loadingNotes = false;
        moreDataAvailable = false;
        notes = querySnapshot.documents;
      });
  }

  getMoreData() async {
    CheckInternetConnectivity();
    if (gettingMoreData) {
      return;
    }
    if (moreDataAvailable == false) {
      return;
    }
    if (this.mounted)
      setState(() {
        _loadingNotes = true;
        gettingMoreData = true;
      });
    QuerySnapshot querySnapshot = await _firestore
        .collection('notes')
        .orderBy("UID")
        .startAfterDocument(lastDocument)
        .limit(perPage)
        .getDocuments();
//    for (int i = 0; i < querySnapshot.documents.length; i++) {
//      print(querySnapshot.documents[i].data["title"]);
//    }
    if (querySnapshot.documents.length != 0)
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];
    if (this.mounted) {
      setState(() {
        notes = notes + querySnapshot.documents;

//      print('notes:');
//      for (int i = 0; i < notes.length; i++) {
//        print(notes[i].data["title"]);
//      }
        gettingMoreData = false;
      });
    }
    if (this.mounted) {
      if (querySnapshot.documents.length < perPage) {
        setState(() {
          moreDataAvailable = false;
        });
      }
    }
    if (this.mounted)
      setState(() {
        _loadingNotes = false;
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    CheckInternetConnectivity();

    if (globals.SearchNotesByTag == "Search by tags" &&
        globals.SearchNotesByTitle == "Search by title") {
      getData();

      _scrollController.addListener(() {
        double MaxScroll = _scrollController.position.maxScrollExtent;
        double CurrentScroll = _scrollController.position.pixels;
        double Delta = MediaQuery.of(context).size.height * 0.25;
        if ((MaxScroll - CurrentScroll) < Delta &&
            moreDataAvailable &&
            !gettingMoreData) {
          getMoreData();
        }
      });
    } else if (globals.SearchNotesByTag != "Search by tags") {
      getSearchByTagData();
    } else if (globals.SearchNotesByTitle != "Search by title") {
      getSearchByTitleData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: pushPage,
        child: CustomScrollView(
            controller: _scrollController,
            slivers: isInternet
                ? <Widget>[
                    NotesSliverAppBar(),
                    (notes.length == 0 && moreDataAvailable)
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                                  child: Center(
                                    child: Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 7,
                                      ),
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                );
                              },
                              childCount: 1,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return CardNotes(
                                  Title: notes[index].data["title"],
                                  Description: notes[index].data["description"],
                                  UploadDate: notes[index].data["UploadDate"],
                                  Username: notes[index].data["Username"],
                                  URL: notes[index].data["file URL"],
                                  Tags: notes[index].data["tags"],
                                  Uid: notes[index].data["UID"],
                                  context: context,
                                  userUid: notes[index].data["userUid"],
                                );
                              },
                              childCount: notes.length,
                            ),
                          ),
                    (!moreDataAvailable)
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text('No more Data'),
                                  ),
                                );
                              },
                              childCount: 1,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      'Loading...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 20),
                                    ),
                                  ),
                                );
                              },
                              childCount: 1,
                            ),
                          )
                  ]
                : <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                            height: 100,
                            child: Center(
                              child: Image(
                                image:
                                    AssetImage('assets/No_internet_image.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            child: Center(
                              child: Text(
                                'No Internet',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  CheckInternetConnectivity();
                                },
                                child: Wrap(
                                  children: <Widget>[
                                    Icon(
                                      Icons.refresh,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Reload',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                  ]),
      ),
      backgroundColor: isInternet
          ? Colors.blue[50]
          : Colors.grey[100], //      body: RefreshIndicator(
//          onRefresh: RefreshNotesList, child: Container(child: PostList())),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Add'),
        onPressed: () {
          globals.tag = [];
          globals.title = null;
          globals.description = null;
          Navigator.push(
            context,
            SlideFromBottomPageRoute(
              widget: UploadNotesPage(),
            ),
          );
        },
      ),
    );
  }
}

//
//return CardNotes(
//Title: notes[index].data["title"],
//Description:
//notes[index].data["description"],
//UploadDate:
//notes[index].data["UploadDate"],
//Username: notes[index].data["Username"],
//URL: notes[index].data["file URL"],
//Tags: notes[index].data["tags"],
//Uid: notes[index].data["UID"],
//context: context,
//userUid: notes[index].data["userUid"],
//);
