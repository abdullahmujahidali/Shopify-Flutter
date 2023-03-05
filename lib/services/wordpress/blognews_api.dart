import 'dart:convert';
import 'dart:core';
import 'dart:io' show File, HttpHeaders;

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';

import '../../common/constants.dart';


// class QueryString {
//   static Map parse(String query) {
//     var search = RegExp('([^&=]+)=?([^&]*)');
//     var result = {};
//
//     if (query.startsWith('?')) query = query.substring(1);
//     String decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));
//
//     for (Match match in search.allMatches(query)) {
//       result[decode(match.group(1)!)] = decode(match.group(2)!);
//     }
//     return result;
//   }
// }

class BlogNewsApi {
  final String url;
  final bool isRoot; 

  BlogNewsApi(this.url, {this.isRoot = true});

  Uri? _getOAuthURL(String requestMethod, String endpoint) {
    return '$url/wp-json/wp/v2/$endpoint'.toUri();
  }

  Future<http.StreamedResponse> getStream(String endPoint) async {
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    return client.send(request);
  }

  Future<dynamic> getAsync(String endPoint) async {
    final url = _getOAuthURL('GET', endPoint)!;
    Response? response;
    if (isRoot) {
      response = await httpGet(url);
    } else {
      response = await http.get(url);
    }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return;
  }

  Future<dynamic> postAsync(String endPoint, Map? data, {String? token}) async {
    var url = _getOAuthURL('POST', endPoint)!;
    var client = http.Client();
    var request = http.Request('POST', url);
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = 'no-cache';
    if (token != null) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    request.body = json.encode(data);
    var response =
        await client.send(request).then((res) => res.stream.bytesToString());

    var dataResponse = await json.decode(response);
    return dataResponse;
  }

  Future<dynamic> putAsync(String endPoint, Map data) async {
    var url = _getOAuthURL('PUT', endPoint)!;

    var client = http.Client();
    var request = http.Request('PUT', url);
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = 'no-cache';
    request.body = json.encode(data);
    var response =
        await client.send(request).then((res) => res.stream.bytesToString());
    var dataResponse = await json.decode(response);
    return dataResponse;
  }

  Future<dynamic> uploadBlogImage(File imageFile, String token) async {
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();
    //client
    var client = http.Client();
    // string to uri
    var uri = Uri.parse('$url/wp-json/wp/v2/media');
    // create multipart request
    var request = http.MultipartRequest('POST', uri);
    request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    request.headers[HttpHeaders.contentTypeHeader] =
        'application/json; charset=utf-8';
    request.headers[HttpHeaders.cacheControlHeader] = 'no-cache';
    // multipart that takes file
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    // add file to multipart
    request.files.add(multipartFile);
    // send
    var response =
        await client.send(request).then((res) => res.stream.bytesToString());

    var dataResponse = await json.decode(response);

    if (dataResponse['id'] != null) {
      return dataResponse;
    } else {
      throw Exception('Error: $dataResponse');
    }
  }
}
