import 'dart:async';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';

class PaypalServices {
  String domain = kPaypalConfig['production'] == true
      ? 'https://api.paypal.com'
      : 'https://api.sandbox.paypal.com';

  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(
        kPaypalConfig['clientId'],
        kPaypalConfig['secret'],
      );
      var response = await client.post(
          '$domain/v1/oauth2/token?grant_type=client_credentials'.toUri()!);
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return body['access_token'];
      } else {
        throw body['error_description'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String?>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post('$domain/v1/payments/payment'.toUri()!,
          body: convert.jsonEncode(transactions),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body['links'] != null && body['links'].length > 0) {
          List links = body['links'];

          String? executeUrl = '';
          String? approvalUrl = '';
          final item = links.firstWhere((o) => o['rel'] == 'approval_url',
              orElse: () => null);
          if (item != null) {
            approvalUrl = item['href'];
          }
          final item1 = links.firstWhere((o) => o['rel'] == 'execute',
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1['href'];
          }
          return {'executeUrl': executeUrl, 'approvalUrl': approvalUrl};
        }
        return null;
      } else {
        if (body['details'] is List && body['details'].length > 0) {
          final details = body['details'][0];
          if (details is Map) {
            throw Exception(details['issue']);
          }
        }
        throw Exception(body['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> executePayment(url, payerId, accessToken) async {
    try {
      var response = await http.post(Uri.parse(url),
          body: convert.jsonEncode({'payer_id': payerId}),
          headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          });

      final body = convert.jsonDecode(response.body);

      if (response.statusCode == 200) {
        return body['id'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
