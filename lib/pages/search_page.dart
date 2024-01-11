/// This library contains the SearchPage widget.
///
/// {@category PAGES}
library pages.search_page;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/menu_action.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;
import 'package:studiconnect/models/redux/store.dart';

/// A StatefulWidget that allows the user to search for groups.
///
/// The page contains a text field for the user to enter the module they are interested in,
/// and a slider to set the search radius.
/// The search results are displayed as a list of groups.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

/// The state for the [SearchPage] widget.
///
/// This class contains the logic for handling the user's input and performing the search.
class _SearchPageState extends State<SearchPage> {
  /// The controller for the module input text field.
  late final TextEditingController _moduleInputController;

  /// The radius of the search, in kilometers.
  late double _radius;

  /// A timer that delays the search query to avoid unnecessary requests while the user is typing.
  late Timer _delayQueryTimer;

  String? _error;

  /// Loads the search results based on the current module input and search radius.
  void _loadSearchResults() {
    log('Loading search results...');
    final String module = _moduleInputController.text;

    if (module.isEmpty) {
      _delayQueryTimer.cancel();
      return;
    }

    searchGroups(module, _radius.toInt());
  }

  @override
  void initState() {
    super.initState();
    _radius = 10;
    _moduleInputController = TextEditingController();
    _delayQueryTimer = Timer(
      const Duration(seconds: 1),
        () {
          if (StoreProvider.of<AppState>(context).state.user?.lat == null ||
            StoreProvider.of<AppState>(context).state.user?.lon == null) {
            setState(() {
              _error = 'Bitte bearbeite dein Profil und gib deinen Standort an.';
            });
            return;
          }
          _loadSearchResults;
        }
    );

    store.dispatch(
      redux.Action(
        redux.ActionTypes.updateSearchResults,
        payload: <Group>[],
      ),
    );
  }

  @override
  void dispose() {
    _moduleInputController.dispose();
    _delayQueryTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Suche',
      type: PageType.complex,
      overrideLoadingScreen: true,
      headerControls: [
        TextField(
          controller: _moduleInputController,
          onChanged: (value) {
            _delayQueryTimer.cancel();
            _delayQueryTimer = Timer(
              const Duration(seconds: 1),
              () {
                if (StoreProvider.of<AppState>(context).state.user?.lat == null ||
                    StoreProvider.of<AppState>(context).state.user?.lon == null) {
                  setState(() {
                    _error = 'Bitte bearbeite dein Profil und gib deinen Standort an.';
                  });
                  return;
                }
                _loadSearchResults();
              },
            );
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Modul',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            children: [
              const Text('Radius:', style: TextStyle(color: Colors.white)),
              Expanded(
                child: Slider(
                  inactiveColor: Colors.white,
                  activeColor: Colors.white,
                  min: 0,
                  max: 100,
                  value: _radius,
                  onChanged: (value) {
                    setState(() {
                      _radius = value;
                    });

                    _delayQueryTimer.cancel();
                    _delayQueryTimer = Timer(
                      const Duration(seconds: 1),
                        () {
                          if (StoreProvider.of<AppState>(context).state.user?.lat == null ||
                              StoreProvider.of<AppState>(context).state.user?.lon == null) {
                            setState(() {
                              _error = 'Bitte bearbeite dein Profil und gib deinen Standort an.';
                            });
                            return;
                          }
                          _loadSearchResults;
                        }
                    );
                  },
                ),
              ),
              Text('${_radius.toInt()} km',
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
      /// The menu actions include the option to navigate to the settings page.
      menuActions: [
        MenuAction(
            icon: Icons.share,
            title: 'Studiconnect weiterempfehlen',
            onTap: () {
              navigatorKey.currentState!.pop();
              Share.share(
                  'Schau dir StudiConnect an: https://play.google.com/store/apps/details?id=de.studiconnect.app');
            }),
        MenuAction(
          icon: Icons.settings,
          title: 'Einstellungen',
          onTap: () {
            navigatorKey.currentState!.pop();
            navigatorKey.currentState!.pushNamed('/settings');
          },
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.searchResults.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => RefreshIndicator(
                  onRefresh: () async {
                    _loadSearchResults();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Text(_error ?? 'Keine Ergebnisse'),
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadSearchResults();
              },
              backgroundColor: Theme.of(context).progressIndicatorTheme.refreshBackgroundColor,
              child: ListView.builder(
                itemCount: state.searchResults.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final Group group = state.searchResults[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Modul: ${group.module ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Studiengang: ${group.creator?.major ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Hochschule: ${group.creator?.university ?? ''}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Erstellt von ${group.creator!.username}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Mitglieder: ${group.members!.length}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/group-info',
                          arguments: GroupLookupParameters(
                            groupID: group.id,
                            source: GroupSource.searchedGroups,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}