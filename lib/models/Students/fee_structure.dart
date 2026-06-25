class FeeStructureResponse {
  final String statusCode;
  final String feeMode;
  final List<FeeMainData> dataMain;
  final List<FeeInstallmentData> dataInstallment;

  FeeStructureResponse({
    required this.statusCode,
    required this.feeMode,
    required this.dataMain,
    required this.dataInstallment,
  });

  factory FeeStructureResponse.fromJson(Map<String, dynamic> json) {
    return FeeStructureResponse(
      statusCode: json['statusCode'] ?? '',
      feeMode: json['feeMode'] ?? '',
      dataMain: (json['dataMain'] as List<dynamic>? ?? [])
          .map((e) => FeeMainData.fromJson(e))
          .toList(),
      dataInstallment: (json['dataInstallment'] as List<dynamic>? ?? [])
          .map((e) => FeeInstallmentData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'feeMode': feeMode,
    'dataMain': dataMain.map((e) => e.toJson()).toList(),
    'dataInstallment': dataInstallment.map((e) => e.toJson()).toList(),
  };
}

class FeeMainData {
  final String sid;
  final String regno;
  final String structure;
  final String feeApplicable;
  final String discountAmount;
  final String feeTypeId;
  final String feesType;
  final String paidOn;
  final String rcpNo;
  final String rcpId;
  final String receivedAmount;
  final String concession;
  final String feePayable;
  final String latefineAmount;
  final String? latefineHead;
  final String checkBounceAmount;

  FeeMainData({
    required this.sid,
    required this.regno,
    required this.structure,
    required this.feeApplicable,
    required this.discountAmount,
    required this.feeTypeId,
    required this.feesType,
    required this.paidOn,
    required this.rcpNo,
    required this.rcpId,
    required this.receivedAmount,
    required this.concession,
    required this.feePayable,
    required this.latefineAmount,
    this.latefineHead,
    required this.checkBounceAmount,
  });

  factory FeeMainData.fromJson(Map<String, dynamic> json) {
    return FeeMainData(
      sid: json['sid'] ?? '',
      regno: json['regno'] ?? '',
      structure: json['structure'] ?? '',
      feeApplicable: json['fee_applicable'] ?? '',
      discountAmount: json['discount_amount'] ?? '',
      feeTypeId: json['fee_type_id'] ?? '',
      feesType: json['fees_type'] ?? '',
      paidOn: json['paid_on'] ?? '',
      rcpNo: json['rcp_no'] ?? '',
      rcpId: json['rcp_id'] ?? '',
      receivedAmount: json['received_amount'] ?? '',
      concession: json['concession'] ?? '',
      feePayable: json['fee_payable'] ?? '',
      latefineAmount: json['latefine_amount']?.toString() ?? '0',
      latefineHead: json['latefine_head']?.toString(),
      checkBounceAmount: json['check_bounce_amount']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
    'sid': sid,
    'regno': regno,
    'structure': structure,
    'fee_applicable': feeApplicable,
    'discount_amount': discountAmount,
    'fee_type_id': feeTypeId,
    'fees_type': feesType,
    'paid_on': paidOn,
    'rcp_no': rcpNo,
    'rcp_id': rcpId,
    'received_amount': receivedAmount,
    'concession': concession,
    'fee_payable': feePayable,
    'latefine_amount': latefineAmount,
    'latefine_head': latefineHead,
    'check_bounce_amount': checkBounceAmount,
  };
}

class FeeInstallmentData {
  final String sid;
  final String regno;
  final String feeGroupId;
  final String groupName;
  final String amount;
  final String concession;
  final String feeApplicable;
  final String lastDate;
  final String paidOn;
  final String paidAmount;
  final String rcpNo;
  final String feetype;
  final String rcpId;
  final String headids;
  final String paymentStatus;
  final String feeTypeId;
  final String email;
  final String latefineAmount;
  final String? latefineHead;
  final String? checkBounceAmount;

  FeeInstallmentData({
    required this.sid,
    required this.regno,
    required this.feeGroupId,
    required this.groupName,
    required this.amount,
    required this.concession,
    required this.feeApplicable,
    required this.lastDate,
    required this.paidOn,
    required this.paidAmount,
    required this.rcpNo,
    required this.feetype,
    required this.rcpId,
    required this.headids,
    required this.paymentStatus,
    required this.feeTypeId,
    required this.email,
    required this.latefineAmount,
    this.latefineHead,
    this.checkBounceAmount,
  });

  factory FeeInstallmentData.fromJson(Map<String, dynamic> json) {
    return FeeInstallmentData(
      sid: json['sid'] ?? '',
      regno: json['regno'] ?? '',
      feeGroupId: json['fee_group_id'] ?? '',
      groupName: json['group_name'] ?? '',
      amount: json['amount'] ?? '',
      concession: json['concession'] ?? '',
      feeApplicable: json['fee_applicable'] ?? '',
      lastDate: json['last_date'] ?? '',
      paidOn: json['paid_on'] ?? '',
      paidAmount: json['paid_amount'] ?? '',
      rcpNo: json['rcp_no'] ?? '',
      rcpId: json['rcp_id'] ?? '',
      headids: json['headids'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      feeTypeId: json['fee_type_id'] ?? '',
      email: json['email'] ?? '', feetype: json['fee_Type'],
      latefineAmount: json['latefine_amount']?.toString() ?? '0',
      latefineHead: json['latefine_head']?.toString(),
      checkBounceAmount: json['check_bounce_amount']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'sid': sid,
    'regno': regno,
    'fee_group_id': feeGroupId,
    'group_name': groupName,
    'amount': amount,
    'concession': concession,
    'fee_applicable': feeApplicable,
    'last_date': lastDate,
    'paid_on': paidOn,
    'paid_amount': paidAmount,
    'rcp_no': rcpNo,
    'rcp_id': rcpId,
    'headids': headids,
    'payment_status': paymentStatus,
    'fee_type_id': feeTypeId,
    'email': email,
    'latefine_amount': latefineAmount,
    'latefine_head': latefineHead,
    'check_bounce_amount': checkBounceAmount,
  };
}