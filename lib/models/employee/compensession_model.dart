class CompensationModel {
  final String monthId;
  final String monthName;
  final String salaryDate;
  final double grossSalary;
  final double netSalary;
  final double deduction;

  CompensationModel({
    required this.monthId,
    required this.monthName,
    required this.salaryDate,
    required this.grossSalary,
    required this.netSalary,
    required this.deduction,
  });

  String get monthYear => monthName;

  // Factory constructor to create from API response
  factory CompensationModel.fromJson(Map<String, dynamic> json) {
    return CompensationModel(
      monthId: json['month_id'] ?? '',
      monthName: json['month_name'] ?? '',
      salaryDate: json['salary_date'] ?? '',
      grossSalary: double.tryParse(json['gross_salary'].toString()) ?? 0.0,
      netSalary: double.tryParse(json['net_salary'].toString()) ?? 0.0,
      deduction: double.tryParse(json['deduction'].toString()) ?? 0.0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'month_id': monthId,
      'month_name': monthName,
      'salary_date': salaryDate,
      'gross_salary': grossSalary.toString(),
      'net_salary': netSalary.toString(),
      'deduction': deduction.toString(),
    };
  }
}