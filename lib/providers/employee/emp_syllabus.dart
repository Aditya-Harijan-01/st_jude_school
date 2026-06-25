import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../models/common/book_response.dart';
import '../../models/common/category_response.dart';
import '../../models/common/class_response.dart';
import '../../models/common/subject_response.dart';
import '../../models/employee/syllabus_.dart';
import '../common/common_post_method.dart';

class EmployeeSyllabusProvider extends ChangeNotifier {

  ClassResponse? classResponse;
  List<ClassData>? classData;

  CategoryResponse? categoryResponse;
  List<CategoryData>? categroyDate;

  SubjectResponse? subjectResponse;
  List<SubjectData>? subjectData;

  BookResponse? bookResponse;
  List<BookData>? bookData;

  GetSyllabusByBookResponse? getSylabuss;
  List<SyllabusChapter>? syllabusChapter;

  bool isLoadingClass = false;
  bool isLoadingCategory = false;
  bool isLoadingSubject = false;
  bool isLoadingBook = false;
  bool isLoadingChapter = false;

  Future<void> activeClassList(empId, from, to) async {
    isLoadingClass = true;
    notifyListeners();

    try {
      final data = await postRequest(ApiEndpoints.activeClassList, {
        "empid": empId,
        "fromYear": from,
        "toyear": to,
      });

      if (data != null) {
        classResponse = ClassResponse.fromJson(data);
        classData = classResponse?.data;
      }
    } catch (e) {
      log("Error loading class: $e");
    }

    isLoadingClass = false;
    notifyListeners();
  }

  Future<void> subjectType(empId, from, to) async {
    isLoadingCategory = true;
    notifyListeners();

    try {
      final data = await postRequest(ApiEndpoints.subjectType, {
        "empid": empId,
        "fromYear": from,
        "toyear": to,
      });

      if (data != null) {
        categoryResponse = CategoryResponse.fromJson(data);
        categroyDate = categoryResponse?.data;
      }
    } catch (e) {
      log("Error loading category: $e");
    }

    isLoadingCategory = false;
    notifyListeners();
  }

  Future<void> allSubjectList(empId, className, stream, type, from, to) async {
    isLoadingSubject = true;
    notifyListeners();

    try {
      final data = await postRequest(ApiEndpoints.allSubjectList, {
        "empid": empId,
        "class_name": className,
        "stream": stream,
        "subject_type": type,
        "fromYear": from,
        "toyear": to,
      });

      if (data != null) {
        subjectResponse = SubjectResponse.fromJson(data);
        subjectData = subjectResponse?.data;
      }
    } catch (e) {
      log("Error loading subjects: $e");
    }

    isLoadingSubject = false;
    notifyListeners();
  }
  void clear(){
    classResponse = null;
    notifyListeners();
  }
  Future<void> bookList(empId, className, stream, subCode, from) async {
    isLoadingBook = true;
    notifyListeners();

    try {
      final data = await postRequest(ApiEndpoints.bookList, {
        "empid": empId,
        "class_name": className,
        "stream": stream,
        "sub_code": subCode,
        "fromYear": from,
      });

      if (data != null) {
        bookResponse = BookResponse.fromJson(data);
        bookData = bookResponse?.data;
      }
    } catch (e) {
      log("Error loading book: $e");
    }

    isLoadingBook = false;
    notifyListeners();
  }

  Future<void> getSyllabusByBook(empId, year, toYear, subCode, bookId) async {
    isLoadingChapter = true;
    notifyListeners();

    try {
      final data = await postRequest(ApiEndpoints.getSyllabusByBook, {
        "empid": empId,
        "fromyear": year,
        "toyear": toYear,
        "sub_code": subCode,
        "bookid": bookId,
      });

      if (data != null) {
        getSylabuss = GetSyllabusByBookResponse.fromJson(data);
        syllabusChapter = getSylabuss?.data;
      }
    } catch (e) {
      log("Error loading chapter: $e");
    }

    isLoadingChapter = false;
    notifyListeners();
  }
}
