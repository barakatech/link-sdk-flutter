class LeanResponse {
  final String status;
  final String method;
  final String? exitPoint;

  LeanResponse(this.status, this.method, this.exitPoint);

  LeanResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        method = json['method'],
        exitPoint = json['exit_point'];
}

typedef LeanCallback = void Function(LeanResponse? response);
typedef LeanActionError = void Function(String errorMessage);
typedef LeanActionCancelled = void Function();

enum Country { uae, ksa }

enum Permission { identity, transactions, balance, accounts, payments }

enum LeanActionType { connect, createPaymentSource, reconnect, pay }
