import 'user.dart';

class Group {
  final String? id;
  final String? title;
  final String? description;
  final String? module;
  final User? creator;
  final List<User>? members;
  final List<User>? joinRequests;
  final String? createdAt;
  final double? lat;
  final double? lon;

  const Group({
    this.id,
    this.title,
    this.description,
    this.module,
    this.creator,
    this.members,
    this.joinRequests,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory Group.fromApi(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      module: data['module'],
      creator: User.fromApi(data['creator']),
      members: data['members'] != null
          ? (data['members'] as List).map((e) => User.fromApi(e)).toList()
          : null,
      joinRequests: data['joinRequests'] != null
          ? (data['joinRequests'] as List).map((e) => User.fromApi(e)).toList()
          : null,
      createdAt: data['createdAt'],
      lat: data['lat'],
      lon: data['lon'],
    );
  }
}
