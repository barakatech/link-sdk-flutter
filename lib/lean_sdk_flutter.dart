import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lean_sdk_flutter/lean_data_types.dart';
import 'package:lean_sdk_flutter/lean_functions.dart';

class Lean extends StatefulWidget {
  final String appToken;
  final String? customerId;
  final String? reconnectId;
  final String? paymentIntentId;
  final List<Permission>? permissions;
  final String bankId;
  final String version;
  final bool isSandbox;
  final Country country;
  final LeanCallback? callback;
  final LeanActionCancelled? actionCancelled;
  final LeanActionType _actionType;

  const Lean.connect(
      {super.key,
      required this.appToken,
      required this.customerId,
      required this.permissions,
      this.version = 'latest',
      this.isSandbox = true,
      this.country = Country.uae,
      this.callback,
      this.bankId = '',
      this.actionCancelled})
      : _actionType = LeanActionType.connect,
        paymentIntentId = null,
        reconnectId = null;

  const Lean.createPaymentSource(
      {super.key,
      required this.appToken,
      required this.customerId,
      this.version = 'latest',
      this.isSandbox = true,
      this.country = Country.uae,
      this.callback,
      this.bankId = '',
      this.actionCancelled})
      : _actionType = LeanActionType.createPaymentSource,
        reconnectId = null,
        paymentIntentId = null,
        permissions = null;

  const Lean.reconnect(
      {super.key,
      required this.appToken,
      required this.reconnectId,
      this.version = 'latest',
      this.isSandbox = true,
      this.country = Country.uae,
      this.callback,
      this.bankId = '',
      this.actionCancelled})
      : _actionType = LeanActionType.reconnect,
        customerId = null,
        paymentIntentId = null,
        permissions = null;

  const Lean.pay(
      {super.key,
      required this.appToken,
      required this.paymentIntentId,
      this.version = 'latest',
      this.isSandbox = true,
      this.country = Country.uae,
      this.callback,
      this.bankId = '',
      this.actionCancelled})
      : _actionType = LeanActionType.pay,
        customerId = null,
        reconnectId = null,
        permissions = null;

  @override
  _LeanState createState() => _LeanState();
}

class _LeanState extends State<Lean> {
  late final _listener = _callback;

  @override
  void initState() {
    super.initState();
    html.window.addEventListener("message", _listener);
  }

  @override
  void dispose() {
    html.window.removeEventListener("message", _listener);
    super.dispose();
  }

  dynamic _callback(html.Event event) {
    if (widget.callback != null) {
      try {
        // Return 'LeanResponse' if success
        final message = event.toDart as html.MessageEvent;
        final leanResponse = LeanResponse.fromJson(json.decode(message.data));
        widget.callback!(leanResponse);
      } catch (e) {
        // Return null if failed
        widget.callback!(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        sharedCookiesEnabled: true,
        thirdPartyCookiesEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      initialUrlRequest: URLRequest(
        url: WebUri('/lean.html'),
      ),
      onLoadStop: (controller, _) async {
        final function = _getJSFunction(widget._actionType);
        await controller.evaluateJavascript(
          source: function,
        );
      },
    );
  }

  String _getJSFunction(LeanActionType action) {
    switch (action) {
      case LeanActionType.connect:
        return LeanFunctions.connect(
          widget.appToken,
          widget.customerId,
          widget.permissions,
          widget.isSandbox,
          widget.bankId,
        );
      case LeanActionType.reconnect:
        return LeanFunctions.reconnect(
          widget.appToken,
          widget.customerId,
          widget.isSandbox,
        );
      case LeanActionType.createPaymentSource:
        return LeanFunctions.createPaymentSource(
          widget.appToken,
          widget.customerId,
          widget.isSandbox,
        );
      case LeanActionType.pay:
        return LeanFunctions.pay(
          widget.appToken,
          widget.customerId,
          widget.isSandbox,
        );
    }
  }
}
