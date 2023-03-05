// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SerializerBlog _$SerializerBlogFromJson(Map<String, dynamic> json) {
  return SerializerBlog(
    id: json['id'] as int?,
    title: json['title'] as String?,
    content: json['content'] as String?,
    subTitle: json['subTitle'] as String?,
    user: json['users_permissions_user'] == null
        ? null
        : User.fromJson(json['users_permissions_user'] as Map<String, dynamic>),
    images: (json['image_feature'] as List<dynamic>?)
        ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
        .toList(),
  )..date = json['created_at'] as String?;
}

Map<String, dynamic> _$SerializerBlogToJson(SerializerBlog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'subTitle': instance.subTitle,
      'created_at': instance.date,
      'users_permissions_user': instance.user,
      'image_feature': instance.images,
    };
