import 'package:bloctry/pages/contact_page.dart';
import 'package:bloctry/pages/dialer_page.dart';
import 'package:bloctry/pages/recents.dart';
import 'package:bloctry/pages/settings_page.dart';
import 'package:bloctry/styles/colors.dart';
import 'package:bloctry/styles/theme.dart';
import 'package:bloctry/widget/icon_text_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: nothingTheme,
      darkTheme: nothingTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<RecentsState> _recentsKey = GlobalKey<RecentsState>();

  int currentPageIndex = 1;

  final PageController _pageController = PageController(initialPage: 1);

  void onTabTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black,
        onDestinationSelected: onTabTapped,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPageIndex,
        indicatorColor: AppColors.lightGrayer,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.contacts),
            icon: Icon(Icons.contacts_outlined),
            label: "Contact",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.recent_actors),
            icon: Icon(Icons.recent_actors_outlined),
            label: "Recents",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: currentPageIndex == 1
          ? SizedBox(
              height: 75,
              width: 75,
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await showModalBottomSheet<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: DialerPage(),
                      );
                    },
                  );
                  if (result == true) {
                    _recentsKey.currentState?.refreshCallLogs();
                  }
                },
                shape: CircleBorder(),
                child: Icon(Icons.dialpad),
              ),
            )
          : null,
      body: PageView.builder(
        controller: _pageController,
        itemCount: 3,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return ContactPage(recentsKey: _recentsKey);
            case 1:
              return Recents(key: _recentsKey);
            case 2:
              return SettingsPage();
            default:
              return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
