import '/models/user.dart';

class Group {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final String module;
  final User creator;
  final List<User> members;
  final String createdAt;
  final double lat;
  final double long;

  const Group({
    required this.id,
    required this.title,
    required this.description,
    required this.photoUrl,
    required this.module,
    required this.creator,
    required this.members,
    required this.createdAt,
    required this.lat,
    required this.long
  });

  static fromApi(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      title: data['name'],
      description: data['description'],
      photoUrl: data['photoUrl'],
      module: data['module'],
      creator: User.fromApi(data['creator']),
      members: data['members'],
      createdAt: data['createdAt'],
      lat: data['lat'],
      long: data['long'],
    );
  }
}