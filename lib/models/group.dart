import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/user.dart';

class Group {
  final String id;
  final String? title;
  final String? description;
  final String? module;
  final User? creator;
  final List<User>? members;
  final List<User>? joinRequests;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;
  final bool imageExists;
  final List<Message>? messages;

  const Group({
    required this.id,
    this.title,
    this.description,
    this.module,
    this.creator,
    this.members,
    this.joinRequests,
    this.createdAt,
    this.lat,
    this.lon,
    this.imageExists = false,
    this.messages,
  });

  factory Group.fromApi(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      module: data['module'],
      creator:
          data.containsKey('creator') ? User.fromApi(data['creator']) : null,
      members: ((data['members'] ?? []) as List<dynamic>)
          .map((e) => User.fromApi(e))
          .toList(),
      joinRequests: ((data['joinRequests'] ?? []) as List<dynamic>)
          .map((e) => User.fromApi(e))
          .toList(),
      // parse date
      createdAt: data.containsKey('createdAt')
          ? DateTime.parse(data['createdAt'])
          : null,
      lat: data['lat'],
      lon: data['lon'],
      imageExists: data['imageExists'] ?? false,
      messages: [],
    );
  }

  Group update({
    String? id,
    String? title,
    String? description,
    String? module,
    User? creator,
    List<User>? members,
    List<User>? joinRequests,
    DateTime? createdAt,
    double? lat,
    double? lon,
    bool? imageExists,
    List<Message>? messages,
  }) {
    return Group(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      module: module ?? this.module,
      creator: creator ?? this.creator,
      members: members ?? this.members,
      joinRequests: joinRequests ?? this.joinRequests,
      createdAt: createdAt ?? this.createdAt,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      imageExists: imageExists ?? this.imageExists,
      messages: messages ?? this.messages,
    );
  }
}
