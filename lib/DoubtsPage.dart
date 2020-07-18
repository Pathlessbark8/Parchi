import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'UploadDoubtsPage.dart';
import 'SlideFromBottomTransition.dart';
import 'cardDoubts.dart';
import 'DoubtsSliverAppBar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class DoubtsPage extends StatefulWidget {
  @override
  _DoubtsPageState createState() => _DoubtsPageState();
}

class _DoubtsPageState extends State<DoubtsPage> {
  ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> doubts = [];
  bool _loadingDoubts = true;
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
            builder: (context) => NavigationPage(pageToReload: 1)),
        ModalRoute.withName("/Profile"));
  }

  getData() async {
    CheckInternetConnectivity();
    if (this.mounted)
      setState(() {
        _loadingDoubts = true;
      });

    QuerySnapshot querySnapshot = await _firestore
        .collection('doubts')
        .orderBy("UID")
        .limit(perPage)
        .getDocuments();
    if (querySnapshot.documents.length != 0)
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];

    if (this.mounted) {
      if (querySnapshot.documents.length < perPage) {
        setState(() {
          moreDataAvailable = false;

        });
      }
    }
    if (this.mounted)
      setState(() {
        _loadingDoubts = false;
        doubts = querySnapshot.documents;
      });
  }

  getSearchByTagData() async {
    CheckInternetConnectivity();
    if (this.mounted)
      setState(() {
        _loadingDoubts = true;
      });

    QuerySnapshot querySnapshot = await _firestore
        .collection('doubts')
        .where("tags", arrayContains: globals.SearchDoubtsByTag)
        .getDocuments();
    if (this.mounted)
      setState(() {
        _loadingDoubts = false;
        moreDataAvailable = false;
        doubts = querySnapshot.documents;
      });
  }

  getSearchByTitleData() async {
    CheckInternetConnectivity();
    if (this.mounted)
      setState(() {
        _loadingDoubts = true;
      });

    QuerySnapshot querySnapshot = await _firestore
        .collection('doubts')
        .where("title", isEqualTo: globals.SearchDoubtsByTitle)
        .getDocuments();
    if (this.mounted)
      setState(() {
        _loadingDoubts = false;
        moreDataAvailable = false;
        doubts = querySnapshot.documents;
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
        _loadingDoubts = true;
        gettingMoreData = true;
      });
    QuerySnapshot querySnapshot = await _firestore
        .collection('doubts')
        .orderBy("UID")
        .startAfterDocument(lastDocument)
        .limit(perPage)
        .getDocuments();

    if (querySnapshot.documents.length != 0)
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];
    if (this.mounted) {
      setState(() {
        doubts = doubts + querySnapshot.documents;

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
        _loadingDoubts = false;
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

    if (globals.SearchDoubtsByTag == "Search by tags" &&
        globals.SearchDoubtsByTitle == "Search by title") {
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
    } else if (globals.SearchDoubtsByTag != "Search by tags") {
      getSearchByTagData();
    } else if (globals.SearchDoubtsByTitle != "Search by title") {
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
                    DoubtsSliverAppBar(),
                    (doubts.length == 0 && moreDataAvailable)
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
                                return CardDoubts(
                                  Doubt: doubts[index].data["doubt"],
                                  UploadDate: doubts[index].data["UploadDate"],
                                  Username: doubts[index].data["Username"],
                                  URL1: doubts[index].data["img URL1"],
                                  URL2: doubts[index].data["img URL2"],
                                  Tags: doubts[index].data["tags"],
                                  UID: doubts[index].data["UID"],
                                  userUid: doubts[index].data["userUid"],
                                );
                              },
                              childCount: doubts.length,
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
//          onRefresh: RefreshDoubtsList, child: Container(child: PostList())),
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
              widget: UploadDoubtsPage(),
            ),
          );
        },
      ),
    );
  }
}

//
//return CardDoubts(
//Title: doubts[index].data["title"],
//Description:
//doubts[index].data["description"],
//UploadDate:
//doubts[index].data["UploadDate"],
//Username: doubts[index].data["Username"],
//URL: doubts[index].data["file URL"],
//Tags: doubts[index].data["tags"],
//Uid: doubts[index].data["UID"],
//context: context,
//userUid: notes[index].data["userUid"],
//);

//
//return CardDoubts(
//Doubt: doubts[index].data["doubt"],
//UploadDate: doubts[index].data["UploadDate"],
//Username: doubts[index].data["Username"],
//URL1: doubts[index].data["img URL1"],
//URL2: doubts[index].data["img URL2"],
//Tags: doubts[index].data["tags"],
//UID: doubts[index].data["UID"],
//userUid: doubts[index].data["userUid"],
//);
