import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'SearchBar.dart';
import 'globals.dart' as globals;


class DoubtsSliverAppBar extends StatefulWidget {
  @override
  _DoubtsSliverAppBarState createState() => _DoubtsSliverAppBarState();
}

class _DoubtsSliverAppBarState extends State<DoubtsSliverAppBar> {
  static bool isSearchDoubtsByTitle = true;
  List filters = [];

  void SearchToggle() {
    setState(() {
      isSearchDoubtsByTitle == true
          ? globals.SearchDoubtsByTitle = globals.SearchTag
          : globals.SearchDoubtsByTag = globals.SearchTag;
    });
  }

  void Clear() {
    setState(() {
      globals.SearchDoubtsByTag = "";
      globals.SearchDoubtsByTitle = " ";
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
      title: isSearchDoubtsByTitle
          ? FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      color: (globals.SearchDoubtsByTitle == "Search by title")
                          ? Colors.grey
                          : Colors.black,
                      width: 2)),
              onPressed: (globals.SearchDoubtsByTag == "Search by tags")
                  ? () {
                      showSearch(
                          context: context,
                          delegate: SearchByTitleSearchBar(
                              toggle: SearchToggle, page: 1));
                    }
                  : () {},
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 25,
                    color: (globals.SearchDoubtsByTitle == "Search by title")
                        ? Colors.grey
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      globals.SearchDoubtsByTitle,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color:
                              (globals.SearchDoubtsByTitle == "Search by title")
                                  ? Colors.grey
                                  : Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed: (globals.SearchDoubtsByTag == "Search by tags")
                        ? () {
                            setState(() {
                              // print("trial1");
                              globals.SearchDoubtsByTitle = "Search by title";
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavigationPage(
                                            pageToReload: 1,
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
                              (globals.SearchDoubtsByTitle == "Search by title")
                                  ? Colors.red[200]
                                  : Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    tooltip: 'Switch to search by tag',
                    onPressed: () {
                      setState(() {
                        isSearchDoubtsByTitle = !isSearchDoubtsByTitle;
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
                      color: (globals.SearchDoubtsByTag == "Search by tags")
                          ? Colors.grey
                          : Colors.black,
                      width: 1)),
              onPressed: (globals.SearchDoubtsByTitle == "Search by title")
                  ? () {
                      showSearch(
                          context: context,
                          delegate: SearchByTagSearchBar(
                              toggle: SearchToggle, page: 1));
                    }
                  : () {},
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 25,
                    color: (globals.SearchDoubtsByTag == "Search by tags")
                        ? Colors.grey
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      globals.SearchDoubtsByTag,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: (globals.SearchDoubtsByTag == "Search by tags")
                              ? Colors.grey
                              : Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed:
                        (globals.SearchDoubtsByTitle == "Search by title")
                            ? () {
                                setState(() {
//                        print("trial2");
                                  globals.SearchDoubtsByTag = "Search by tags";

//                        print(globals.SearchDoubtsByTag);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NavigationPage(
                                                pageToReload: 1,
                                              )),
                                      ModalRoute.withName("/Profile"));
//                  Navigator.of(context).popUntil((route) => route.isFirst);
                                });
                              }
                            : () {},
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color: (globals.SearchDoubtsByTag == "Search by tags")
                              ? Colors.red[200]
                              : Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    tooltip: 'Switch to search by title',
                    onPressed: () {
                      setState(() {
                        isSearchDoubtsByTitle = !isSearchDoubtsByTitle;
                      });
                    },
                  ),
                ],
              ),
            ),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.filter_list, color: Colors.black),
//          onPressed: () {
//            // showFilterDialog();
//          },
//        ),
//      ],
    );
  }
}
