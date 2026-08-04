

// ─── RAZORPAY SERVICE ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;
  Function(ExternalWalletResponse)? onExternalWallet;

  void initializeRazorpay({
    Function(PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onFailure,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    this.onSuccess = onSuccess;
    this.onFailure = onFailure;
    this.onExternalWallet = onExternalWallet;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) =>
      onSuccess?.call(response);
  void _handlePaymentError(PaymentFailureResponse response) =>
      onFailure?.call(response);
  void _handleExternalWallet(ExternalWalletResponse response) =>
      onExternalWallet?.call(response);

  void openCheckout({
    required String amount,
    required String name,
    required String description,
    String prefillEmail = '',
    String prefillContact = '',
    Map<String, dynamic>? notes,
  }) {
    var options = {
      'key': 'rzp_test_Sdk7s0855ruSfa',
      'amount': amount,
      'name': name,
      'description': description,
      'prefill': {'contact': prefillContact, 'email': prefillEmail},
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay']
      },
      'notes': notes ?? {},
      'theme': {'color': '#00E5FF', 'hide_topbar': false},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  void dispose() => _razorpay.clear();
}
