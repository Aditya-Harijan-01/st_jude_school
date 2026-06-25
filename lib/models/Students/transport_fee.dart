

class TransportFeeResponse {
  final String statusCode;
  final List<TransportQuarterFeeModel> data;

  TransportFeeResponse({
    required this.statusCode,
    required this.data,
  });

  factory TransportFeeResponse.fromJson(Map<String, dynamic> json) {
    return TransportFeeResponse(
      statusCode: json['statusCode'],
      data: (json['data'] as List<dynamic>)
          .map((e) => TransportQuarterFeeModel.fromJson(e))
          .toList(),
    );
  }
}

class TransportQuarterFeeModel {
  final String feegroupId;
  final String feeheadId;
  final String feeHeadName;
  final String quarterId;
  final String checkInitial;
  final String amount;
  final String concession;
  final String payableAmount;
  final String paymentStatus;
  final String rcvno;
  final String isPaid;

  TransportQuarterFeeModel({
    required this.feegroupId,
    required this.feeheadId,
    required this.feeHeadName,
    required this.quarterId,
    required this.checkInitial,
    required this.amount,
    required this.concession,
    required this.payableAmount,
    required this.paymentStatus,
    required this.rcvno,
    required this.isPaid,
  });

  factory TransportQuarterFeeModel.fromJson(Map<String, dynamic> json) {
    return TransportQuarterFeeModel(
      feegroupId: json['feegroup_id'] ?? '',
      feeheadId: json['feeheadid'] ?? '',
      feeHeadName: json['fee_head_name'] ?? '',
      quarterId: json['quarter_id'] ?? '',
      checkInitial: json['check_initial'] ?? '',
      amount: json['amount'] ?? '',
      concession: json['concession'] ?? '',
      payableAmount: json['payable_amount'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      rcvno: json['rcvno'] ?? '',
      isPaid: json['is_paid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feegroup_id': feegroupId,
      'feeheadid': feeheadId,
      'fee_head_name': feeHeadName,
      'quarter_id': quarterId,
      'check_initial': checkInitial,
      'amount': amount,
      'concession': concession,
      'payable_amount': payableAmount,
      'payment_status': paymentStatus,
      'rcvno': rcvno,
      'is_paid': isPaid,
    };
  }
}
