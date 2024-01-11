/// This library contains the HomePage widget.
///
/// {@category PAGES}
library pages.home_page;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/pages/groups_page.dart';
import 'package:studiconnect/pages/no_connectivity_page.dart';
import 'package:studiconnect/pages/profile_page.dart';
import 'package:studiconnect/pages/search_page.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/models/redux/store.dart';

/// A StatefulWidget that serves as the home page of the application.
///
/// The page contains a bottom navigation bar with three items: Groups, Search, and Profile.
/// The user can switch between the three pages by tapping on the corresponding item in the navigation bar.
class HomePage extends StatefulWidget {

  /// Creates a [HomePage] widget.
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// The state for the [HomePage] widget.
///
/// This class contains the logic for handling the user's interactions with the navigation bar
/// and switching between the three pages.
class _HomePageState extends State<HomePage> {
  late final StreamSubscription<ConnectivityResult> subscription;

  /// The index of the currently selected page.
  /// 0 corresponds to the Groups page, 1 to the Search page, and 2 to the Profile page.
  int _selectedPage = 0;

  void _onConnectivityChanged(ConnectivityResult result) {
    store.dispatch(
      redux.Action(
        redux.ActionTypes.setConnectionState,
        payload: result != ConnectivityResult.none,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Connectivity().checkConnectivity().then(_onConnectivityChanged);
    subscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if (!state.connected) {
          return const NoConnectivityPage();
        }
        late Widget page;

        if (_selectedPage == 0) {
          page = const GroupsPage();
        } else if (_selectedPage == 1) {
          page = const SearchPage();
        } else if (_selectedPage == 2) {
          page = const ProfilePage();
        }

        return Scaffold(
          extendBody: true,
          bottomNavigationBar: (!state.loading)
              ? CurvedNavigationBar(
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.primary,
                  index: _selectedPage,
                  items: const <Widget>[
                    Icon(Icons.group, size: 30, color: Colors.white),
                    Icon(Icons.search, size: 30, color: Colors.white),
                    Icon(Icons.person, size: 30, color: Colors.white),
                  ],
                  onTap: (index) {
                    setState(() {
                      _selectedPage = index;
                    });
                  },
                )
              : null,
          body: page,
        );
      },
    );
  }
}