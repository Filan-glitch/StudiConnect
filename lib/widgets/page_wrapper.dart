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

enum PageType {
  empty,
  simple,
  complex,
}

class PageWrapper extends StatefulWidget {
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

  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Widget> headerControls;
  final String title;
  final List<Widget> menuActions;
  final PageType type;
  final EdgeInsets padding;
  final bool overrideLoadingScreen;
  final bool showLoading;

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  late StreamSubscription<ConnectivityResult> subscription;

  void _onConnectivityChanged(ConnectivityResult result) {
    store.dispatch(
      redux.Action(
        redux.ActionTypes.setConnectionState,
        payload: !(result == ConnectivityResult.none ||
            result == ConnectivityResult.bluetooth),
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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if (!state.connected) {
          return const NoConnectivityPage();
        }

        if (widget.type == PageType.empty) {
          return Scaffold(
            body: widget.body,
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
                top: MediaQuery.of(context).viewPadding.top - 5.0,
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

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 400.0),
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
