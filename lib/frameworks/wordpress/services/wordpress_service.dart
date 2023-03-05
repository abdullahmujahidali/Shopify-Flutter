import 'dart:convert' as convert;
import 'dart:core';
import 'dart:io' show File;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/strings.dart';

import '../../../common/constants.dart';
import '../../../common/tools/image_tools.dart';
import '../../../models/entities/index.dart';
import '../../../services/base_services.dart';

class WordPressService extends BaseServices {
  WordPressService({
    required String domain,
  })  : isSecure = domain.contains('https') ? '' : '&insecure=cool',
        super(
          domain: domain,
        );

  final String isSecure;

  @override
  Future<List<Category>> getCategories({lang = 'en'}) async {
    try {
      var list = <Category>[];
      var isEnd = false;
      var page = 1;
      var limit = 100;

      while (!isEnd) {
        var categories =
            await getWPCategoriesByPage(lang: lang, page: page, limit: limit);
        if (categories.isEmpty || categories.length < limit) {
          isEnd = true;
        }
        for (var item in categories) {
          if (item['slug'] == 'uncategorized') {
            continue;
          }
          list.add(Category.fromWordPress(item));
        }
        page = page + 1;
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  Future<List> getWPCategoriesByPage(
      {lang = 'en', int page = 1, int limit = 100}) async {
    try {
      var response = await blogApi
          .getAsync('categories?per_page=$limit&page=$page&lang=$lang');
      return response;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Blog?> getPageById(int? pageId) async {
    try {
      var response = await blogApi.getAsync('pages/$pageId?_embed');
      if (response['code'] != null) return null;
      return Blog.fromJson(response);
    } catch (e, trace) {
      printError(e, trace);
      rethrow;
    }
  }

  @override
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

  @override
  Future<User?> loginFacebook({String? token}) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint =
          '$domain/wp-json/api/flutter_user/fb_connect/?second=$cookieLifeTime'
          // ignore: prefer_single_quotes
          "&access_token=$token$isSecure";

      var response = await httpGet(endPoint.toUri()!);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode['cookie'] == null) {
        throw Exception(jsonDecode['message']);
      }

      final cookie = jsonDecode['cookie'];
      final user = jsonDecode['user'];
      return User.fromWordpressUser(user, cookie);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<User> loginSMS({String? token}) async {
    try {
      //var endPoint = "$url/wp-json/api/flutter_user/sms_login/?access_token=$token$isSecure";
      var endPoint =
          // ignore: prefer_single_quotes
          "$domain/wp-json/api/flutter_user/firebase_sms_login?phone=$token$isSecure";

      var response = await httpGet(endPoint.toUri()!);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode['cookie'] == null) {
        throw Exception(jsonDecode['message']);
      }

      final cookie = jsonDecode['cookie'];
      final user = jsonDecode['user'];
      return User.fromWordpressUser(user, cookie);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<User?> loginApple(
      {String? token, String? firstName, String? lastName}) async {
    try {
      var endPoint = '$domain/wp-json/api/flutter_user/apple_login';

      var response = await httpPost(endPoint.toUri()!,
          body: convert.jsonEncode({'token': token}),
          headers: {'Content-Type': 'application/json'});

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode['cookie'] == null) {
        throw Exception(jsonDecode['message']);
      }

      final cookie = jsonDecode['cookie'];
      final user = jsonDecode['user'];
      return User.fromWordpressUser(user, cookie);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<User?> loginGoogle({String? token}) async {
    const cookieLifeTime = 120960000000;

    try {
      var endPoint =
          '$domain/wp-json/api/flutter_user/google_login/?second=$cookieLifeTime'
                  '&access_token=$token$isSecure'
              .toUri()!;

      var response = await httpGet(endPoint);

      var jsonDecode = convert.jsonDecode(response.body);

      if (jsonDecode['wp_user_id'] == null || jsonDecode['cookie'] == null) {
        throw Exception(jsonDecode['message']);
      }
      final cookie = jsonDecode['cookie'];
      final user = jsonDecode['user'];
      return User.fromWordpressUser(user, cookie);
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<User?> getUserInfo(cookie) async {
    try {
      var base64Str = EncodeUtils.encodeCookie(cookie);
      final response = await httpGet(
          '$domain/wp-json/api/flutter_user/get_currentuserinfo?token=$base64Str&$isSecure'
              .toUri()!);
      final body = convert.jsonDecode(response.body);
      if (body['user'] != null) {
        var user = body['user'];
        return User.fromWordpressUser(user, cookie);
      } else {
        if (body['message'] != 'Invalid cookie') {
          throw Exception(body['message']);
        }
        return null;

        /// we may handle if Invalid cookie here
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<User?> createUser({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? phoneNumber,
    bool isVendor = false,
  }) async {
    try {
      var niceName = [firstName ?? '', lastName ?? ''].join(' ').trim();

      final response = await httpPost(
          '$domain/wp-json/api/flutter_user/register/?insecure=cool'.toUri()!,
          body: convert.jsonEncode({
            'user_email': username,
            'user_login': username,
            'username': username,
            'user_pass': password,
            'email': username,
            'user_nicename': niceName,
            'display_name': niceName,
            'first_name': firstName,
            'last_name': lastName,
          }));

      var body = convert.jsonDecode(response.body);

      if (response.statusCode == 200 && body['message'] == null) {
        var cookie = body['cookie'];
        return await getUserInfo(cookie);
      } else {
        var message = body['message'];
        throw Exception(message ?? 'Can not create the user.');
      }
    } catch (err) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document
      rethrow;
    }
  }

  @override
  Future<User?> login({username, password}) async {
    var cookieLifeTime = 120960000000;
    try {
      final response = await httpPost(
          '$domain/wp-json/api/flutter_user/generate_auth_cookie/?insecure=cool&$isSecure'
              .toUri()!,
          body: convert.jsonEncode({'seconds': cookieLifeTime.toString(), 'username': username, 'password': password}),
          headers: {'Content-Type': 'application/json'});

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200 && isNotBlank(body['cookie'])) {
        // final jwtAuthToken = await getJwtAuth(username, password);
        var user = await getUserInfo(body['cookie']);
        // user?.jwtToken = jwtAuthToken;
        return user;
      } else {
        throw Exception('The username or password is incorrect.');
      }
    } catch (err, trace) {
      printError(err, trace, '🔥 Integration error:');
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  Future<String?> getJwtAuth(String username, String password) async {
    try {
      var endPoint =
          '$domain/wp-json/jwt-auth/v1/token?username=$username&password=$password'
              .toUri();
      var response = await http.post(endPoint!);
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode['token'] == null) {
        throw Exception(jsonDecode['code']);
      }
      debugPrint("[getJwtAuth]: ${jsonDecode['token']}");
      return jsonDecode['token'];
    } catch (e, trace) {
      debugPrint('[getJwtAuth] fail: $trace');
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document or contact supporters/
      rethrow;
    }
  }

  Future<void> createBlog(
      {required File file,
      required String cookie,
      required Map<String, dynamic> data}) async {
    try {
      final base64 = await ImageTools.compressImage(file);
      var token = EncodeUtils.encodeCookie(cookie);
      data['token'] = token;
      data['image'] = base64;
      var endPoint = '$domain/wp-json/api/flutter_blog/blog/create'.toUri();

      var response = await httpPost(endPoint!, body: data, enableDio: true);
      if (response.statusCode != 200) {
        throw convert.jsonDecode(response.body)['message'];
      }
    } catch (e, trace) {
      printError(e, trace);
      rethrow;
    }
  }

  Future<List<Blog>?> getBlogsByUserId(String userId) async {
    try {
      var response = await blogApi.getAsync('posts?_embed&author=$userId');
      var list = <Blog>[];
      if (response == null) return <Blog>[];
      for (var item in response) {
        list.add(Blog.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Blog>> searchBlog({required String name}) async {
    try {
      var response = await blogApi.getAsync('posts?_embed&search=$name');

      var list = <Blog>[];
      for (var item in response) {
        list.add(Blog.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Blog?> getBlogByPermalink(String blogPermaLink) async {
    try {
      final response = await httpGet(
          '$domain/wp-json/api/flutter_blog/blog/dynamic?url=$blogPermaLink'
              .toUri()!);
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Blog.fromJson(body);
      } else if (body['message'] != null) {
        throw Exception(body['message']);
      }
      return null;
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getHomeCache(String? lang) async {
    try {
      final jsonData = await httpGet(
          '$domain/wp-content/uploads/flutter_config_files/config_$lang.json'
              .toUri()!);
      final myDataString = convert.utf8.decode(jsonData.bodyBytes);
      final data = convert.jsonDecode(myDataString);
      if (data == null || data is! Map) {
        throw Exception("Can't get home cache");
      }
      if (data['message'] != null) {
        throw Exception(data['message']);
      }
      var config = Map<String, dynamic>.from(data);
      if (config['HorizonLayout'] != null) {
        var horizontalLayout = config['HorizonLayout'] as List;
        List<dynamic>? items = [];
        for (var i = 0; i < horizontalLayout.length; i++) {
          if (horizontalLayout[i]['radius'] != null) {
            horizontalLayout[i]['radius'] =
                double.parse("${horizontalLayout[i]["radius"]}");
          }
          if (horizontalLayout[i]['size'] != null) {
            horizontalLayout[i]['size'] =
                double.parse("${horizontalLayout[i]["size"]}");
          }
          if (horizontalLayout[i]['padding'] != null) {
            horizontalLayout[i]['padding'] =
                double.parse("${horizontalLayout[i]["padding"]}");
          }

          items = horizontalLayout[i]['items'] as List?;
          if (items != null && items.isNotEmpty) {
            for (var j = 0; j < items.length; j++) {
              if (items[j]['padding'] != null) {
                items[j]['padding'] = double.parse("${items[j]["padding"]}");
              }
            }
          }
        }

        if (config['VerticalLayout'] != null &&
            config['VerticalLayout']['data'] != null) {
          var list = <Product>[];
          config['VerticalLayout']['data'] = list;
        }
        return config;
      }
      return null;
    } catch (e, trace) {
      printLog(trace);
      printLog(e);
      return null;
    }
  }

  @override
  Future<bool> deleteAccount(String token) async {
    try {
      final response = await httpDelete(
          '$domain/wp-json/api/flutter_user/delete_account'.toUri()!,
          headers: {
            'User-Cookie': token,
            'Content-Type': 'application/json',
          });
      var body = convert.jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
        throw body['message'];
      }
      return body;
    } catch (e) {
      rethrow;
    }
  }
}
