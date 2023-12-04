import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/redux/app_state.dart';
import '../pages/loading_page.dart';
import 'action_menu.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    required this.title,
    required this.body,
    this.bottomNavigationBar,
    this.menuActions = const [],
    this.simpleDesign = false,
    super.key,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final String title;
  final List<Widget> menuActions;
  final bool simpleDesign;

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (simpleDesign) {
      mainContent = Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: body,
        )
      );
    } else {
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
                        child: body,
                      ),
                    ),
                  ],
                );
              }),
        ),
      );
    }

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Stack(
          children: [
            mainContent,
            if (state.loading) const LoadingPage(),
          ],
        );
      }
    );
  }

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