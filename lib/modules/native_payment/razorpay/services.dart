import 'package:quiver/strings.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

mixin RazorDelegate {
  void handlePaymentSuccess(PaymentSuccessResponse response) {}

  void handlePaymentFailure(PaymentFailureResponse response) {}
}

class RazorUserInfo {
  final String? fullName;
  final String? phone;
  final String? email;

  RazorUserInfo({
    required this.fullName,
    required this.phone,
    required this.email,
  });
}

class RazorServices {
  final razorPay = Razorpay();
  final RazorDelegate delegate;

  final String amount;
  final RazorUserInfo userInfo;
  final String keyId;
  final String? orderId;

  RazorServices({
    required this.amount,
    required this.userInfo,
    required this.delegate,
    required this.keyId,
    this.orderId,
  }) {
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, delegate.handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, delegate.handlePaymentFailure);
  }

  String _formatRazorPrice(String price) {
    if (isNotBlank(price)) {
      final p = double.parse(price) * 100;
      return p.toString();
    } else {
      return '0';
    }
  }

  void openPayment(String currency) {
    var options = {
      'key': keyId,
      'amount': _formatRazorPrice(amount),
      'name': userInfo.fullName,
      'currency': currency,
      'order_id': orderId,
      'prefill': {
        'contact': userInfo.phone,
        'email': userInfo.email,
      },
    };
    razorPay.open(options);
  }
}
