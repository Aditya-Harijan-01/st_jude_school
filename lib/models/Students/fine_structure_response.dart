
class FineResponseModel {
  final String statusCode;
  final List<FineData> unpaidData;
  final List<FinePaidData> paidData;

  FineResponseModel({
    required this.statusCode,
    required this.unpaidData,
    required this.paidData,
  });

  factory FineResponseModel.fromJson(Map<String, dynamic> json) {
    return FineResponseModel(
      statusCode: json['statusCode'] ?? '',
      unpaidData: (json['unpaidData'] as List<dynamic>?)
          ?.map((item) => FineData.fromJson(item))
          .toList() ?? [],
      paidData: (json['paidData'] as List<dynamic>?)
          ?.map((item) => FinePaidData.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'unpaidData': unpaidData.map((item) => item.toJson()).toList(),
      'paidData': paidData.map((item) => item.toJson()).toList(),
    };
  }
}
class FinePaidData{
  final String sid;
  final String rcpno;
  final String rcpnoshow;
  final String receivedAmount;
  final String paymentDate;
  final String transtype;
  final String transno;
  final String bank;
  final String fineMasterName;
  final String typeId;
  final String typeName;

  FinePaidData({
    required this.sid,
    required this.rcpno,
    required this.rcpnoshow,
    required this.receivedAmount,
    required this.paymentDate,
    required this.transtype,
    required this.transno,
    required this.bank,
    required this.fineMasterName,
    required this.typeId,
    required this.typeName,
});

  factory FinePaidData.fromJson(Map<String, dynamic> json) {
    return FinePaidData(
      sid: json['sid'],
      rcpno: json['rcpno'],
      rcpnoshow: json['rcpnoshow'],
      receivedAmount: json['received_amount'],
      paymentDate: json['payment_date'],
      transtype: json['transtype'],
      transno: json['transno'],
      bank: json['bank'],
      fineMasterName: json['fine_master_name'],
      typeId: json['type_id'],
      typeName: json['type_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sid': sid,
      'rcpno': rcpno,
      'rcpnoshow': rcpnoshow,
      'received_amount': receivedAmount,
      'payment_date': paymentDate,
      'transtype': transtype,
      'transno': transno,
      'bank': bank,
      'fine_master_name': fineMasterName,
      'type_id': typeId,
      'type_name': typeName,
    };
  }
}
class FineData {
  final String fineMasterId;
  final String fineMasterName;
  final String typeId;
  final String typeName;
  final String amount;
  final String fineId;
  final String fineDate;
  final String fineStatus;
  final String receiptNo;
  final String remarks;
  final String regno;

  FineData({
    required this.fineMasterId,
    required this.fineMasterName,
    required this.typeId,
    required this.typeName,
    required this.amount,
    required this.fineId,
    required this.fineDate,
    required this.fineStatus,
    required this.receiptNo,
    required this.remarks,
    required this.regno,
  });

  factory FineData.fromJson(Map<String, dynamic> json) {
    return FineData(
      fineMasterId: json['fine_master_id']?.toString() ?? '',
      fineMasterName: json['fine_master_name']?.toString() ?? '',
      typeId: json['type_id']?.toString() ?? '',
      typeName: json['type_name']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      fineId: json['fine_id']?.toString() ?? '',
      fineDate: json['fine_date']?.toString() ?? '',
      fineStatus: json['fine_status']?.toString() ?? '',
      receiptNo: json['receipt_no']?.toString() ?? '',
      remarks: json['remarks']?.toString() ?? '',
      regno: json['regno']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fine_master_id': fineMasterId,
      'fine_master_name': fineMasterName,
      'type_id': typeId,
      'type_name': typeName,
      'amount': amount,
      'fine_id': fineId,
      'fine_date': fineDate,
      'fine_status': fineStatus,
      'receipt_no': receiptNo,
      'remarks': remarks,
      'regno': regno,
    };
  }


}

