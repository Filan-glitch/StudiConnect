/// This library contains the [JoinGroupRequestsPage] class.
///
/// {@category PAGES}
library pages.join_group_requests_page;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/widgets/join_group_request_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';


/// A stateless widget that represents the join group requests page.
///
/// The page displays a list of all join requests for a group, and allows the
/// creator of the group to accept or reject the requests.
class JoinGroupRequestsPage extends StatelessWidget {

  /// Creates a [JoinGroupRequestsPage] widget.
  const JoinGroupRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final groupID = ModalRoute.of(context)!.settings.arguments as String;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final group =
            state.user?.groups?.firstWhere((group) => group.id == groupID);

        if ((group?.joinRequests ?? []).isEmpty) {
          return const PageWrapper(
            title: 'Anfragen',
            body: Center(
              child: Text('Keine Anfragen'),
            ),
          );
        }

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