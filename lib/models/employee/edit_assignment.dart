import 'assignment.dart';
import 'book_model.dart';
import 'chapter_model.dart';
import 'class_model.dart';
import 'subject_model.dart';

class EditAssignmentResponseModel {
  final String statusCode;
  final int userAccessValue;
  final List<EditAssignmentData> assignmentData;
  final List<ClassData> classData;
  final List<SubjectData> subjectData;
  final List<BookData> bookData;
  final List<ChapterData> chapterData;
  final List<AssignmentAttachment> assignmentAttachment;

  EditAssignmentResponseModel({
    required this.statusCode,
    required this.userAccessValue,
    required this.assignmentData,
    required this.classData,
    required this.subjectData,
    required this.bookData,
    required this.chapterData,
    required this.assignmentAttachment,
  });

  factory EditAssignmentResponseModel.fromJson(Map<String, dynamic> json) {
    return EditAssignmentResponseModel(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      assignmentData: (json['assignmentData'] as List)
          .map((e) => EditAssignmentData.fromJson(e))
          .toList(),
      classData: (json['classData'] as List)
          .map((e) => ClassData.fromJson(e))
          .toList(),
      subjectData: (json['subjectData'] as List)
          .map((e) => SubjectData.fromJson(e))
          .toList(),
      bookData: (json['bookData'] as List)
          .map((e) => BookData.fromJson(e))
          .toList(),
      chapterData: (json['chapterData'] as List)
          .map((e) => ChapterData.fromJson(e))
          .toList(),
      assignmentAttachment: (json['attachmentData'] as List)
          .map((e) => AssignmentAttachment.fromJson(e))
          .toList()
    );
  }
}

class EditAssignmentData {
  final String empId;
  final String classString;
  final String assignmentDate;
  final String subjectCode;
  final String assignmentDetails;
  final String submissionDate;
  final String bookId;
  final String chapter;
  final String fromYear;
  final String toYear;

  EditAssignmentData({
    required this.empId,
    required this.classString,
    required this.assignmentDate,
    required this.subjectCode,
    required this.assignmentDetails,
    required this.submissionDate,
    required this.bookId,
    required this.chapter,
    required this.fromYear,
    required this.toYear,
  });

  factory EditAssignmentData.fromJson(Map<String, dynamic> json) {
    return EditAssignmentData(
      empId: json['empid'],
      classString: json['class_string'],
      assignmentDate: json['assignment_date'],
      subjectCode: json['subject_code'],
      assignmentDetails: json['assignment_details'],
      submissionDate: json['submission_date'],
      bookId: json['bookid'],
      chapter: json['chapter'],
      fromYear: json['fromyear'],
      toYear: json['toyear'],
    );
  }
}

