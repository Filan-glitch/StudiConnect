/// This library contains the [PageWrapper] widget.
///
/// {@category WIDGETS}
library widgets.page_wrapper;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:oktoast/oktoast.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/pages/loading_page.dart';
import 'package:studiconnect/widgets/action_menu.dart';

/// A widget that wraps the main content of a page.
///
/// This widget is a stateless widget that takes a title, body, bottom navigation bar,
/// menu actions, header controls, padding, and a flag for simple design and loading screen override as input.
/// It displays a Scaffold with an AppBar, body, and bottom navigation bar.
/// The AppBar contains the title and an optional action menu.
/// The body contains the main content of the page, wrapped in a Container with padding.
///
/// The [title] parameter is required and represents the title of the page.
///
/// The [body] parameter is required and represents the main content of the page.
///
/// The [bottomNavigationBar] parameter is optional and represents the bottom navigation bar of the page.
///
/// The [menuActions] parameter is optional and defaults to an empty list. It represents the actions in the action menu.
///
/// The [headerControls] parameter is optional and defaults to an empty list. It represents the controls in the header of the page.
///
/// The [simpleDesign] parameter is optional and defaults to false. If set to true, the page will have a simple design.
///
/// The [padding] parameter is optional and defaults to EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0).
/// It represents the padding of the main content of the page.
///
/// The [overrideLoadingScreen] parameter is optional and defaults to false. If set to true, the loading screen will be overridden.
class PageWrapper extends StatelessWidget {
  const PageWrapper({
    required this.title,
    required this.body,
    this.bottomNavigationBar,
    this.menuActions = const [],
    this.headerControls = const [],
    this.simpleDesign = false,
    this.padding = const EdgeInsets.only(
      left: 20.0,
      right: 20.0,
      top: 20.0,
    ),
    this.overrideLoadingScreen = false,
    super.key,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Widget> headerControls;
  final String title;
  final List<Widget> menuActions;
  final bool simpleDesign;
  final EdgeInsets padding;
  final bool overrideLoadingScreen;

  @override
  Widget build(BuildContext context) {
    // Main content of the page
    Widget mainContent;

    // If simple design is enabled, use a simple Scaffold
    if (simpleDesign) {
      mainContent = Scaffold(
          appBar: AppBar(
            actions: [
              if (menuActions.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showActionMenu(context),
                ),
            ],
            title: Text(title),
            titleTextStyle: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            child: body,
          ));
    } else {
      // If simple design is not enabled, use a custom Scaffold
      mainContent = Scaffold(
        bottomNavigationBar: bottomNavigationBar,
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
                                title,
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
                          if (menuActions.isNotEmpty)
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
                    if (headerControls.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          children: [
                            ...headerControls,
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
                          padding: padding,
                          child: body,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      );
    }

    // Return the main content wrapped in a StoreConnector and OKToast
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (BuildContext context, state) {
          return OKToast(
            child: Stack(
              children: [
                mainContent,
                if (state.loading && !overrideLoadingScreen)
                  const LoadingPage(),
              ],
            ),
          );
        });
  }

  /// Shows the action menu.
  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 400.0),
      builder: (context) => ActionMenu(
        children: menuActions,
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