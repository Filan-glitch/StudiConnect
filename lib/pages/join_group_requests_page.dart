/// This library contains the JoinGroupRequestsPage widget.
///
/// {@category PAGES}
library pages.join_group_requests_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/join_group_request_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

/// A StatelessWidget that displays a list of join requests for a group.
///
/// The page contains a list of the join requests for the group, each represented by a [JoinGroupRequestListItem].
/// If the group has no join requests, a message is displayed to the user.
class JoinGroupRequestsPage extends StatelessWidget {
  const JoinGroupRequestsPage({super.key});

  /// The route name for navigation.
  static const routeName = '/join-group-requests';

  @override
  Widget build(BuildContext context) {
    /// The ID of the group for which to display join requests.
    final groupID = ModalRoute.of(context)!.settings.arguments as String;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        /// The group for which to display join requests.
        final group =
            state.user?.groups?.firstWhere((group) => group.id == groupID);

        /// If the group has no join requests, display a message to the user.
        if ((group?.joinRequests ?? []).isEmpty) {
          return const PageWrapper(
            title: 'Anfragen',
            body: Center(
              child: Text('Keine Anfragen'),
            ),
          );
        }

        /// If the group has join requests, display a list of the requests.
        return PageWrapper(
          title: 'Anfragen',
          body: ListView.builder(
            itemCount: group!.joinRequests?.length ?? 0,
            itemBuilder: (context, index) {
              return JoinGroupRequestListItem(
                group: group,
                user: group.joinRequests![index],
              );
            },
          ),
        );
      },
    );
  }
}