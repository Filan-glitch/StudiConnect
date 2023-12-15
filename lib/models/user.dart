class User {
  String? id;
  String? email;
  String? username;
  String? university;
  String? major;
  double? lat;
  double? lon;
  String? bio;
  String? mobile;
  String? discord;

  User({
    this.id,
    this.email,
    this.username,
    this.university,
    this.major,
    this.lat,
    this.lon,
    this.bio,
    this.mobile,
    this.discord,
  });

  update({
    String? id,
    String? email,
    String? username,
    String? university,
    String? major,
    double? lat,
    double? lon,
    String? bio,
    String? mobile,
    String? discord,
  }) {
    this.id = id ?? this.id;
    this.email = email ?? this.email;
    this.username = username ?? this.username;
    this.university = university ?? this.university;
    this.major = major ?? this.major;
    this.lat = lat ?? this.lat;
    this.lon = lon ?? this.lon;
    this.bio = bio ?? this.bio;
    this.mobile = mobile ?? this.mobile;
    this.discord = discord ?? this.discord;
  }

  User.fromApi(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        university = json['university'],
        major = json['major'],
        lat = json['lat'],
        lon = json['lon'],
        bio = json['bio'],
        mobile = json['mobile'],
        discord = json['discord'];
}
