import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';
import 'package:studiconnect/controllers/authentication.dart';
import 'package:studiconnect/constants.dart';
import 'package:studiconnect/widgets/page_wrapper.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "Einstellungen",
      showLoading: false,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                child: SizedBox(
                  height: 100.0,
                  child: Image.asset(
                    "assets/icons/icon.png",
                  ),
                ),
              ),
              FutureBuilder(
                future: rootBundle.loadString("pubspec.yaml"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Version: ${loadYaml(
                        snapshot.data.toString(),
                      )["version"].split("+")[0]}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  color: Color.fromARGB(255, 117, 117, 117),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("Lizenzen"),
                onTap: () {
                  showLicensePage(
                    context: context,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.error),
                title: const Text("Nutzungsbedingungen"),
                onTap: () {
                  launchUrl(
                    Uri.parse(
                      termsURL,
                    ),
                    mode: LaunchMode.inAppWebView,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text("Datenschutz"),
                onTap: () {
                  launchUrl(
                      Uri.parse(
                        privacyURL,
                      ),
                      mode: LaunchMode.inAppWebView);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text("Impressum"),
                onTap: () {
                  launchUrl(
                    Uri.parse(
                      imprintURL,
                    ),
                    mode: LaunchMode.inAppWebView,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  color: Color.fromARGB(255, 117, 117, 117),
                ),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red.withOpacity(0.7)),
                title: const Text("Abmelden"),
                onTap: () async {
                  await signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
