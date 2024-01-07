import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/join_group_request_list_item.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class JoinGroupRequestsPage extends StatelessWidget {
  const JoinGroupRequestsPage({super.key});

  static const routeName = '/join-group-requests';

  @override
  Widget build(BuildContext context) {
    log("Building JoinGroupRequestsPage...");
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
