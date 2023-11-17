import 'package:geolocator/geolocator.dart';

class User {
  String uid;
  String email;
  String username;
  bool verified;
  bool public;
  String university;
  String major;
  Position? location;
  String bio;
  String mobile;
  String discord;

  User({
    this.uid = '',
    this.email = '',
    this.username = '',
    this.verified = false,
    this.public = false,
    this.university = '',
    this.major = '',
    this.location,
    this.bio = '',
    this.mobile = '',
    this.discord = '',
  });
}