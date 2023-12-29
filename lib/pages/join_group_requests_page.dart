import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/widgets/join_group_request_list_item.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/models/user.dart';

class JoinGroupRequestsPage extends StatelessWidget {
  const JoinGroupRequestsPage({super.key});

  static const routeName = '/join-group-requests';

  @override
  Widget build(BuildContext context) {
    final requests = ModalRoute.of(context)!.settings.arguments as List<User>;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return PageWrapper(
            title: 'Anfragen',
            simpleDesign: true,
            body: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return JoinGroupRequestListItem(request: requests[index]);
              },
            ),
          );
      }
    );
  }
}