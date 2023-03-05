import '../../common/constants.dart';
import '../../common/tools/tools.dart';
import '../../services/index.dart';

class Review {
  int? id;
  int? productId;
  String? name;
  String? email;
  String? review;
  double? rating;
  late DateTime createdAt;
  String? avatar;
  String? status;
  int? isApproved;
  List<String> images = [];
  bool verified = false;

  Review.fromJson(Map parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['reviewer'];
    email = parsedJson['email'];
    review = parsedJson['review'];
    rating = double.parse(parsedJson['rating'].toString());
    verified = parsedJson['verified'] ?? false;
    createdAt = parsedJson['date_created'] != null
        ? DateTime.tryParse(parsedJson['date_created']) ?? DateTime.now()
        : DateTime.now();
    if (parsedJson['images'] != null && parsedJson['images'] is List) {
      for (var item in parsedJson['images']) {
        images.add(item);
      }
    }
  }

  Review.fromOpencartJson(Map parsedJson) {
    id = parsedJson['review_id'] != null
        ? int.parse(parsedJson['review_id'])
        : 0;
    name = parsedJson['author'];
    email = parsedJson['author'];
    review = parsedJson['text'];
    rating =
        parsedJson['rating'] != null ? double.parse(parsedJson['rating']) : 0.0;
    createdAt = parsedJson['date_added'] != null
        ? DateTime.parse(parsedJson['date_added'])
        : DateTime.now();
  }

  Review.fromMagentoJson(Map parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['name'];
    email = parsedJson['email'];
    review = parsedJson['review'];
    rating = parsedJson['rating'];
    createdAt = parsedJson['date_created'] != null
        ? DateTime.parse(parsedJson['date_created'])
        : DateTime.now();
  }

  Review.fromWCFMJson(Map parsedJson) {
    id = int.parse(parsedJson['ID']);
    name = parsedJson['author_name'];
    email = parsedJson['author_email'];
    review = Tools.removeHTMLTags(parsedJson['review_description']);
    avatar = parsedJson['author_image'];
    rating = double.parse(parsedJson['review_rating']);
    createdAt = parsedJson['created'] != null
        ? DateTime.parse(parsedJson['created'])
        : DateTime.now();
    isApproved = int.parse(parsedJson['approved'] ?? '0');
  }

  Review.fromDokanJson(Map parsedJson) {
    id = parsedJson['id'];
    name = parsedJson['author']['name'];
    email = parsedJson['author']['email'];
    avatar = parsedJson['author']['avatar'];
    review = parsedJson['content'];
    rating = double.parse("${parsedJson["rating"]}");
    createdAt = parsedJson['date'] != null
        ? DateTime.parse(parsedJson['date'])
        : DateTime.now();
  }

  Review.fromListing(Map parsedJson) {
    try {
      id = int.parse(parsedJson['id'].toString());

      name = parsedJson['author_name'] ?? '';

      email = parsedJson['author_email'] ?? '';
      try {
        review = parsedJson['content']['rendered'] ?? '';
      } catch (e) {
        review = parsedJson['content'] ?? '';
      }
      rating = parsedJson['rating'] != null &&
              parsedJson['rating'].toString().isNotEmpty
          ? double.parse(parsedJson['rating'].toString())
          : 0.0;

      if (ServerConfig().typeName == 'listpro') {
        rating = parsedJson['lp_listingpro_options']['rating'] != null &&
                parsedJson['lp_listingpro_options']['rating']
                    .toString()
                    .isNotEmpty
            ? double.parse(
                parsedJson['lp_listingpro_options']['rating'].toString())
            : 0.0;
      }

      createdAt = parsedJson['date'] != null
          ? DateTime.parse(parsedJson['date'])
          : DateTime.now();

      status = parsedJson['status'] ?? 'approved';
    } catch (err) {
      printLog('FluxListing Review $err');
    }
  }

  String get displayName => name ?? 'Anonymous';

  String get displayContent => review ?? '';

  @override
  String toString() => 'Category { id: $id  name: $name}';
}
