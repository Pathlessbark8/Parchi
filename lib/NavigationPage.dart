import 'package:feedpage/ReusableAppBar.dart';
import 'package:flutter/material.dart';
import 'NotesPage.dart';
import 'Profile.dart';
import 'globals.dart' as globals;
import 'DoubtsPage.dart';
import 'customDrawer.dart';
import 'VideosPage.dart';


class NavigationPage extends StatefulWidget {
  int pageToReload;
  NavigationPage({this.pageToReload});
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedItem = 0;

  var pages = [NotesPage(), DoubtsPage(), VideosPage(), Profile()];
  var pageController = PageController();

  @override
  void initState() {
    selectedItem = widget.pageToReload == null ? 0 : widget.pageToReload;
    pageController = PageController(
        initialPage: widget.pageToReload == null ? 0 : widget.pageToReload);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(),
      drawer: CustomDrawer(
          image: globals.currentUser == null ? "" : globals.currentUser.url),
      body: PageView(
        children: pages,
        onPageChanged: (index) {
          setState(() {
            selectedItem = index;
          });
        },
        controller: pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.lightBlueAccent[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Notes'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.live_help),
            title: Text('Doubts '),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            title: Text('Videos'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
        ],
        currentIndex: selectedItem,
        onTap: (index) {
          setState(() {
            print(index);
            selectedItem = index;
            pageController.animateToPage(selectedItem,
                duration: Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
      ),
    );
  }
}
