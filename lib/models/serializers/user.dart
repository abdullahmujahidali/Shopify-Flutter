import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class SerializerUser {
  String? jwt;
  User? user;

  SerializerUser({this.jwt, this.user});

  factory SerializerUser.fromJson(Map<String, dynamic> json) =>
      _$SerializerUserFromJson(json);

  Map<String, dynamic> toJson() => _$SerializerUserToJson(this);

  @override
  String toString() => 'UserSerializer { user $user}';
}

@JsonSerializable()
class User {
  int? id;
  String? username;
  String? email;
  String? displayName;
//  @JsonKey(nullable: true)
//  Role role;
  User({this.id, this.username, this.email, this.displayName});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Role {
  int? id;
  String? name;
  String? description;
  String? type;
  Role({this.id, this.name, this.description, this.type});
  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
