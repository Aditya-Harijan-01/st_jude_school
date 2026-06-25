import 'dart:convert';

class StudentProfileResponse {
  final String? responseString;
  final int? responseValue;
  final String? responseSuid;
  final String? responseString2;
  final String? responseString3;
  final dynamic responseResult;
  final dynamic responseResult2;
  final ResponseObject? responseObject;
  final int? responseSubmit;
  final dynamic responseObject2;
  final dynamic responseObject3;
  final dynamic responseObject4;
  final dynamic responseObject5;

  StudentProfileResponse({
    this.responseString,
    this.responseValue,
    this.responseSuid,
    this.responseString2,
    this.responseString3,
    this.responseResult,
    this.responseResult2,
    this.responseObject,
    this.responseSubmit,
    this.responseObject2,
    this.responseObject3,
    this.responseObject4,
    this.responseObject5,
  });

  factory StudentProfileResponse.fromJson(Map<String, dynamic> json) {
    final decodedObject = _decodeResponseObject(json['responseObject']);

    return StudentProfileResponse(
      responseString: _asString(json['responseString']),
      responseValue: _asInt(json['responseValue']),
      responseSuid: _asString(json['responseSuid']),
      responseString2: _asString(json['responseString2']),
      responseString3: _asString(json['responseString3']),
      responseResult: json['responseResult'],
      responseResult2: json['responseResult2'],
      responseObject: decodedObject != null
          ? ResponseObject.fromJson(decodedObject)
          : null,
      responseSubmit: _asInt(json['responseSubmit']),
      responseObject2: json['responseObject2'],
      responseObject3: json['responseObject3'],
      responseObject4: json['responseObject4'],
      responseObject5: json['responseObject5'],
    );
  }

  static Map<String, dynamic>? _decodeResponseObject(dynamic objectData) {
    if (objectData == null) return null;

    if (objectData is Map<String, dynamic>) {
      return objectData;
    }

    if (objectData is Map) {
      return Map<String, dynamic>.from(objectData);
    }

    if (objectData is String) {
      final trimmed = objectData.trim();
      if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
        return null;
      }

      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() => {
    'responseString': responseString,
    'responseValue': responseValue,
    'responseSuid': responseSuid,
    'responseString2': responseString2,
    'responseString3': responseString3,
    'responseResult': responseResult,
    'responseResult2': responseResult2,
    'responseObject': responseObject?.toJson(),
    'responseSubmit': responseSubmit,
    'responseObject2': responseObject2,
    'responseObject3': responseObject3,
    'responseObject4': responseObject4,
    'responseObject5': responseObject5,
  };
}

class ResponseObject {
  final List<RegistrationDetails>? registrationDetails;
  final List<AdmissionDetails>? admissionDetails;
  final List<ParentDetails>? parentDetails;
  final List<AcademicDetails>? academicDetails;
  final List<ReadmissionDetails>? readmissionDetails;

  ResponseObject({
    this.registrationDetails,
    this.admissionDetails,
    this.parentDetails,
    this.academicDetails,
    this.readmissionDetails,
  });

  factory ResponseObject.fromJson(Map<String, dynamic> json) {
    return ResponseObject(
      registrationDetails: _parseList(
        json['RegistrationDetails'],
        RegistrationDetails.fromJson,
      ),
      admissionDetails: _parseList(
        json['AdmissionDetails'],
        AdmissionDetails.fromJson,
      ),
      parentDetails: _parseList(json['ParentDetails'], ParentDetails.fromJson),
      academicDetails: _parseList(
        json['AcademicDetails'],
        AcademicDetails.fromJson,
      ),
      readmissionDetails: _parseList(
        json['ReadmissionDetails'],
        ReadmissionDetails.fromJson,
      ),
    );
  }

  static List<T>? _parseList<T>(
    dynamic rawList,
    T Function(Map<String, dynamic> json) parser,
  ) {
    if (rawList is! List) return null;

    return rawList
        .whereType<Map>()
        .map((item) => parser(Map<String, dynamic>.from(item)))
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'RegistrationDetails': registrationDetails?.map((e) => e.toJson()).toList(),
    'AdmissionDetails': admissionDetails?.map((e) => e.toJson()).toList(),
    'ParentDetails': parentDetails?.map((e) => e.toJson()).toList(),
    'AcademicDetails': academicDetails?.map((e) => e.toJson()).toList(),
    'ReadmissionDetails': readmissionDetails?.map((e) => e.toJson()).toList(),
  };
}

class RegistrationDetails {
  final int? sid;
  final String? regno;
  final String? doa;
  final String? fname;
  final String? gender;
  final String? dob;
  final String? email;
  final String? tribe;
  final String? religion;
  final String? bloodgroup;
  final String? motherTongue;
  final String? phone;
  final String? prVill;
  final String? imgByte;
  final String? prCity;
  final String? prPin;
  final String? guardPhone;
  final String? prState;
  final String? prDistrict;
  final String? housename;
  final String? nationality;

  RegistrationDetails({
    this.sid,
    this.regno,
    this.doa,
    this.fname,
    this.gender,
    this.dob,
    this.email,
    this.tribe,
    this.religion,
    this.bloodgroup,
    this.motherTongue,
    this.phone,
    this.prVill,
    this.imgByte,
    this.prCity,
    this.prPin,
    this.guardPhone,
    this.prState,
    this.prDistrict,
    this.housename,
    this.nationality,
  });

  factory RegistrationDetails.fromJson(Map<String, dynamic> json) =>
      RegistrationDetails(
        sid: _asInt(json['sid']),
        regno: _asString(json['regno']),
        doa: _asString(json['doa']),
        fname: _asString(json['fname']),
        gender: _asString(json['Gender'] ?? json['gender']),
        dob: _asString(json['dob']),
        email: _asString(json['Email'] ?? json['email']),
        tribe: _asString(json['tribe']),
        religion: _asString(json['religion']),
        bloodgroup: _asString(json['bloodgroup']),
        motherTongue: _asString(json['MotherTounge'] ?? json['motherTongue']),
        phone: _asString(json['phone']),
        prVill: _asString(json['prVill']),
        imgByte: _asString(json['imgByte']),
        prCity: _asString(json['prCity']),
        prPin: _asString(json['PrPin'] ?? json['prPin']),
        guardPhone: _asString(json['GuardPhone'] ?? json['guardPhone']),
        prState: _asString(json['prState']),
        prDistrict: _asString(json['prDistrict']),
        housename: _asString(json['housename']),
        nationality: _asString(json['nationality']),
      );

  Map<String, dynamic> toJson() => {
    'sid': sid,
    'regno': regno,
    'doa': doa,
    'fname': fname,
    'Gender': gender,
    'dob': dob,
    'Email': email,
    'tribe': tribe,
    'religion': religion,
    'bloodgroup': bloodgroup,
    'MotherTounge': motherTongue,
    'phone': phone,
    'prVill': prVill,
    'imgByte': imgByte,
    'prCity': prCity,
    'PrPin': prPin,
    'GuardPhone': guardPhone,
    'prState': prState,
    'prDistrict': prDistrict,
    'housename': housename,
    'nationality': nationality,
  };
}

class AdmissionDetails {
  final String? stream;
  final String? className;
  final String? section;
  final String? rollNo;
  final int? fromYear;
  final int? toYear;
  final int? studentType;
  final String? status;

  AdmissionDetails({
    this.stream,
    this.className,
    this.section,
    this.rollNo,
    this.fromYear,
    this.status,
    this.studentType,
    this.toYear,
  });

  factory AdmissionDetails.fromJson(Map<String, dynamic> json) =>
      AdmissionDetails(
        stream: _asString(json['stream']),
        className: _asString(json['class'] ?? json['ClassName']),
        section: _asString(json['Section']),
        rollNo: _asString(json['RollNo']),
        fromYear: _asInt(json['Yearfrom']),
        toYear: _asInt(json['YearTo']),
        studentType: _asInt(json['StudentType']),
        status: _asString(json['Status']),
      );

  Map<String, dynamic> toJson() => {
    'class': className,
    'stream': stream,
    'Section': section,
    'RollNo': rollNo,
    'Yearfrom': fromYear,
    'YearTo': toYear,
    'StudentType': studentType,
    'Status': status,
  };
}

class ParentDetails {
  final String? fatherName;
  final String? fatherPhone;
  final String? fatherEducation;
  final String? fatherOccupation;
  final String? fatherAddress;
  final String? fatherOffice;
  final String? fatherImage;
  final String? motherName;
  final String? motherEducation;
  final String? motherPhone;
  final String? motherOccupation;
  final String? motherOffice;
  final String? motherImage;
  final String? fatherIncome;
  final String? motherAddress;
  final String? motherIncome;

  ParentDetails({
    this.fatherName,
    this.fatherPhone,
    this.fatherEducation,
    this.fatherOccupation,
    this.fatherAddress,
    this.motherName,
    this.motherEducation,
    this.motherPhone,
    this.motherOccupation,
    this.motherIncome,
    this.fatherIncome,
    this.motherAddress,
    this.fatherOffice,
    this.fatherImage,
    this.motherOffice,
    this.motherImage,
  });

  factory ParentDetails.fromJson(Map<String, dynamic> json) => ParentDetails(
    fatherName: _asString(json['father']),
    fatherPhone: _asString(json['father_phone']),
    fatherOccupation: _asString(json['father_occupation']),
    motherName: _asString(json['mother']),
    motherPhone: _asString(json['mother_phone']),
    motherOccupation: _asString(json['mother_occupation']),
    fatherIncome: _asString(json['father_income']),
    motherAddress: _asString(json['mother_address']),
    motherIncome: _asString(json['mother_income']),
    fatherAddress: _asString(json['father_address']),
    fatherEducation: _asString(json['father_edu']),
    fatherImage: _asString(json['FatherImage']),
    fatherOffice: _asString(json['father_office']),
    motherEducation: _asString(json['mother_edu']),
    motherImage: _asString(json['MotherImage']),
    motherOffice: _asString(json['mother_office']),
  );

  Map<String, dynamic> toJson() => {
    'father': fatherName,
    'father_phone': fatherPhone,
    'father_occupation': fatherOccupation,
    'mother': motherName,
    'mother_phone': motherPhone,
    'mother_occupation': motherOccupation,
    'father_income': fatherIncome,
    'mother_address': motherAddress,
    'mother_income': motherIncome,
    'father_address': fatherAddress,
    'father_edu': fatherEducation,
    'FatherImage': fatherImage,
    'father_office': fatherOffice,
    'mother_edu': motherEducation,
    'MotherImage': motherImage,
    'mother_office': motherOffice,
  };
}

class AcademicDetails {
  final String? regNo;
  final int? sId;
  final String? className;
  final String? stream;
  final String? section;
  final String? rollNo;
  final int? fromYear;
  final int? toYear;
  final int? studentType;

  AcademicDetails({
    this.regNo,
    this.sId,
    this.className,
    this.stream,
    this.section,
    this.rollNo,
    this.fromYear,
    this.toYear,
    this.studentType,
  });

  factory AcademicDetails.fromJson(Map<String, dynamic> json) =>
      AcademicDetails(
        regNo: _asString(json['regNo']),
        sId: _asInt(json['sid']),
        className: _asString(json['class'] ?? json['ClassName']),
        stream: _asString(json['stream']),
        section: _asString(json['Section']),
        rollNo: _asString(json['RollNo']),
        fromYear: _asInt(json['Yearfrom']),
        toYear: _asInt(json['YearTo']),
        studentType: _asInt(json['StudentType']),
      );

  Map<String, dynamic> toJson() => {
    'regNo': regNo,
    'sid': sId,
    'class': className,
    'stream': stream,
    'Section': section,
    'RollNo': rollNo,
    'Yearfrom': fromYear,
    'YearTo': toYear,
    'StudentType': studentType,
  };
}

class ReadmissionDetails {
  final int? fromYear;
  final int? toYear;
  final int? sid;
  final int? isReadmission;
  final String? feeHead;
  final String? uname;

  ReadmissionDetails({
    this.fromYear,
    this.toYear,
    this.sid,
    this.isReadmission,
    this.feeHead,
    this.uname,
  });

  factory ReadmissionDetails.fromJson(Map<String, dynamic> json) =>
      ReadmissionDetails(
        fromYear: _asInt(json['fromyear']),
        toYear: _asInt(json['toyear']),
        sid: _asInt(json['sid']),
        isReadmission: _asInt(json['IsReadmission']),
        feeHead: _asString(json['FeeHead']),
        uname: _asString(json['uname']),
      );

  Map<String, dynamic> toJson() => {
    'fromyear': fromYear,
    'toyear': toYear,
    'sid': sid,
    'IsReadmission': isReadmission,
    'FeeHead': feeHead,
    'uname': uname,
  };
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

String? _asString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}
