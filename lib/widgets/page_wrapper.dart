/// This library contains the [PageWrapper] widget and the [PageType] enum.
///
/// {@category WIDGETS}
library widgets.page_wrapper;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/pages/loading_page.dart';
import 'package:studiconnect/pages/no_connectivity_page.dart';
import 'package:studiconnect/widgets/action_menu.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;
import 'package:studiconnect/models/redux/store.dart';
import 'package:studiconnect/models/menu_action.dart';

/// Enum representing the type of page.
enum PageType {
  /// Represents a page with a basic empty design.
  empty,

  /// Represents a page with a simple design.
  simple,

  /// Represents a page with a complex design.
  complex,
}

/// A widget that wraps the main content of a page.
///
/// This widget is a stateless widget that takes a title, body, bottom navigation bar,
/// menu actions, header controls, padding, and a flag for simple design and loading screen override as input.
/// It displays a Scaffold with an AppBar, body, and bottom navigation bar.
/// The AppBar contains the title and an optional action menu.
/// The body contains the main content of the page, wrapped in a Container with padding.
class PageWrapper extends StatefulWidget {
  /// The const constructor of the [PageWrapper] widget.
  const PageWrapper({
    required this.title,
    required this.body,
    this.bottomNavigationBar,
    this.menuActions = const [],
    this.headerControls = const [],
    this.type = PageType.simple,
    this.padding = const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      top: 20.0,
    ),
    this.overrideLoadingScreen = false,
    this.showLoading = true,
    super.key,
  });

  /// The body of the page.
  final Widget body;

  /// The bottom navigation bar of the page.
  final Widget? bottomNavigationBar;

  /// The controls in the header of the page to have more advanced functionality.
  final List<Widget> headerControls;

  /// The title of the page.
  final String title;

  /// The actions in the action menu.
  final List<MenuAction> menuActions;

  /// The type of the page.
  final PageType type;

  /// The padding of the main content of the page.
  final EdgeInsets padding;

  /// Whether the loading screen should be overridden.
  final bool overrideLoadingScreen;

  /// Whether the loading screen should be shown.
  final bool showLoading;

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

/// The state for the [PageWrapper] widget.
///
/// This class contains the logic for handling the user's interactions with the page.
/// It includes methods for handling connectivity changes and showing the action menu.
class _PageWrapperState extends State<PageWrapper> {
  late final StreamSubscription<ConnectivityResult> subscription;

  /// Handles connectivity changes.
  ///
  /// This method is called when the connectivity changes.
  /// It dispatches an action to the Redux store to update the connection state.
  ///
  /// The [result] parameter is required and represents the new connectivity result.
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
    Connectivity().checkConnectivity().then(_onConnectivityChanged);
    subscription =
        Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
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

        if (widget.type == PageType.empty) {
          return OKToast(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Scaffold(
                  body: widget.body,
                ),
              ),
          );
        }

        Widget mainContent;

        if (widget.type == PageType.simple) {
          mainContent = Scaffold(
              appBar: AppBar(
                actions: [
                  if (widget.menuActions.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showActionMenu(context),
                    ),
                ],
                title: Text(widget.title),
                titleTextStyle: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
              ),
              body: OKToast(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: widget.body,
                ),
              ));
        } else {
          mainContent = Scaffold(
            bottomNavigationBar: widget.bottomNavigationBar,
            body: Container(
              padding: EdgeInsets.only(
                top: (MediaQuery.of(context).viewPadding.top - 5.0 >= 0)
                    ? MediaQuery.of(context).viewPadding.top - 5.0
                    : 0,
              ),
              color: Theme.of(context).colorScheme.primary,
              child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    widget.title,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              if (widget.menuActions.isNotEmpty)
                                Row(
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => _showActionMenu(context),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (widget.headerControls.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            child: Column(
                              children: [
                                ...widget.headerControls,
                              ],
                            ),
                          ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewPadding.bottom,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: widget.padding,
                              child: widget.body,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
        }

        return Stack(
          children: [
            mainContent,
            if (state.loading && !widget.overrideLoadingScreen && widget.showLoading)
              const LoadingPage(),
          ],
        );
      },
    );
  }

  /// Shows the action menu.
  ///
  /// This method is called when the user taps on the action menu button.
  /// It displays a modal bottom sheet with the action menu.
  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ActionMenu(
        children: widget.menuActions,
      ),
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }
}