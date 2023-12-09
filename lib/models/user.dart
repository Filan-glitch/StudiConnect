import 'package:geolocator/geolocator.dart';

class User {
  String uid;
  String profilePictureUrl;
  String email;
  String name;
  bool verified;
  String university;
  String course;
  Position? location;
  String bio;
  String contact;

  User({
    this.uid = '',
    this.profilePictureUrl = '',
    this.email = '',
    this.name = '',
    this.verified = false,
    this.university = '',
    this.course = '',
    this.location,
    this.bio = '',
    this.contact = '',
  });

  update({
    String? uid,
    String? profilePictureUrl,
    String? email,
    String? name,
    bool? verified,
    String? university,
    String? course,
    Position? location,
    String? bio,
    String? contact,
  }) {
    this.uid = uid ?? this.uid;
    this.profilePictureUrl = profilePictureUrl ?? this.profilePictureUrl;
    this.email = email ?? this.email;
    this.name = name ?? this.name;
    this.verified = verified ?? this.verified;
    this.university = university ?? this.university;
    this.course = course ?? this.course;
    this.location = location ?? this.location;
    this.bio = bio ?? this.bio;
    this.contact = contact ?? this.contact;
  }

  User.fromApi(Map<String, dynamic> json)
      : uid = json['uid'] ?? '',
        profilePictureUrl = json['profilePictureUrl'] ?? '',
        email = json['email'] ?? '',
        name = json['name'] ?? '',
        verified = json['verified'] ?? false,
        university = json['university'] ?? '',
        course = json['course'] ?? '',
        location = json['location'],
        bio = json['bio'] ?? '',
        contact = json['contact'] ?? '';
}