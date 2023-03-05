import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/entities/paging_response.dart';
import '../../models/index.dart';
import 'blognews_api.dart';

export '../../models/entities/paging_response.dart';

class BlogServices {
  final BlogNewsApi blogApi;

  BlogServices(String blogDomain) : blogApi = BlogNewsApi(blogDomain);

  Future<List<Blog>> fetchBlogLayout({required config, lang}) async {
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

      var response = await blogApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Blog.fromJson(item));
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<Blog?> getPageById(int? pageId) async {
    var response = await blogApi.getAsync('pages/$pageId?_embed');
    if (response['code'] != null) {
      return null; 
    }
    return Blog.fromJson(response);
  }

  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor) async {
    try {
      final param =
          '_embed&page=$cursor${kAdvanceConfig.alwaysRefreshBlog ? '&dummy=${DateTime.now().millisecondsSinceEpoch}' : ''}';
      final response =
          await http.get('${blogApi.url}/wp-json/wp/v2/posts?$param'.toUri()!);
      if (response.statusCode != 200) {
        return const PagingResponse();
      }
      List data = jsonDecode(response.body);
      return PagingResponse(
          data: data.map((e) {
        return Blog.fromJson(e);
      }).toList());
    } on Exception catch (_) {
      return const PagingResponse();
    }
  }
}
