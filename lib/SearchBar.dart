import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:connectivity/connectivity.dart';

class SearchByTagSearchBar extends SearchDelegate<String> {
  final Function toggle;
  final page;
  SearchByTagSearchBar({this.toggle, this.page});

  @override
  //implements actions that come after the title ig...like the clear button
  // button to clear the search bar
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = " ";
          })
    ];
  }

  @override
  //implements stuff that come before the title ig...like the back button
  //button to go back from the search bar
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    print("Here");
    //handles what happens when something in the suggestions list is tapped on
    final suggestionList = query.isEmpty
        ? (globals.RecentlySearcedTags.length == 0
            ? globals.tagsList
            : globals.RecentlySearcedTags)
        : globals.tagsList.where((TagElement) =>
            TagElement.toLowerCase().startsWith(query.toLowerCase()));

    if (suggestionList == globals.RecentlySearcedTags) {
      return ListView(
        children: suggestionList
            .map<ListTile>((TagElement) => ListTile(
                  leading: Icon(Icons.history),
                  title: RichText(
                      text: TextSpan(
                          text: TagElement.substring(0, query.length),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                        TextSpan(
                            text: TagElement.substring(query.length),
                            style: TextStyle(color: Colors.grey))
                      ])),
                  onTap: () {
                    query = TagElement;
                    globals.RecentlySearcedTags.insert(0, TagElement);
                    if (globals.RecentlySearcedTags.length > 10) {
                      globals.RecentlySearcedTags.removeLast();
                    }
                    globals.SearchTag = TagElement;

                    toggle();
                    close(context, TagElement);
                    Navigator.of(context)
                        .pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            NavigationPage(pageToReload: this.page),
                      ),
                    )
                        .then((_) {
                      setState() {}
                    });
                  },
                ))
            .toList(),
      );
    }

    return ListView(
      children: suggestionList
          .map<ListTile>((TagElement) => ListTile(
                title: RichText(
                    text: TextSpan(
                        text: TagElement.substring(0, query.length),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                      TextSpan(
                          text: TagElement.substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ])),
                leading: Icon(Icons.book),
                onTap: () {
                  query = TagElement;
                  globals.RecentlySearcedTags.insert(0, TagElement);
                  if (globals.RecentlySearcedTags.length > 10) {
                    globals.RecentlySearcedTags.removeLast();
                  }
                  globals.SearchTag = query;
                  toggle();
                  close(context, TagElement);
                },
              ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //part that shows the suggestions list and handles what happens when something in the suggestions list is tapped on
    print("yoohoo");
    print(globals.RecentlySearcedTags);
    final suggestionList = query.isEmpty
        ? (globals.RecentlySearcedTags.length == 0
            ? globals.tagsList
            : globals.RecentlySearcedTags)
        : globals.tagsList.where((TagElement) =>
            TagElement.toLowerCase().startsWith(query.toLowerCase()));

    if (suggestionList == globals.RecentlySearcedTags) {
      return ListView(
        children: suggestionList
            .map<ListTile>((TagElement) => ListTile(
                  leading: Icon(Icons.history),
                  title: RichText(
                      text: TextSpan(
                          text: TagElement.substring(0, query.length),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          children: [
                        TextSpan(
                            text: TagElement.substring(query.length),
                            style: TextStyle(color: Colors.grey))
                      ])),
                  onTap: () {
                    query = TagElement;
                    if (globals.RecentlySearcedTags.contains(query)) {
                      print(globals.RecentlySearcedTags);
                      globals.RecentlySearcedTags.remove(query);
                      print(globals.RecentlySearcedTags);
                    }
                    print("uhhuh");
                    print(query);
                    print(globals.RecentlySearcedTags);
                    globals.RecentlySearcedTags.insert(0, query);
                    print(globals.RecentlySearcedTags);

                    if (globals.RecentlySearcedTags.length > 10) {
                      globals.RecentlySearcedTags.removeLast();
                    }
                    globals.SearchTag = TagElement;
                    toggle();
                    print("no");
                    close(context, TagElement);
                    Navigator.of(context)
                        .pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            NavigationPage(pageToReload: this.page),
                      ),
                    )
                        .then((_) {
                      setState() {}
                    });
//                    Navigator.pushNamedAndRemoveUntil(
//                        context, "/NavigationPage", (r) => false);
                  },
                ))
            .toList(),
      );
    }

    return ListView(
      children: suggestionList
          .map<ListTile>((TagElement) => ListTile(
                title: RichText(
                    text: TextSpan(
                        text: TagElement.substring(0, query.length),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                      TextSpan(
                          text: TagElement.substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ])),
                onTap: () {
                  query = TagElement;
                  globals.RecentlySearcedTags.insert(0, TagElement);
                  if (globals.RecentlySearcedTags.length > 10) {
                    globals.RecentlySearcedTags.removeLast();
                  }
                  globals.SearchTag = TagElement;

                  toggle();
                  close(context, TagElement);
                  Navigator.of(context)
                      .pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          NavigationPage(pageToReload: this.page),
                    ),
                  )
                      .then((_) {
                    setState() {}
                  });
                },
              ))
          .toList(),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SearchByTitleSearchBar extends SearchDelegate<String> {
  final Function toggle;
  final page;
  bool _loadingNotes = true;

  SearchByTitleSearchBar({this.toggle, this.page});

//  Firestore _firestore = Firestore.instance;
//  getSuggestionData(List queryWords) async {
//    globals.notesTitles =
//        await _firestore.collection('TitleSearch').getDocuments();
//  }

  @override
  //implements actions that come after the title ig...like the clear button
  // button to clear the search bar
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = " ";
          })
    ];
  }

  @override
  //implements stuff that come before the title ig...like the back button
  //button to go back from the search bar
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    print(query);
    return ListTile(
      title: Text(query),
      leading: Icon(Icons.star),
      onTap: () {
        globals.SearchTag = query;
        toggle();
        close(context, query);
        Navigator.of(context)
            .pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationPage(pageToReload: this.page),
          ),
        )
            .then((_) {
          setState() {}
        });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //print(query);
    return ListTile(
      title: Text(query),
      onTap: () {
        globals.SearchTag = query;
        toggle();
        close(context, query);
        Navigator.of(context)
            .pushReplacement(
          MaterialPageRoute(
            builder: (context) => NavigationPage(pageToReload: this.page),
          ),
        )
            .then((_) {
          setState() {}
        });
      },
    );
  }
}
