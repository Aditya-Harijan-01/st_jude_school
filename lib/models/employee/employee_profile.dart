
class EmployeeDataResponse {
  final String statusCode;
  final List<EmployeeBasic> dataBasic;
  final List<EmployeeQualification> dataQualification;
  final List<EmployeeExperience> dataExperience;
  final List<EmployeeOffice> dataOffice;
  final List<EmployeeBank> dataBank;
  final List<EmployeeAddress> dataAddress;

  EmployeeDataResponse({
    required this.statusCode,
    required this.dataBasic,
    required this.dataQualification,
    required this.dataExperience,
    required this.dataOffice,
    required this.dataBank,
    required this.dataAddress,
  });

  factory EmployeeDataResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeDataResponse(
      statusCode: json['statusCode'] ?? '',
      dataBasic: (json['dataBasic'] as List<dynamic>)
          .map((e) => EmployeeBasic.fromJson(e))
          .toList(),
      dataQualification: (json['dataQualification'] as List<dynamic>)
          .map((e) => EmployeeQualification.fromJson(e))
          .toList(),
      dataExperience: (json['dataExperience'] as List<dynamic>)
          .map((e) => EmployeeExperience.fromJson(e))
          .toList(),
      dataOffice: (json['dataOffice'] as List<dynamic>)
          .map((e) => EmployeeOffice.fromJson(e))
          .toList(),
      dataBank: (json['dataBank'] as List<dynamic>)
          .map((e) => EmployeeBank.fromJson(e))
          .toList(),
      dataAddress: (json['dataAddress'] as List<dynamic>)
          .map((e) => EmployeeAddress.fromJson(e))
          .toList(),
    );
  }
}

class EmployeeBasic {
  final String tid;
  final String employeeName;
  final String gender;
  final String dob;
  final String birthplace;
  final String fatherName;
  final String motherName;
  final String fatherOccupation;
  final String nationality;
  final String maritalStatus;
  final String weddingDate;
  final String motherTongue;
  final String bloodGroup;
  final String aadharNo;
  final String religion;
  final String castName;
  final String phoneNo;
  final String emergencyNo;
  final String profileImage;

  EmployeeBasic({
    required this.tid,
    required this.employeeName,
    required this.gender,
    required this.dob,
    required this.birthplace,
    required this.fatherName,
    required this.motherName,
    required this.fatherOccupation,
    required this.nationality,
    required this.maritalStatus,
    required this.weddingDate,
    required this.motherTongue,
    required this.bloodGroup,
    required this.aadharNo,
    required this.religion,
    required this.castName,
    required this.phoneNo,
    required this.emergencyNo,
    required this.profileImage,
  });

  factory EmployeeBasic.fromJson(Map<String, dynamic> json) {
    return EmployeeBasic(
      tid: json['tid'] ?? '',
      employeeName: json['employee_name'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      birthplace: json['birthplace'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      fatherOccupation: json['father_occupation'] ?? '',
      nationality: json['nationality'] ?? '',
      maritalStatus: json['marital_status'] ?? '',
      weddingDate: json['wedding_date'] ?? '',
      motherTongue: json['mother_toungue'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      aadharNo: json['aadhar_no'] ?? '',
      religion: json['religion'] ?? '',
      castName: json['cast_name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      emergencyNo: json['emergency_no'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}

class EmployeeQualification {
  final String tid;
  final String examName;
  final String passYear;
  final String institute;
  final String subject;
  final String percentage;

  EmployeeQualification({
    required this.tid,
    required this.examName,
    required this.passYear,
    required this.institute,
    required this.subject,
    required this.percentage,
  });

  factory EmployeeQualification.fromJson(Map<String, dynamic> json) {
    return EmployeeQualification(
      tid: json['tid'] ?? '',
      examName: json['exam_name'] ?? '',
      passYear: json['pass_year'] ?? '',
      institute: json['institute'] ?? '',
      subject: json['subject'] ?? '',
      percentage: json['percentage'] ?? '',
    );
  }
}

class EmployeeExperience {
  final String tid;
  final String organization;
  final String fromDate;
  final String toDate;
  final String designation;

  EmployeeExperience({
    required this.tid,
    required this.organization,
    required this.fromDate,
    required this.toDate,
    required this.designation,
  });

  factory EmployeeExperience.fromJson(Map<String, dynamic> json) {
    return EmployeeExperience(
      tid: json['tid'] ?? '',
      organization: json['organization'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      designation: json['designation'] ?? '',
    );
  }
}

class EmployeeOffice {
  final String tid;
  final String noa;
  final String category;
  final String biometricCode;
  final String position;
  final String designation;
  final String joinDate;
  final String resignationDate;
  final String emailId;

  EmployeeOffice({
    required this.tid,
    required this.noa,
    required this.category,
    required this.biometricCode,
    required this.position,
    required this.designation,
    required this.joinDate,
    required this.resignationDate,
    required this.emailId,
  });

  factory EmployeeOffice.fromJson(Map<String, dynamic> json) {
    return EmployeeOffice(
      tid: json['tid'] ?? '',
      noa: json['noa'] ?? '',
      category: json['category'] ?? '',
      biometricCode: json['biometric_code'] ?? '',
      position: json['position'] ?? '',
      designation: json['designation'] ?? '',
      joinDate: json['join_date'] ?? '',
      resignationDate: json['resignation_date'] ?? '',
      emailId: json['email_id'] ?? '',
    );
  }
}

class EmployeeBank {
  final String tid;
  final String bankName;
  final String branchName;
  final String ifscCode;
  final String bankAcNo;
  final String atmFacility;
  final String nameOfAccount;

  EmployeeBank({
    required this.tid,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.bankAcNo,
    required this.atmFacility,
    required this.nameOfAccount,
  });

  factory EmployeeBank.fromJson(Map<String, dynamic> json) {
    return EmployeeBank(
      tid: json['tid'] ?? '',
      bankName: json['bank_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      bankAcNo: json['bank_ac_no'] ?? '',
      atmFacility: json['atm_facility'] ?? '',
      nameOfAccount: json['name_of_account'] ?? '',
    );
  }
}

class EmployeeAddress {
  final String tid;
  final String presentAddress;
  final String presentCity;
  final String presentState;
  final String presentCountry;
  final String presentZip;
  final String parmAddress;
  final String parmCity;
  final String parmState;
  final String parmCountry;
  final String parmZip;

  EmployeeAddress({
    required this.tid,
    required this.presentAddress,
    required this.presentCity,
    required this.presentState,
    required this.presentCountry,
    required this.presentZip,
    required this.parmAddress,
    required this.parmCity,
    required this.parmState,
    required this.parmCountry,
    required this.parmZip,
  });

  factory EmployeeAddress.fromJson(Map<String, dynamic> json) {
    return EmployeeAddress(
      tid: json['tid'] ?? '',
      presentAddress: json['present_address'] ?? '',
      presentCity: json['present_city'] ?? '',
      presentState: json['present_state'] ?? '',
      presentCountry: json['present_country'] ?? '',
      presentZip: json['present_zip'] ?? '',
      parmAddress: json['parm_address'] ?? '',
      parmCity: json['parm_city'] ?? '',
      parmState: json['parm_state'] ?? '',
      parmCountry: json['parm_country'] ?? '',
      parmZip: json['parm_zip'] ?? '',
    );
  }
}