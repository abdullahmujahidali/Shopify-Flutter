// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerUser _$SerializerUserFromJson(Map<String, dynamic> json) {
  return SerializerUser(
    jwt: json['jwt'] as String?,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SerializerUserToJson(SerializerUser instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int?,
    username: json['username'] as String?,
    email: json['email'] as String?,
    displayName: json['displayName'] as String?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'displayName': instance.displayName,
    };

Role _$RoleFromJson(Map<String, dynamic> json) {
  return Role(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    type: json['type'] as String?,
  );
}

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': instance.type,
    };
