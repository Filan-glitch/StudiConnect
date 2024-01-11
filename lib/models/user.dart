/// This library contains the [User] class.
///
/// {@category MODELS}
library models.user;

import 'package:studiconnect/models/group.dart';

/// Class representing a user in the application.
///
/// The user class includes properties for the user's ID, email, username, university, major,
/// latitude, longitude, bio, mobile, discord, and groups.
class User {

  /// The user's ID.
  String id;

  /// The user's email.
  String? email;

  /// The user's username.
  String? username;

  /// The user's university.
  String? university;

  /// The user's major.
  String? major;

  /// The user's latitude.
  double? lat;

  /// The user's longitude.
  double? lon;

  /// The user's bio.
  String? bio;

  /// The user's mobile number.
  String? mobile;

  /// The user's discord username.
  String? discord;

  /// The user's groups.
  List<Group>? groups;

  /// Constructor for the [User] class.
  ///
  /// Takes in the required and optional parameters and initializes the user with these values.
  User({
    required this.id,
    this.email,
    this.username,
    this.university,
    this.major,
    this.lat,
    this.lon,
    this.bio,
    this.mobile,
    this.discord,
    this.groups,
  });

  /// Method to update the properties of the user.
  ///
  /// The [id], [email], [username], [university], [major], [lat], [lon], [bio], [mobile],
  /// [discord], and [groups] parameters are optional and represent the new values of the corresponding properties.
  /// If a parameter is not provided, the corresponding property will not be updated.
  void update({
    String? id,
    String? email,
    String? username,
    String? university,
    String? major,
    double? lat,
    double? lon,
    String? bio,
    String? mobile,
    String? discord,
    List<Group>? groups,
  }) {
    this.id = id ?? this.id;
    this.email = email ?? this.email;
    this.username = username ?? this.username;
    this.university = university ?? this.university;
    this.major = major ?? this.major;
    this.lat = lat ?? this.lat;
    this.lon = lon ?? this.lon;
    this.bio = bio ?? this.bio;
    this.mobile = mobile ?? this.mobile;
    this.discord = discord ?? this.discord;
    this.groups = groups ?? this.groups;
  }

  /// Constructs a [User] instance from a map of key-value pairs ([json]).
  ///
  /// This constructor is named [fromApi] to indicate that it is used to construct a [User] instance from data received from an API.
  User.fromApi(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        university = json['university'],
        major = json['major'],
        lat = json['lat']?.toDouble(),
        lon = json['lon']?.toDouble(),
        bio = json['bio'],
        mobile = json['mobile'],
        discord = json['discord'],
        groups = ((json['groups'] ?? []) as List<dynamic>)
            .map((group) => Group.fromApi(group))
            .toList();
}