/// This library contains the HomePage widget.
///
/// {@category PAGES}
library pages.home_page;

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studiconnect/pages/groups_page.dart';
import 'package:studiconnect/pages/profile_page.dart';
import 'package:studiconnect/pages/search_page.dart';

/// A StatefulWidget that serves as the home page of the application.
///
/// The page contains a bottom navigation bar with three items: Groups, Search, and Profile.
/// The user can switch between the three pages by tapping on the corresponding item in the navigation bar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// The state for the [HomePage] widget.
///
/// This class contains the logic for handling the user's interactions with the navigation bar
/// and switching between the three pages.
class _HomePageState extends State<HomePage> {
  /// The index of the currently selected page.
  /// 0 corresponds to the Groups page, 1 to the Search page, and 2 to the Profile page.
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    /// Sets the system UI overlay style to light.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    /// The widget for the currently selected page.
    late Widget page = const GroupsPage();

    /// If the selected page is the Search page, set the page widget to [SearchPage].
    if (_selectedPage == 1) {
      page = const SearchPage();
    }
    /// If the selected page is the Profile page, set the page widget to [ProfilePage].
    else if (_selectedPage == 2) {
      page = const ProfilePage();
    }

    return Scaffold(
      /// Extends the body behind the [AppBar].
      extendBody: true,
      /// The bottom navigation bar with three items: Groups, Search, and Profile.
      bottomNavigationBar: CurvedNavigationBar(
        /// The background color of the navigation bar is transparent.
        backgroundColor: Colors.transparent,
        /// The color of the navigation bar is the primary color of the current theme.
        color: Theme.of(context).colorScheme.primary,
        /// The items of the navigation bar.
        items: const <Widget>[
          /// The Groups item, represented by a group icon.
          Icon(Icons.group, size: 30, color: Colors.white),
          /// The Search item, represented by a search icon.
          Icon(Icons.search, size: 30, color: Colors.white),
          /// The Profile item, represented by a person icon.
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        /// The function to call when an item is tapped.
        /// Sets the selected page to the index of the tapped item.
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      /// The body of the scaffold is the currently selected page.
      body: page,
    );
  }
}