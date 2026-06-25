class TransportPaymentResponseExist {
  final String statusCode;
  final List<TransportPaymentData> data;

  TransportPaymentResponseExist({
    required this.statusCode,
    required this.data,
  });

  factory TransportPaymentResponseExist.fromJson(Map<String, dynamic> json) {
    return TransportPaymentResponseExist(
      statusCode: json['statusCode'],
      data: (json['data'] as List)
          .map((item) => TransportPaymentData.fromJson(item))
          .toList(),
    );
  }
}

class TransportPaymentData {
  final String regNo;
  final String fromYear;
  final String toYear;
  final String rcpShowNo;
  final String rcpNo;
  final String displaySlNo;
  final String rcpType;
  final String paymentDate;
  final String paidAmount;
  final String flag;

  TransportPaymentData({
    required this.regNo,
    required this.fromYear,
    required this.toYear,
    required this.rcpShowNo,
    required this.rcpNo,
    required this.displaySlNo,
    required this.rcpType,
    required this.paymentDate,
    required this.paidAmount,
    required this.flag,
  });

  factory TransportPaymentData.fromJson(Map<String, dynamic> json) {
    return TransportPaymentData(
      regNo: json['regno'],
      fromYear: json['fromyear'],
      toYear: json['toyear'],
      rcpShowNo: json['rcpshowno'],
      rcpNo: json['rcpno'],
      displaySlNo: json['display_slno'],
      rcpType: json['rcptype'],
      paymentDate: json['payment_date'],
      paidAmount: json['paid_amount'],
      flag: json['flag'],
    );
  }
}
