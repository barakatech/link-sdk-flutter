import 'package:lean_sdk_flutter/lean_data_types.dart';

class LeanFunctions {
  static String connect(String appToken, String? customerId,
      List<Permission>? permissions, bool isSandbox, String bankId) {
    return ('''
          function postResponse(status) {
              status.method = "CONNECT";
              window.parent.postMessage(JSON.stringify(status), "*");
          }
          try {
            Lean.connect({
              app_token: "$appToken",
              customer_id: "$customerId",
              permissions: ["${permissions?.map((p) => p.name).join("\",\"")}"],
              sandbox: $isSandbox,
              callback: postResponse,
              bank_identifier: "$bankId"
            });
          } catch (e) {
            postResponse({ method: "CONNECT", status: "ERROR", message: "Lean not initialized" })
          }
    ''');
  }

  static String createPaymentSource(
      String appToken, String? customerId, bool isSandbox) {
    return ('''
          function postResponse(status) {
              status.method = "CREATE_PAYMENT_SOURCE"
              window.parent.postMessage(JSON.stringify(status), "*");
          }
          try {
            Lean.createPaymentSource({
              app_token: "$appToken",
              customer_id: "$customerId",
              sandbox: $isSandbox,
              callback: postResponse
            });
          } catch (e) {
            postResponse({ method: "CREATE_PAYMENT_SOURCE", status: "ERROR", message: "Lean not initialized" })
          }
    ''');
  }

  static String reconnect(
      String appToken, String? reconnectId, bool isSandbox) {
    return ('''
          function postResponse(status) {
              status.method = "RECONNECT"
              window.parent.postMessage(JSON.stringify(status), "*");
          }
          try {
            Lean.reconnect({
              app_token: "$appToken",
              reconnect_id: "$reconnectId",
              sandbox: $isSandbox,
              callback: postResponse
            });
          } catch (e) {
            postResponse({ method: "RECONNECT", status: "ERROR", message: "Lean not initialized" })
          }
    ''');
  }

  static String pay(String appToken, String? customerId, bool isSandbox,
      String? paymentIntentId) {
    return ('''
          function postResponse(status) {
              status.method = "PAY"
              window.parent.postMessage(JSON.stringify(status), "*");
          }
          try {
            Lean.pay({
              app_token: "$appToken",
              customer_id: "$customerId",
              sandbox: $isSandbox,
              payment_intent_id: "$paymentIntentId",
              callback: postResponse
            });
          } catch (e) {
            postResponse({ method: "PAY", status: "ERROR", message: "Lean not initialized" })
          }
    ''');
  }
}
