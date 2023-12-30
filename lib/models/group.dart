/// This library contains the model for a [Group].
///
/// {@category MODELS}
library models.group;
import 'package:studiconnect/models/user.dart';

/// A class that represents a group.
///
/// This class contains all the information about a group, including its ID, title, description,
/// module, creator, members, join requests, creation date, and location.
///
/// The [id] parameter is required and represents the ID of the group.
///
/// The [title] parameter is optional and represents the title of the group.
///
/// The [description] parameter is optional and represents the description of the group.
///
/// The [module] parameter is optional and represents the module of the group.
///
/// The [creator] parameter is optional and represents the creator of the group.
///
/// The [members] parameter is optional and represents the members of the group.
///
/// The [joinRequests] parameter is optional and represents the join requests of the group.
///
/// The [createdAt] parameter is optional and represents the creation date of the group.
///
/// The [lat] and [lon] parameters are optional and represent the latitude and longitude of the group.
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
  });

  /// A factory constructor that creates a new instance of the [Group] class from a map.
  ///
  /// The [data] parameter is required and represents the map from which the group is created.
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
      // parse date
      createdAt: data.containsKey("createdAt")
          ? DateTime.parse(data['createdAt'])
          : null,
      lat: data['lat'],
      lon: data['lon'],
    );
  }

  /// A method that updates the properties of the group.
  ///
  /// The [id], [title], [description], [module], [creator], [members], [joinRequests], [createdAt],
  /// [lat], and [lon] parameters are optional and represent the new values of the corresponding properties.
  /// If a parameter is not provided, the corresponding property will not be updated.
  update({
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
    );
  }
}