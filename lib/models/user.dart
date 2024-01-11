import 'package:studiconnect/models/group.dart';

class User {
  String id;
  String? email;
  String? username;
  String? university;
  String? major;
  double? lat;
  double? lon;
  String? bio;
  String? mobile;
  String? discord;
  List<Group>? groups;

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
