import '../../common/constants.dart';

class Brand {
  dynamic id;
  String? name;
  String? slug;
  String? description;
  String? image;

  Brand(this.id, this.name, this.slug, this.description, this.image);

  Brand.empty(this.id)
      : name = '',
        slug = '',
        description = '',
        image = '';

  Brand.fromJson(Map parsedJson) {
    try {
      id = parsedJson['id'].toString();
      name = parsedJson['name'];
      slug = parsedJson['slug'];
      description = parsedJson['description'];
      if (parsedJson['image'] != null) {
        image = parsedJson['image']['src'];
      }
    } catch (e, trace) {
      printLog(trace);
      printLog('Brand $name error: ${e.toString()}');
    }
  }

  Brand.fromBigCommerce(dynamic json) {
    try {
      id = json['id'].toString();
      name = json['name'] as String;
      image = ((json['image_url'] as String?)?.isNotEmpty ?? false)
          ? json['image_url']
          : kDefaultImage;
      description = json['meta_description'];
    } catch (e, trace) {
      printLog(trace);
      printLog('Brand $name error: ${e.toString()}');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'image': image
    };
  }

  @override
  String toString() => 'Brand {id: $id, name: $name}';
}
