import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/redux/app_state.dart';
import '../pages/loading_page.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Stack(
          children: [
            body,
            if (state.loading) const LoadingPage(),
          ],
        );
      }
    );
  }
}