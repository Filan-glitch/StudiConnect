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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Connectivity().onConnectivityChanged.last.then((ConnectivityResult result) {
      store.dispatch(
        redux.Action(
          redux.ActionTypes.setConnectionState,
          payload: result != ConnectivityResult.none,
        ),
      );
    });
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      store.dispatch(
        redux.Action(
          redux.ActionTypes.setConnectionState,
          payload: result != ConnectivityResult.none,
        ),
      );
      setState(() {});
    });
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

        if(_selectedPage == 0) {
          page = const GroupsPage();
        } else if (_selectedPage == 1) {
          page = const SearchPage();
        } else if (_selectedPage == 2) {
          page = const ProfilePage();
        }

        return Scaffold(
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: Theme.of(context).colorScheme.primary,
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
          ),
          body: page,
        );
      },
    );
  }
}
