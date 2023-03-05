import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../data/boxes.dart';
import '../models/comment.dart';
import '../models/entities/brand.dart';
import '../models/entities/order_delivery_date.dart';
import '../models/entities/paging_response.dart';
import '../models/entities/prediction.dart';
import '../models/entities/vacation_settings.dart';
import '../models/index.dart';
import '../modules/dynamic_layout/config/app_config.dart';
import 'service_config.dart';
import 'wordpress/blognews_api.dart';

export '../models/entities/paging_response.dart';

abstract class BaseServices {
  final BlogNewsApi blogApi;

  final String domain;

  BaseServices({
    required this.domain,
    String? blogDomain,
  }) : blogApi = BlogNewsApi(
          blogDomain ?? domain,
          isRoot: blogDomain == null,
        );

  String get currencyCode => SettingsBox().currencyCode ?? 'USD';

  String get languageCode => SettingsBox().languageCode ?? 'en';

  // get sort key to filter products
  String? getOrderByKey(orderBy) => null;

  dynamic getOrderDirection(order) => null;

  Future<List<Category>?>? getCategories({lang}) async => const <Category>[];

  Future<List<Product>>? getProducts({userId}) => null;

  Future<List<Product>?> fetchProductsLayout(
          {required config, lang, userId, bool refreshCache = false}) async =>
      const <Product>[];

  Future<List<Product>?> fetchProductsByCategory(
          {categoryId,
          tagId,
          required page,
          minPrice,
          maxPrice,
          orderBy,
          lang,
          order,
          featured,
          onSale,
          attribute,
          attributeTerm,
          listingLocation,
          userId,
          String? search,
          String? include,
          String? nextCursor}) async =>
      const <Product>[];

  Future<AppConfig?> getAppConfig({String lang = 'en'}) async => null;

  Future<User?>? loginFacebook({String? token}) => null;

  Future<User>? loginSMS({String? token}) => null;

  Future<bool> isUserExisted({String? phone, String? username}) async => true;

  Future<User?>? loginApple(
          {String? token, String? firstName, String? lastName}) =>
      null;

  Future<User?>? loginGoogle({String? token}) => null;

  Future<PagingResponse<Review>>? getReviews(productId,
          {int page = 1, int perPage = 10}) =>
      null;

  Future<List<ProductVariation>?>? getProductVariations(Product product,
          {String? lang}) =>
      null;

  Future<List<ShippingMethod>>? getShippingMethods(
          {CartModel? cartModel,
          String? token,
          String? checkoutId,
          Store? store,
          String? langCode}) =>
      null;

  Future<List<PaymentMethod>>? getPaymentMethods(
          {CartModel? cartModel,
          ShippingMethod? shippingMethod,
          String? token,
          String? langCode}) =>
      null;

  Future<Order>? createOrder({
    CartModel? cartModel,
    UserModel? user,
    bool? paid,
    String? transactionId,
  }) =>
      null;

  Future<PagingResponse<Order>>? getMyOrders({
    User? user,
    dynamic cursor,
    String? cartId,
  }) =>
      null;

  Future? updateOrder(orderId, {status, required token}) => null;

  Future? deleteOrder(orderId, {required token}) => null;

  Future<Order?>? cancelOrder({
    required Order? order,
    required String? userCookie,
  }) =>
      null;

  Future<PagingResponse<Product>>? searchProducts({
    name,
    categoryId,
    categoryName,
    tag,
    attribute,
    attributeId,
    required page,
    lang,
    listingLocation,
    userId,
  }) =>
      null;

  Future<User?>? getUserInfo(cookie) => null;

  Future<User?>? createUser({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? phoneNumber,
    bool isVendor = false,
  }) =>
      null;

  Future<Map<String, dynamic>?>? updateUserInfo(
          Map<String, dynamic> json, String? token) =>
      null;

  Future<User?>? login({
    username,
    password,
  }) =>
      null;

  Future<Product?>? getProduct(id, {lang}) => null;

  Future<ProductVariation?>? getVariationProduct(id, variationId, {lang}) =>
      null;

  Future<Coupons>? getCoupons({int page = 1, String search = ''}) => null;

  Future<List<OrderNote>>? getOrderNote({
    String? userId,
    String? orderId,
  }) =>
      null;

  Future? createReview(
          {String? productId, Map<String, dynamic>? data, String? token}) =>
      null;

  Future<Map<String, dynamic>?>? getHomeCache(String? lang) => null;

  Future<List<Blog>?> fetchBlogLayout({required config, lang}) async {
    try {
      var list = <Blog>[];
      var endPoint = 'posts?_embed';
      if (kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$lang';
      }
      if (config.containsKey('category')) {
        endPoint += "&categories=${config["category"]}";
      }
      if (config.containsKey('tag')) {
        endPoint += "&tags=${config["tag"]}";
      }
      if (config.containsKey('limit')) {
        endPoint += "&per_page=${config["limit"] ?? 20}";
      }
      if (config.containsKey('page')) {
        endPoint += "&page=${config["page"]}";
      }

      var response = await blogApi.getAsync(endPoint);

      if (response != null) {
        for (var item in response) {
          list.add(Blog.fromJson(item));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<Blog?> getPageById(int? pageId) async {
    var response = await blogApi.getAsync('pages/$pageId?_embed');
    if (response['code'] != null) return null;
    return Blog.fromJson(response);
  }

  Future? getCategoryWithCache() => null;

  Future<List<FilterAttribute>>? getFilterAttributes({String? lang}) => null;

  Future<List<SubAttribute>>? getSubAttributes({
    int? id,
    String? lang,
    int page = 1,
  }) =>
      null;

  Future<List<FilterTag>>? getFilterTags({String? lang}) => null;

  Future<String>? getCheckoutUrl(Map<String, dynamic> params, String? lang) =>
      null;

  Future<String?>? submitForgotPassword({
    String? forgotPwLink,
    Map<String, dynamic>? data,
  }) =>
      null;

  Future? logout(String? token) => null;

  Future? checkoutWithCreditCard(String? vaultId, CartModel cartModel,
      Address address, PaymentSettingsModel paymentSettingsModel) {
    return null;
  }

  Future<PaymentSettings>? getPaymentSettings() {
    return null;
  }

  Future<PaymentSettings>? addCreditCard(
      PaymentSettingsModel paymentSettingsModel,
      CreditCardModel creditCardModel) {
    return null;
  }

  Future<Map<String, dynamic>?>? getCurrencyRate() => null;

  Future<List<dynamic>?>? getCartInfo(String? token) => null;

  Future? syncCartToWebsite(CartModel cartModel, User? user) => null;

  Future<Map<String, dynamic>>? getCustomerInfo(String? id) => null;

  Future<Map<String, dynamic>?>? getTaxes(CartModel cartModel) => null;

  Future<PagingResponse<Tag>?> getTags({String? lang}) async => null;

  Future<Tag>? getTagById({required String tagId}) => null;

  Future<PagingResponse<Tag>>? getTagsByPage(
          {String? lang, int? page, required int limit}) =>
      null;

  Future<Tag?> getTagBySlug(String slug) async => null;

  Future? getCountries() => null;

  Future? getStatesByCountryId(countryId) => null;

  Future? getCitiesByStateId(countryId, stateId) => null;

  Future? getZipCodeByAddress(countryId, stateId, city) => null;

  Future<Point?>? getMyPoint(String? token) => null;

  Future? updatePoints(String? token, Order? order) => null;

  //For vendor
  Future<Store?>? getStoreInfo(storeId) => null;

  Future<bool>? pushNotification(
    cookie, {
    receiverEmail,
    senderName,
    message,
  }) =>
      null;

  Future<List<Review>>? getReviewsStore({storeId, page, perPage}) => null;

  Future<List<Product>>? getProductsByStore(
          {storeId,
          int? page,
          int? perPage,
          int? catId,
          bool? onSale,
          String? order,
          String? orderBy,
          String? searchTerm,
          String lang = 'en'}) =>
      null;

  Future<List<Store>>? searchStores({
    String? keyword,
    int? page,
  }) =>
      null;

  Future<List<Store>>? getFeaturedStores() => null;

  Future<PagingResponse<Order>>? getVendorOrders({
    required User user,
    dynamic cursor,
  }) =>
      null;

  Future<Product>? createProduct(String? cookie, Map<String, dynamic> data) =>
      null;

  Future<void>? deleteProduct(
          {required String? cookie, required String? productId}) =>
      null;

  Future<List<Product>>? getOwnProducts(
    String? cookie, {
    int? page,
    int? perPage,
  }) =>
      null;

  Future<dynamic>? uploadImage(dynamic data, String? token) => null;

  Future<List<Prediction>>? getAutoCompletePlaces(
          String term, String? sessionToken) =>
      null;

  Future<Prediction>? getPlaceDetail(
          Prediction prediction, String? sessionToken) =>
      null;

  Future<List<Store>>? getNearbyStores(Prediction prediction,
          {int page = 1, int perPage = 10, int radius = 10, String? name}) =>
      null;

  Future<Product?> getProductByPermalink(String productPermalink) async {
    return null;
  }

  Future<Category?> getProductCategoryByPermalink(
      String productCategoryPermalink) async {
    return null;
  }

  Future<Store?> getStoreByPermalink(String storePermaLink) async {
    return null;
  }

  Future<Blog?> getBlogByPermalink(String blogPermaLink) async {
    return null;
  }

  Future<List<Brand>?> getBrands(
          {int page = 1, int perPage = 10, required String lang}) async =>
      null;

  Future<List<Product>?> fetchProductsByBrand(
          {dynamic page, String? lang, String? brandId}) async =>
      null;

  ///----FLUXSTORE LISTING----///
  Future<dynamic>? bookService({userId, value, message}) => null;

  Future<List<Product>>? getProductNearest(location) => null;

  Future<List<ListingBooking>>? getBooking({userId, page, perPage}) => null;

  Future<Map<String, dynamic>?>? checkBookingAvailability({data}) => null;

  Future<List<dynamic>>? getLocations() => null;

  /// BOOKING FEATURE
  Future<bool>? createBooking(dynamic bookingInfo) => null;

  Future<List<dynamic>>? getListStaff(String? idProduct) => null;

  Future<List<String>>? getSlotBooking(
          String? idProduct, String idStaff, String date) =>
      null;

  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor) async {
    try {
      final param =
          '_embed&page=${cursor ?? 1}${kAdvanceConfig.alwaysRefreshBlog ? '&dummy=${DateTime.now().millisecondsSinceEpoch}' : ''}';
      final response =
          await http.get('${blogApi.url}/wp-json/wp/v2/posts?$param'.toUri()!);
      if (response.statusCode != 200) {
        return const PagingResponse();
      }
      List data = jsonDecode(response.body);
      return PagingResponse(
          data: data.map((e) {
        return Blog.fromWooJson(e);
      }).toList());
    } on Exception catch (_) {
      return const PagingResponse();
    }
  }

  /// RAZORPAY PAYMENT
  Future<String?> createRazorpayOrder(params) async {
    try {
      var client = BasicAuthClient(
          kRazorpayConfig['keyId'], kRazorpayConfig['keySecret']);
      final response = await client
          .post('https://api.razorpay.com/v1/orders'.toUri()!, body: params);
      final responseJson = jsonDecode(response.body);
      if (responseJson != null && responseJson['id'] != null) {
        return responseJson['id'];
      } else if (responseJson['message'] != null) {
        throw responseJson['message'];
      } else if (responseJson['error'] != null &&
          responseJson['error']['description'] != null) {
        throw responseJson['error']['description'];
      } else {
        throw "Can't create order for Razorpay";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderIdForRazorpay(paymentId, orderId) async {
    try {
      final token = base64.encode(latin1.encode(
          '${kRazorpayConfig['keyId']}:${kRazorpayConfig['keySecret']}'));

      var body = {};
      if (ServerConfig().isWooType) {
        body = {
          'notes': {'woocommerce_order_id': orderId}
        };
      }

      await http.patch(
          'https://api.razorpay.com/v1/payments/$paymentId'.toUri()!,
          headers: {
            'Authorization': 'Basic ${token.trim()}',
            'Content-Type': 'application/json'
          },
          body: json.encode(body));
    } catch (e) {
      return;
    }
  }

  Future<List<Blog>> searchBlog({required String name}) async => const <Blog>[];

  Future<List<Blog>> fetchBlogsByCategory(
      {categoryId, page, lang, order = 'desc'}) async {
    try {
      var list = <Blog>[];

      var endPoint =
          'posts?_embed&lang=$lang&per_page=15&page=$page&order=${order ?? 'desc'}';
      if (categoryId != null) {
        endPoint += '&categories=$categoryId';
      }
      var response = await blogApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Blog.fromJson(item));
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Tag>> getBlogTags({String? lang}) async {
    try {
      var list = <Tag>[];
      var endPoint =
          'tags?per_page=100&page=1&hide_empty=${kAdvanceConfig.hideEmptyTags}';
      if (lang != null && kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$lang';
      }
      var response = await blogApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Tag.fromJson(item));
      }
      return list;
    } catch (e, trace) {
      printError(e, trace);
      return [];
    }
  }

  Future<Blog> getBlogById(dynamic id) async {
    final response = await http.get(
        '${blogApi.url}/wp-json/wp/v2/posts/$id?_embed${kAdvanceConfig.alwaysRefreshBlog ? '&dummy=${DateTime.now().millisecondsSinceEpoch}' : ''}'
            .toUri()!);
    var body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Blog.fromJson(body);
    }
    return Blog.empty(id);
  }

  Future<List<Category>> getCategoriesByPage(
          {lang,
          page,
          limit,
          storeId,
          String? searchTerm,
          int? parent,
          bool useCompute = true}) async =>
      [];

  Future<PagingResponse<Category>> getSubCategories({
    String? langCode,
    dynamic page = 1,
    int limit = 25,
    required String? parentId,
  }) async =>
      const PagingResponse<Category>();

  Future<List<OrderDeliveryDate>> getListDeliveryDates({storeId}) async =>
      <OrderDeliveryDate>[];

  Future<Category?> getProductCategoryById(
          {required String categoryId}) async =>
      null;

  Future<VacationSettings?> getVacationSettings(String storeId) async => null;

  Future<bool?> setVacationSettings(
          String cookie, VacationSettings vacationSettings) async =>
      null;

  Future<List<Comment>?> getCommentsByPostId({postId}) async {
    try {
      var list = <Comment>[];

      var endPoint = 'comments?';
      if (postId != null) {
        endPoint += 'post=$postId';
      }

      var response = await blogApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Comment.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createComment({
    int? blogId,
    String? content,
    String? cookie,
  }) async {
    try {
      //return true if comment created successful, false if otherwise
      if (cookie == null) {
        return false;
      }
      final token = EncodeUtils.encodeCookie(cookie);
      var data = {
        'content': content,
        'post_id': blogId.toString(),
        'token': token,
      };
      final dataResponse = await http.post(
          '${blogApi.url}/wp-json/api/flutter_blog/blog/comment'.toUri()!,
          body: data);
      final body = jsonDecode(dataResponse.body);
      if (body is Map && body['message'] != null) {
        throw body['message'];
      } else {
        return body == true;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Blog>?> getBlogsByCategory(int? cateId) async {
    try {
      var url = 'posts?_embed';
      if (cateId != null) {
        url = 'posts?_embed&categories=$cateId';
      }
      var response = await blogApi.getAsync(url);
      var list = <Blog>[];
      for (var item in response) {
        list.add(Blog.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Category>> getBlogCategories({lang = 'en'}) async {
    try {
      var response = await blogApi.getAsync('categories?per_page=20');
      var list = <Category>[];
      for (var item in response) {
        if (item['slug'] == 'uncategorized') {
          continue;
        }
        list.add(Category.fromWordPress(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic>? getDataFromScanner(String data, {String? cookie}) => null;

  Future<String?> getBlogContent(dynamic id) async => null;

  Future<List<Order>> getVendorAdminOrders(
      {required String cookie,
      int page = 1,
      int perPage = 10,
      String? status,
      String? search,
      String? name}) async {
    var list = <Order>[];
    try {
      var base64Str = EncodeUtils.encodeCookie(cookie);
      var endpoint =
          '$domain/wp-json/vendor-admin/vendor-orders?page=$page&per_page=$perPage&token=$base64Str&platform=${ServerConfig().platform}';
      if (status != null) {
        if (status.toLowerCase() == 'onhold') {
          status = 'on-hold';
        }
        endpoint += '&status=$status';
      }
      if (search != null && search.trim().isNotEmpty) {
        endpoint += '&search=$search';
      }
      if (name != null && name.trim().isNotEmpty) {
        endpoint += '&name=$name';
      }
      printLog(endpoint);

      final response = await httpGet(
        endpoint.toUri()!,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        for (var item in result['response']) {
          list.add(Order.fromJson(item));
        }
      }
    } catch (e) {
      printLog('vendor_admin.dart getVendorOrders: $e');
    }
    return list;
  }

  Future<String?> createPaymentIntentStripe(
      {required String totalPrice,
      String? currencyCode,
      String? emailAddress,
      String? name,
      required String paymentMethodId}) async {
    try {
      final urlReq = '${kStripeConfig["serverEndpoint"]}/payment-intent';
      final result = await http.post(
        urlReq.toUri()!,
        body: jsonEncode(
          {
            'payment_method_id': paymentMethodId,
            'email': emailAddress,
            'amount': totalPrice,
            'currencyCode': currencyCode,
            'returnUrl': kStripeConfig['returnUrl'],
            'captureMethod': (kStripeConfig['enableManualCapture'] ?? false)
                ? 'manual'
                : 'automatic',
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      var response = json.decode(result.body);
      if (result.statusCode == 200) {
        final body = response is List ? response[0] : response;
        final success = body['success'];
        if (success) {
          return body['client_secret'];
        }
      } else if (response['message'] != null) {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<String?> createPaymentIntentStripeV2({
    required String totalPrice,
    String? currencyCode,
    String? emailAddress,
    String? name,
  }) async {
    try {
      final urlReq = '${kStripeConfig["serverEndpoint"]}/payment-intent-v2';
      final result = await http.post(
        urlReq.toUri()!,
        body: jsonEncode(
          {
            'email': emailAddress,
            'amount': totalPrice,
            'currencyCode': currencyCode,
            'returnUrl': kStripeConfig['returnUrl'],
            'captureMethod': (kStripeConfig['enableManualCapture'] ?? false)
                ? 'manual'
                : 'automatic',
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      var response = json.decode(result.body);
      if (result.statusCode == 200) {
        final body = response is List ? response[0] : response;
        final success = body['success'];
        if (success == true) {
          return body['client_secret'];
        }

        if (response['message'] != null) {
          throw Exception(response['message']);
        }
      }

      throw Exception('Unknown error. Please try again.');
    } catch (e, trace) {
      printError(e, trace);
      rethrow;
    }
  }

  Future<String?> createPaymentIntentStripeV3({
    String? orderId,
    required String totalPrice,
    String? currencyCode,
    String? emailAddress,
    String? name,
  }) async {
    try {
      final urlReq = '${kStripeConfig["serverEndpoint"]}/payment-intent-v3';
      final result = await http.post(
        urlReq.toUri()!,
        body: jsonEncode(
          {
            'email': emailAddress,
            'amount': totalPrice,
            'currencyCode': currencyCode,
            'returnUrl': kStripeConfig['returnUrl'],
            'captureMethod': (kStripeConfig['enableManualCapture'] ?? false)
                ? 'manual'
                : 'automatic',
            'request3dSecure': 'any',
            'orderId': orderId,
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      var response = json.decode(result.body);
      if (result.statusCode == 200) {
        final body = response is List ? response[0] : response;
        final success = body['success'];
        if (success == true) {
          return body['client_secret'];
        }

        if (response['message'] != null) {
          throw Exception(response['message']);
        }
      }

      throw Exception('Unknown error. Please try again.');
    } catch (e, trace) {
      printError(e, trace);
      rethrow;
    }
  }

  Future<List<ProductItem>> getListProductItemByOrderId(String orderId) async {
    return const <ProductItem>[];
  }

  Future<List<String>> getImagesByProductId(String productId) async {
    return const <String>[];
  }

  Future<bool> checkProductPermission(String productId, String? cookie) async {
    return true;
  }

  Future<bool> deleteAccount(String token) async {
    /// If so fast, Apple will be suspect this action is ambiguous
    /// And has no effect on the account.
    /// So we need to wait for a while.
    /// This is a workaround.
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  Future<Brand?> getBrandById(brandId) async {
    return null;
  }

  Future<Brand?> getBrandBySlug(String slug) async {
    return null;
  }

  Future<PagingResponse<Product>> getProductsByCategoryId(
    String categoryId, {
    String? langCode,
    dynamic page = 1,
    int limit = 25,
  }) async =>
      const PagingResponse<Product>();

  Future<int?> getProductCountOfCategory(String categoryId) async {
    return null;
  }

  Future<Order>? createIAPOrder(Map<String, dynamic> params, User? user) =>
      null;

  Future<RatingCount?>? getProductRatingCount(String productId) async {
    return null;
  }
}
