/// This file contains the [NoConnectivityPage] widget.
///
/// {@category PAGES}
library pages.no_connectivity_page;

import 'package:flutter/material.dart';

/// A StatelessWidget that displays a page when there is no internet connection.
///
/// The page contains an icon and messages informing the user that there is no internet connection
/// and asking them to check their connection and try again.
class NoConnectivityPage extends StatelessWidget {

  /// Creates a [NoConnectivityPage] widget.
  const NoConnectivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// An icon indicating no internet connection.
            Icon(
              Icons.wifi_off,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 30),
            /// A message informing the user that there is no internet connection.
            const Text(
              'Keine Internetverbindung gefunden',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            /// A message asking the user to check their internet connection and try again.
            const Text(
              'Bitte überprüfe deine Internetverbindung und versuche es erneut.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}