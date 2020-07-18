import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'SearchBar.dart';
import 'globals.dart' as globals;

class NotesSliverAppBar extends StatefulWidget {
  @override
  _NotesSliverAppBarState createState() => _NotesSliverAppBarState();
}

class _NotesSliverAppBarState extends State<NotesSliverAppBar> {
  static bool isSearchNotesByTitle = true;
  List filters = [];

  void SearchToggle() {
    setState(() {
      isSearchNotesByTitle == true
          ? globals.SearchNotesByTitle = globals.SearchTag
          : globals.SearchNotesByTag = globals.SearchTag;
    });
  }

  void Clear() {
    setState(() {
      globals.SearchNotesByTag = "";
      globals.SearchNotesByTitle = " ";
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
      title: isSearchNotesByTitle
          ? FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                      color: (globals.SearchNotesByTitle == "Search by title")
                          ? Colors.grey
                          : Colors.black,
                      width: 2)),
              onPressed: (globals.SearchNotesByTag == "Search by tags")
                  ? () {
                      showSearch(
                          context: context,
                          delegate: SearchByTitleSearchBar(
                              toggle: SearchToggle, page: 0));
                    }
                  : () {},
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 25,
                    color: (globals.SearchNotesByTitle == "Search by title")
                        ? Colors.grey
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      globals.SearchNotesByTitle,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color:
                              (globals.SearchNotesByTitle == "Search by title")
                                  ? Colors.grey
                                  : Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed: (globals.SearchNotesByTag == "Search by tags")
                        ? () {
                            setState(() {
                              // print("trial1");
                              globals.SearchNotesByTitle = "Search by title";
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavigationPage(
                                            pageToReload: 0,
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
                              (globals.SearchNotesByTitle == "Search by title")
                                  ? Colors.red[200]
                                  : Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    tooltip: 'Switch to search by tag',
                    onPressed: () {
                      setState(() {
                        isSearchNotesByTitle = !isSearchNotesByTitle;
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
                      color: (globals.SearchNotesByTag == "Search by tags")
                          ? Colors.grey
                          : Colors.black,
                      width: 1)),
              onPressed: (globals.SearchNotesByTitle == "Search by title")
                  ? () {
                      showSearch(
                          context: context,
                          delegate: SearchByTagSearchBar(
                              toggle: SearchToggle, page: 0));
                    }
                  : () {},
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 25,
                    color: (globals.SearchNotesByTag == "Search by tags")
                        ? Colors.grey
                        : Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      globals.SearchNotesByTag,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: (globals.SearchNotesByTag == "Search by tags")
                              ? Colors.grey
                              : Colors.black),
                    ),
                  ),
                  FlatButton(
                    onPressed: (globals.SearchNotesByTitle == "Search by title")
                        ? () {
                            setState(() {
//                        print("trial2");
                              globals.SearchNotesByTag = "Search by tags";

//                        print(globals.SearchNotesByTag);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavigationPage(
                                            pageToReload: 0,
                                          )),
                                  ModalRoute.withName("/Profile"));
//                  Navigator.of(context).popUntil((route) => route.isFirst);
                            });
                          }
                        : () {},
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color: (globals.SearchNotesByTag == "Search by tags")
                              ? Colors.red[200]
                              : Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.swap_vert),
                    tooltip: 'Switch to search by title',
                    onPressed: () {
                      setState(() {
                        isSearchNotesByTitle = !isSearchNotesByTitle;
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
