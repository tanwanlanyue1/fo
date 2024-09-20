import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talk_fo_me/common/network/api/api.dart';
import 'package:talk_fo_me/common/payment/model/payment_enum.dart';
import 'package:talk_fo_me/common/payment/model/trade_order.dart';

import '../payment_interface.dart';
import 'alipay_app_payment.dart';

///支付宝 - 汇付
class AlipayWithHuiFu extends AlipayAppPayment {
  AlipayWithHuiFu() : super(PaymentPlatform.huifu);
}
