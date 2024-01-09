import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studiconnect/controllers/groups.dart';
import 'package:studiconnect/main.dart';
import 'package:studiconnect/models/group.dart';
import 'package:studiconnect/models/group_parameter.dart';
import 'package:studiconnect/models/redux/app_state.dart';
import 'package:studiconnect/services/logger_provider.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';
import 'package:studiconnect/models/redux/actions.dart' as redux;
import 'package:studiconnect/models/redux/store.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final DateFormat _formatter;
  late final TextEditingController _moduleInputController;
  late double _radius;
  late Timer _delayQueryTimer;

  void _loadSearchResults() {
    log("Loading search results...");
    String module = _moduleInputController.text;

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
    _formatter = DateFormat('dd.MM.yyyy');
    _delayQueryTimer = Timer(
      const Duration(seconds: 1),
      _loadSearchResults,
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
              _loadSearchResults,
            );
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Modul",
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
              const Text("Radius:", style: TextStyle(color: Colors.white)),
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
                      _loadSearchResults,
                    );
                  },
                ),
              ),
              Text("${_radius.toInt()} km",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
      menuActions: [
        ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Studiconnect weiterempfehlen'),
            onTap: () {
              navigatorKey.currentState!.pop();
              Share.share(
                  'Schau dir StudiConnect an: https://play.google.com/store/apps/details?id=de.studiconnect.app');
            }),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Einstellungen'),
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
                      child: const Center(
                        child: Text("Keine Ergebnisse"),
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
              child: ListView.builder(
                itemCount: state.searchResults.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  Group group = state.searchResults[index];
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
                            'Erstellt an ${_formatter.format(group.createdAt!)}',
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
