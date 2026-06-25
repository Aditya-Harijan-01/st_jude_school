class HostelFeeStructureResponse {
  final String statusCode;
  final String? message;
  final List<HostelFeeHead> data;

  HostelFeeStructureResponse({
    required this.statusCode,
    this.message,
    required this.data,
  });

  factory HostelFeeStructureResponse.fromJson(Map<String, dynamic> json) {
    return HostelFeeStructureResponse(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => HostelFeeHead.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HostelFeeHead {
  final String feeGroupId;
  final String feeHeadId;
  final String feeHeadName;
  final String quarterId;
  final String checkInitial;
  final String amount;
  final String concession;
  final String payableAmount;
  final String paymentStatus;
  final String rcvNo;
  final String isPaid;
  final String paidDate;

  HostelFeeHead({
    required this.feeGroupId,
    required this.feeHeadId,
    required this.feeHeadName,
    required this.quarterId,
    required this.checkInitial,
    required this.amount,
    required this.concession,
    required this.payableAmount,
    required this.paymentStatus,
    required this.rcvNo,
    required this.isPaid,
    required this.paidDate,
  });

  factory HostelFeeHead.fromJson(Map<String, dynamic> json) {
    return HostelFeeHead(
      feeGroupId: json['feegroup_id'] ?? '',
      feeHeadId: json['feeheadid'] ?? '',
      feeHeadName: json['fee_head_name'] ?? '',
      quarterId: json['quarter_id'] ?? '',
      checkInitial: json['check_initial'] ?? '',
      amount: json['amount'] ?? '',
      concession: json['concession'] ?? '',
      payableAmount: json['payable_amount'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      rcvNo: json['rcvno'] ?? '',
      isPaid: json['is_paid'] ?? '',
      paidDate: json['paidDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feegroup_id': feeGroupId,
      'feeheadid': feeHeadId,
      'fee_head_name': feeHeadName,
      'quarter_id': quarterId,
      'check_initial': checkInitial,
      'amount': amount,
      'concession': concession,
      'payable_amount': payableAmount,
      'payment_status': paymentStatus,
      'rcvno': rcvNo,
      'is_paid': isPaid,
      'paidDate': paidDate,
    };
  }
}
