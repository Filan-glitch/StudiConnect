import 'package:geolocator/geolocator.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final bool verified;
  final String university;
  final String major;
  final Position? location;
  final String bio;
  final String mobile;
  final String discord;
  final String photoUrl;

  const User({
    this.uid = '',
    this.email = '',
    this.username = '',
    this.verified = false,
    this.university = '',
    this.major = '',
    this.location,
    this.bio = '',
    this.mobile = '',
    this.discord = '',
    this.photoUrl = '',
  });

  static fromApi(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      verified: data['verified'],
      university: data['university'],
      major: data['major'],
      location: data['location'],
      bio: data['bio'],
      mobile: data['mobile'],
      discord: data['discord'],
      photoUrl: data['photoUrl'],
    );
  }
}