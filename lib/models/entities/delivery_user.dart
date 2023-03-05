import '../../common/constants.dart';

class DeliveryUser {
  int? id;
  String? profilePicture;
  String? name;

  DeliveryUser.fromJson(json) {
    id = int.parse(json['id']?.toString() ?? '-1');
    name = json['name'] ?? '';
    if (json['profile_picture'] != null &&
        json['profile_picture'] is List &&
        List.from(json['profile_picture']).isEmpty) {
      profilePicture = kDefaultImage;
    } else {
      profilePicture = json['profile_picture'] ?? kDefaultImage;
    }
  }
}
