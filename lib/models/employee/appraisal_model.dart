class AppraisalData {
  final String statusCode;
  final int userAccessValue;
  final List<YearlyAppraisal> data;

  AppraisalData({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory AppraisalData.fromJson(Map<String, dynamic> json) {
    return AppraisalData(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => YearlyAppraisal.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class YearlyAppraisal {
  final String fromYear;
  final List<PointDetail> pointDetails;

  YearlyAppraisal({
    required this.fromYear,
    required this.pointDetails,
  });

  factory YearlyAppraisal.fromJson(Map<String, dynamic> json) {
    return YearlyAppraisal(
      fromYear: json['fromyear'] ?? '',
      pointDetails: (json['point_details'] as List?)
          ?.map((item) => PointDetail.fromJson(item))
          .toList() ??
          [],
    );
  }

  // Calculate total points from all categories
  double get totalPoints {
    final totalDetail = pointDetails.firstWhere(
          (detail) => detail.isTotalRow == 'Yes',
      orElse: () => PointDetail(
        appraisalHeadName: '',
        weightage: '',
        point: '0',
        isTotalRow: 'No',
        isDomain: 'No',
      ),
    );
    return double.tryParse(totalDetail.point) ?? 0.0;
  }

  List<PointDetail> get mainCategories {
    return pointDetails
        .where((detail) =>
    detail.isDomain == 'No' &&
        detail.isTotalRow == 'No')
        .toList();
  }

  List<PointDetail> get domainCategories {
    return pointDetails
        .where((detail) => detail.isDomain == 'Yes' && detail.isTotalRow == 'No')
        .toList();
  }
}

class PointDetail {
  final String appraisalHeadName;
  final String weightage;
  final String point;
  final String isTotalRow;
  final String isDomain;

  PointDetail({
    required this.appraisalHeadName,
    required this.weightage,
    required this.point,
    required this.isTotalRow,
    required this.isDomain,
  });

  factory PointDetail.fromJson(Map<String, dynamic> json) {
    return PointDetail(
      appraisalHeadName: json['appraisal_head_name'] ?? '',
      weightage: json['weightage'] ?? '',
      point: json['point'] ?? '-',
      isTotalRow: json['is_total_row'] ?? 'No',
      isDomain: json['is_domain'] ?? 'No',
    );
  }

  double get pointValue => double.tryParse(point) ?? 0.0;
  double get weightageValue => double.tryParse(weightage) ?? 0.0;
}