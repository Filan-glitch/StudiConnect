import 'package:flutter/material.dart';
import 'package:studiconnect/constants.dart';

import 'package:studiconnect/models/user.dart';

class JoinGroupRequestListItem extends StatefulWidget {
  const JoinGroupRequestListItem({super.key, required this.request});

  final User request;

  @override
  State<JoinGroupRequestListItem> createState() => _JoinGroupRequestListItemState();
}

class _JoinGroupRequestListItemState extends State<JoinGroupRequestListItem> {
  var _acceptLoading = false;
  var _declineLoading = false;
  var _decided = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage("$backendURL/api/user/${widget.request.id}/image"),
      ),
      title: Text(widget.request.username ?? "Unbekannt"),
      subtitle: Text(widget.request.university ?? ""),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_decided) IconButton(
            icon: (_acceptLoading) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary,), strokeWidth: 2.0)) : const Icon(Icons.check),
            onPressed: () {
              setState(() {
                _acceptLoading = true;
              });
              //TODO: API Call
              setState(() {
                _decided = true;
              });
            },
          ),
          if(!_decided) IconButton(
            icon: (_declineLoading) ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary,), strokeWidth: 2.0)) : const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _declineLoading = true;
              });
              //TODO: API Call
              setState(() {
                _decided = true;
              });
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, '/user-info', arguments: widget.request);
      },
    );
  }
  
}