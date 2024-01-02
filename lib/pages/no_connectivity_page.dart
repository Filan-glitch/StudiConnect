import 'package:flutter/material.dart';

class NoConnectivityPage extends StatelessWidget {
  const NoConnectivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.wifi_off,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 30),
            const Text(
              'Keine Internetverbindung gefunden',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
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
