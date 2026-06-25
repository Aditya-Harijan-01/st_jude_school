import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/student_management/active_class_model.dart';
import '../../models/employee/student_management/student_list.dart';
import '../common/common_post_method.dart';

class StudentManagementProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<ClassModel> _classList = [];
  ClassModel? _selectedClass;
  List<Student> _studentList = [];
  bool _isStudentLoading = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ClassModel> get classList => _classList;
  ClassModel? get selectedClass => _selectedClass;
  List<Student> get studentList => _studentList;
  bool get isStudentLoading => _isStudentLoading;
  int _userAccessValue = 0;
  int get userAccessValue => _userAccessValue;

  Future<void> getAllActiveClassList(
      String empID,
      String fromYear,
      String toYear,
      ) async
  {
    _isLoading = true;
    _errorMessage = '';
    _userAccessValue = 0;
    notifyListeners();

    try {
      final body = {
        "empid": empID,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final response = await postRequest(ApiEndpoints.getAllActiveClassList, body);

      if (response != null) {
        final classResponse = ClassResponseModel.fromJson(response);
        _userAccessValue = classResponse.statusCodeValue;
        if (classResponse.isSuccess) {
          _classList = classResponse.data;
          if (_classList.isNotEmpty) {
            _selectedClass = _classList.first;
          }
        } else {
          _errorMessage = 'Failed to load classes';
        }
      } else {
        _errorMessage = 'Something went wrong';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStudentList(String empID, String fromYear, String toYear) async
  {
    if (_selectedClass == null) return;

    _isStudentLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final body = {
        "empid": empID,
        "fromyear": fromYear,
        "toyear": toYear,
        "class_name": _selectedClass!.grade,
        "section": _selectedClass!.section ?? "",
        "stream": _selectedClass!.stream ?? ""
      };

      final response = await postRequest(ApiEndpoints.getAllActiveStudentListClassSectionWise, body);

      if (response != null) {
        final studentResponse = StudentListResponse.fromJson(response);
        if (studentResponse.isSuccess) {
          _studentList = studentResponse.data;
        } else {
          _studentList = [];
          _errorMessage = 'Failed to load students';
        }
      } else {
        _errorMessage = 'Something went wrong';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isStudentLoading = false;
      notifyListeners();
    }
  }

  void setSelectedClass(ClassModel? value) {
    _selectedClass = value;
    notifyListeners();
  }
  void clearStudentManagementProvider() {
    _isLoading = false;
    _isStudentLoading = false;
    _errorMessage = '';

    _classList.clear();
    _selectedClass = null;

    _studentList.clear();

    _userAccessValue = 0;

    notifyListeners();
  }

}
