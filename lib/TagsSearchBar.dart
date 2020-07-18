import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class TagsSearch extends SearchDelegate<String> {
  final Function toggle;

  TagsSearch(this.toggle);

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
        ? globals.tagsList
            .where((TagElement) => !(globals.tag.contains(TagElement)))
        : globals.tagsList.where((TagElement) =>
            TagElement.toLowerCase().startsWith(query.toLowerCase()) &&
            (!(globals.tag.contains(TagElement))));
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
                  globals.tag.add(query);
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
    final suggestionList = query.isEmpty
        ? globals.tagsList
            .where((TagElement) => !(globals.tag.contains(TagElement)))
        : globals.tagsList.where((TagElement) =>
            TagElement.toLowerCase().startsWith(query.toLowerCase()) &&
            (!(globals.tag.contains(TagElement))));

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

                  globals.tag.add(TagElement);
                  toggle();
                  close(context, TagElement);
                },
              ))
          .toList(),
    );
  }
}
