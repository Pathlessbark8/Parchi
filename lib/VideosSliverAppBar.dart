import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'SearchBar.dart';
import 'globals.dart' as globals;

class VideosSliverAppBar extends StatefulWidget {
  @override
  _VideosSliverAppBarState createState() => _VideosSliverAppBarState();
}

class _VideosSliverAppBarState extends State<VideosSliverAppBar> {
  static bool isSearchVideosByTitle = true;
  List filters = [];

  void SearchToggle() {
    setState(() {
      isSearchVideosByTitle == true
          ? globals.SearchVideosByTitle = globals.SearchTag
          : globals.SearchVideosByTag = globals.SearchTag;
    });
  }

  void Clear() {
    setState(() {
      globals.SearchVideosByTag = "";
      globals.SearchVideosByTitle = " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.lightBlue[50],
      snap: true,
      pinned: false,
      floating: true,

      elevation: 0,
      title: isSearchVideosByTitle
          ? FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      color: (globals.SearchVideosByTitle == "Search by title")
                          ? Colors.grey
                          : Colors.black,
                      width: 2)),
              onPressed: (globals.SearchVideosByTag == "Search by tags")
                  ? () {
                      showSearch(
                          context: context,
                          delegate: SearchByTitleSearchBar(
                              toggle: SearchToggle, page: 2));
                    }
                  : () {},
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 25,
                    color: (globals.SearchVideosByTitle == "Search by title")
                        ? Colors.grey
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      globals.SearchVideosByTitle,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color:
                              (globals.SearchVideosByTitle == "Search by title")
                                  ? Colors.grey
                                  : Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed: (globals.SearchVideosByTag == "Search by tags")
                        ? () {
                            setState(() {
                              // print("trial1");
                              globals.SearchVideosByTitle = "Search by title";
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavigationPage(
                                            pageToReload: 2,
                                          )),
                                  ModalRoute.withName("/Profile"));
//                  Navigator.of(context).popUntil((route) => route.isFirst);
                            });
                          }
                        : () {},
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color:
                              (globals.SearchVideosByTitle == "Search by title")
                                  ? Colors.red[200]
                                  : Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    tooltip: 'Switch to search by tag',
                    onPressed: () {
                      setState(() {
                        isSearchVideosByTitle = !isSearchVideosByTitle;
                      });
                    },
                  ),
                ],
              ),
            )
          : FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      color: (globals.SearchVideosByTag == "Search by tags")
                          ? Colors.grey
                          : Colors.black,
                      width: 1)),
              onPressed: (globals.SearchVideosByTitle == "Search by title")
                  ? () {
                      showSearch(
                          context: context,
                          delegate: SearchByTagSearchBar(
                              toggle: SearchToggle, page: 2));
                    }
                  : () {},
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 25,
                    color: (globals.SearchVideosByTag == "Search by tags")
                        ? Colors.grey
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      globals.SearchVideosByTag,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: (globals.SearchVideosByTag == "Search by tags")
                              ? Colors.grey
                              : Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed:
                        (globals.SearchVideosByTitle == "Search by title")
                            ? () {
                                setState(() {
//                        print("trial2");
                                  globals.SearchVideosByTag = "Search by tags";

//                        print(globals.SearchVideosByTag);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavigationPage(
                                                pageToReload: 2,
                                              )),
                                      ModalRoute.withName("/Profile"));
//                  Navigator.of(context).popUntil((route) => route.isFirst);
                                });
                              }
                            : () {},
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color: (globals.SearchVideosByTag == "Search by tags")
                              ? Colors.red[200]
                              : Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    tooltip: 'Switch to search by title',
                    onPressed: () {
                      setState(() {
                        isSearchVideosByTitle = !isSearchVideosByTitle;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
