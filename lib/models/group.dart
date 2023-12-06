class Group {
  final String id;
  final String name;
  final String description;
  final String photoUrl;

  const Group({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
  });

  factory Group.fromApi(Map<String, dynamic> data) {
    return Group(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      photoUrl: data['photoUrl'],
    );
  }
}