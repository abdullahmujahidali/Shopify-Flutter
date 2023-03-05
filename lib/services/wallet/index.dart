import 'dart:convert' as convert;

import 'package:inspireui/inspireui.dart';
import 'package:quiver/strings.dart';

import '../../models/entities/paging_response.dart';
import '../../models/entities/product.dart';
import '../../models/entities/transaction.dart';
import '../../models/entities/transfer_form.dart';
import '../../models/entities/user.dart';
import 'wallet_services.dart';

class TeraWalletServices extends WalletServices {
  TeraWalletServices({required this.domain});

  final String domain;

  @override
  Future<double> getBalance({required String token}) async {
    try {
      var response = await httpGet(
          Uri.parse('$domain/wp-json/api/flutter_tera_wallet/balance'),
          headers: {'User-Cookie': token});
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        return double.parse(jsonDecode);
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<PagingResponse<Transaction>> getTransactions({
    required dynamic page,
    required String token,
  }) async {
    try {
      var list = <Transaction>[];
      var response = await httpGet(
          Uri.parse(
              '$domain/wp-json/api/flutter_tera_wallet/transactions?page=$page&length=10'),
          headers: {'User-Cookie': token});
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        for (var item in jsonDecode) {
          list.add(Transaction.fromJson(item));
        }
        return PagingResponse(data: list);
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future processPayment({
    required String orderId,
    String? token,
  }) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_tera_wallet/process_payment'),
          body: convert.jsonEncode({
            'order_id': orderId,
          }),
          headers: {
            'User-Cookie': token ?? '',
            'Content-Type': 'application/json'
          });
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        return;
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future partialPayment({
    required String orderId,
    String? token,
  }) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_tera_wallet/partial_payment'),
          body: convert.jsonEncode({
            'order_id': orderId,
          }),
          headers: {
            'User-Cookie': token ?? '',
            'Content-Type': 'application/json'
          });
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        return;
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<Product?> checkRecharge({required int amount}) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_tera_wallet/check_recharge'),
          body: convert.jsonEncode({
            'amount': amount,
          }),
          headers: {'Content-Type': 'application/json'});
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw jsonDecode['message'];
      } else {
        jsonDecode['price'] = '$amount';
        return Product.fromJson(jsonDecode);
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<User> checkEmailTransfer({
    required String email,
    required String token,
  }) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_tera_wallet/check_email'),
          body: convert.jsonEncode({
            'email': email,
          }),
          headers: {
            'User-Cookie': token,
            'Content-Type': 'application/json',
          });
      final jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        return User.fromJson(jsonDecode);
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }

  @override
  Future<bool> transfer({
    required String token,
    required TransferForm transferForm,
  }) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_tera_wallet/transfer'),
          body: convert.jsonEncode(transferForm.toJson()),
          headers: {
            'User-Cookie': token,
            'Content-Type': 'application/json',
          });
      final jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map) {
        final isValid = jsonDecode['is_valid'] ?? false;
        if (isNotBlank(jsonDecode['message']) && !isValid) {
          throw jsonDecode['message'];
        } else {
          return isValid;
        }
      }
      return false;
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://docs.inspireui.com/fluxstore/woocommerce-setup/
      rethrow;
    }
  }
}
