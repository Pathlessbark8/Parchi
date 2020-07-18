
import 'package:flutter/material.dart';
import 'package:feedpage/globals.dart' as globals;
import 'globals.dart' as globals;
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:feedpage/userService.dart';

class Post {
  String title;
  String description;

  Post(this.title, this.description);
}

class ChangePreference extends StatefulWidget {
  @override
  _ChangePreferenceState createState() => _ChangePreferenceState();
}

class _ChangePreferenceState extends State<ChangePreference> {
  final tagsList = [
    "JEE Main",
    "JEE Advance",
    "NEET",
    "Board exams",
    "Thermodynamics",
    "Solid states",
    "Permutation and combination",
    "Calculus"
  ];

  List<dynamic> selected = [];

  void toggle(
    Post post,
  ) {
    setState(() {
      int initial = selected.length;
      selected.add(post.title);
      selected = selected.toSet().toList();
      int atTheEnd = selected.length;
      if (initial != atTheEnd) {}
    });
  }

  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(tagsList.length, (int index) {
      if ((tagsList[index].toLowerCase())
          .contains(search.trim().toLowerCase())) {
        return Post(
          "${tagsList[index]}",
          "${tagsList[index]} ",
        );
      } else {
        return Post(
          null,
          null,
        );
      }
    });
  }

  @override
  void initState(){
    selected = globals.currentUser.interests==null?[]:globals.currentUser.interests;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              UserService(uid:globals.currentUser.uid).setInterests(selected);
              Navigator.pop(context);
//              Navigator.pop(context, selected);
            }),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Builder(
                builder: (context) => Flexible(
                  child: SearchBar<Post>(
//                    searchBarPadding: EdgeInsets.all(0),
                    headerPadding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    listPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical:0 ),
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 12,
                    onSearch: search,
                    placeHolder: Container(
                        child: ListView.builder(
                      itemCount: selected.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(selected[index]),
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.black,
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              String temp = selected[index];
                              selected.removeAt(index);
                              final snackBar = SnackBar(
                                duration: const Duration(milliseconds: 1000),
                                content: Text('$temp was removed'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    setState(() {
                                      selected.insert(index, temp);
                                    });
                                  },
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
//                              await Future.delayed(Duration(seconds: 1));
//                              Scaffold.of(context).hideCurrentSnackBar();
                            });
                          },
                          direction: DismissDirection.startToEnd,
                          child: Container(
                            height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Center(
                                child: Text(selected[index],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),

                              color: Colors.blueGrey[300],
                            ),
                          ),
                        );
                      },
                    )),
                    onItemFound: (Post post, int index) {
                      if (post.title != null) {
                        return ListTile(
                          //focusColor: Colors.amber,
                          title: Text(post.title),
                          subtitle: Text(post.description),
                          onTap: () {
                            toggle(post);
                            final snackBar = SnackBar(
                              duration: const Duration(milliseconds: 700),
                              content:
                                  Text('Added ${post.title} to your interests'),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

