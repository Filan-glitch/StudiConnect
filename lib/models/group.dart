/// This library contains the model for a [Group].
///
/// {@category MODELS}
library models.group;

import 'package:studiconnect/models/message.dart';
import 'package:studiconnect/models/user.dart';

/// A class that represents a group.
///
/// This class contains all the information about a group, including its ID, title, description,
/// module, creator, members, join requests, creation date, and location.
class Group {

  /// The group's ID.
  final String id;

  /// The group's title.
  final String? title;

  /// The group's description.
  final String? description;

  /// The group's module.
  final String? module;

  /// The group's creator.
  final User? creator;

  /// The group's members.
  final List<User>? members;

  /// The group's join requests.
  final List<User>? joinRequests;

  /// The group's creation date.
  final DateTime? createdAt;

  /// The group's latitude.
  final double? lat;

  /// The group's longitude.
  final double? lon;

  /// The boolean value indicating whether the group has an image.
  final bool imageExists;

  /// The group's messages.
  final List<Message>? messages;

  /// Constructor for the [Group] class.
  ///
  /// Takes in the required and optional parameters and initializes the group with these values.
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

  /// A method that updates the properties of the group.
  ///
  /// The [id], [title], [description], [module], [creator], [members], [joinRequests], [createdAt],
  /// [lat], [lon], and [imageExists] parameters are optional and represent the new values of the corresponding properties.
  /// If a parameter is not provided, the corresponding property will not be updated.
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