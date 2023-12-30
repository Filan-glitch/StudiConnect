/// This library contains constants used throughout the app.
///
/// {@category CORE}
library core.constants;
import 'package:flutter/foundation.dart';

/// The base URL of the backend server.
///
/// This constant is set to the local IP address of the server when in debug mode,
/// and to the production URL when not in debug mode.
const backendURL = kDebugMode
    ? 'http://192.168.178.21:8080'
    : 'https://studiconnect.janbellenberg.de';

/// The URL of the terms of service page.
///
/// This constant is set to the URL of the terms of service page on the production server.
const termsURL = "https://studiconnect.janbellenberg.de/terms";

/// The URL of the imprint page.
///
/// This constant is set to the URL of the imprint page on the production server.
const imprintURL = "https://studiconnect.janbellenberg.de/imprint";

/// The URL of the privacy policy page.
///
/// This constant is set to the URL of the privacy policy page on the production server.
const privacyURL = "https://studiconnect.janbellenberg.de/privacy";