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
      creator:
          data.containsKey("creator") ? User.fromApi(data['creator']) : null,
      members: ((data['members'] ?? []) as List<dynamic>)
          .map((e) => User.fromApi(e))
          .toList(),
      joinRequests: ((data['joinRequests'] ?? []) as List<dynamic>)
          .map((e) => User.fromApi(e))
          .toList(),
      createdAt: data['createdAt'],
      lat: data['lat'],
      lon: data['lon'],
    );
  }
}
