/// This library contains the LoadingPage widget.
///
/// {@category PAGES}
library pages.loading_page;

import 'package:flutter/material.dart';

/// A StatelessWidget that displays a loading spinner.
///
/// The page contains a centered CircularProgressIndicator and a text message "Bitte warten...".
/// The CircularProgressIndicator uses the primary color of the current theme.
class LoadingPage extends StatelessWidget {

  /// Creates a [LoadingPage] widget.
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                height: 150.0,
                width: 150.0,
                child: CircularProgressIndicator(
                  /// The color of the CircularProgressIndicator is the primary color of the current theme.
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  strokeWidth: 3.0,
                ),
              )
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Bitte warten...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}