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

  factory User.fromApi(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      verified: data['verified'],
      public: data['public'],
      university: data['university'],
      major: data['major'],
      location: data['location'],
      bio: data['bio'],
      mobile: data['mobile'],
      discord: data['discord'],
    );
  }
}
