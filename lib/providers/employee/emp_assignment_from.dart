import 'dart:developer';
import 'dart:io';
// import 'package:ednect_holichild_bijni/constants/constant.dart';
// import 'package:ednect_holichild_bijni/providers/common/common_post_method.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../constants/constant.dart';
import '../../models/employee/assignment.dart';
import '../../models/employee/book_model.dart';
import '../../models/employee/chapter_model.dart';
import '../../models/employee/class_model.dart';
import '../../models/employee/edit_assignment.dart';
import '../../models/employee/subject_model.dart';
import '../common/common_post_method.dart';
import '../common/get_api_kay.dart';

class AssignmentFormProvider extends ChangeNotifier {
  // ------------------------------------------------------------
  // FORM STATE
  // ------------------------------------------------------------
  
  bool isAdding = false;
  bool isEditMode = false;
  bool isSubmitting = false;
  bool isLoadingEditData = false;

  bool isLoadingClasses = false;
  bool isLoadingSubjects = false;
  bool isLoadingBooks = false;
  bool isLoadingChapters = false;

  // Teacher type toggle
  bool isOwnChecked = true; // <------ MISSING EARLIER (Fixed)

  // ------------------------------------------------------------
  // DATA HOLDERS
  // ------------------------------------------------------------
  
  String? empId;
  String? fromYear;
  String? toYear;
  String? appSerial;

  List<ClassData>? classList;
  List<SubjectData>? subjectList;
  List<BookData>? bookList;
  List<ChapterData>? chapterList;

  String? selectedClass;
  String? selectedSubject;
  String? selectedBook;
  String? className;

  List<ChapterData> selectedChapters = [];

  List<File> newFiles = [];
  List<AssignmentAttachment> existingFiles = [];

  EditAssignmentResponseModel? editAssignmentResponseModel;
  List<EditAssignmentData>? editAssignmentData;
  // List<ClassData>? classData;
  // List<SubjectData>? subjectData;
  // List<BookData>? bookData;
  // List<ChapterData>? chapterData;
  // List<AssignmentAttachment>? assignmentAttachment;

  SubjectData? dataSubjectList;
  // ChapterData? _dataChapterList;
  // BookData? _dataBookList;

  // ------------------------------------------------------------
  // CONTROLLERS
  // ------------------------------------------------------------
  
  final issueDateController = TextEditingController();
  final submissionDateController = TextEditingController();
  final detailsController = TextEditingController();
  final attachmentController = TextEditingController(); // <--- used in UI

  // ------------------------------------------------------------
  // TEACHER TYPE TOGGLE
  // ------------------------------------------------------------
  void toggleOwn() {
    isOwnChecked = !isOwnChecked;
    notifyListeners();
  }

  void toggleForm() {
    isAdding = !isAdding;
    // isEditMode = !isEditMode;
    loadClasses();
    notifyListeners();
  }


  // ------------------------------------------------------------
  // DATE PICKERS
  // ------------------------------------------------------------
  
  Future<void> pickIssueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      issueDateController.text = DateFormat("dd/MM/yyyy").format(picked);
      notifyListeners();
    }
  }

  Future<void> pickSubmissionDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      submissionDateController.text = DateFormat("dd/MM/yyyy").format(picked);
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // FILE PICKER
  // ------------------------------------------------------------
  
  Future<void> pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      newFiles.addAll(
        result.paths.map((path) => File(path!)).toList(),
      );
      _updateAttachmentLabel();
      notifyListeners();
    }
  }

  void _updateAttachmentLabel() {
    final total = newFiles.length + existingFiles.length;

    if (total == 0) {
      attachmentController.text = "";
    } else {
      attachmentController.text = "$total file(s) selected";
    }
  }

  void openEditForm(String empId, String assignmentSerial, String? fromYear, String? toYear) {
    isAdding = true;
    isEditMode = true;
    appSerial = assignmentSerial;
    notifyListeners();
    fetchAssignmentsForEdit(empId, assignmentSerial, fromYear);
  }

  /// ------------------------------------------------------------
  /// FETCH ASSIGNMENT LIST (PAGINATED)
  /// ------------------------------------------------------------
  Future<void> fetchAssignmentsForEdit(
      String empId,String? serial, String? year) async {
    // if (isLoading || !hasMore) return;

    isLoadingEditData = true;
    notifyListeners();

    final url = ApiEndpoints.getAssignmentForEdit;

    final body = {
      "empid": empId,
      "app_serial": serial,
      "fromyear": year
    };

    try {
      final response = await postRequest(
        url,
        body
      );

      log("Assignment List Response: $response");

      if (response != null) {
        final parsed = EditAssignmentResponseModel.fromJson(response);
        editAssignmentResponseModel = parsed;
        editAssignmentData = parsed.assignmentData;
        
        // Populate form fields with existing data
        if (editAssignmentData != null && editAssignmentData!.isNotEmpty) {
          final assignment = editAssignmentData![0];
          
          // Set dropdown data
          subjectList = parsed.subjectData;
          bookList = parsed.bookData;
          chapterList = parsed.chapterData;
          classList = parsed.classData;
          
          // Set form values
          final selectClass = classList?.firstWhere(
            (c) => c.classId == assignment.classString,
          );
          selectedClass = selectClass!.classId;
          final selectSubject = subjectList?.firstWhere(
            (s) => s.subjectCode == assignment.subjectCode
          );
          selectedSubject = selectSubject!.subjectCode;
          final selectBook = bookList?.firstWhere(
            (c) => c.bookId == assignment.bookId,
          );

          selectedBook = selectBook!.bookId;
          
          // Set existing attachments (don't convert to File objects)
          existingFiles = parsed.assignmentAttachment.toList();
          
          issueDateController.text = assignment.assignmentDate;
          submissionDateController.text = assignment.submissionDate;
          detailsController.text = cleanHtml(
            parse(assignment.assignmentDetails).documentElement?.text ?? '',
          );

          log(detailsController.text);
          
          // Set subject data
          dataSubjectList = subjectList?.firstWhere(
            (subject) => subject.subjectCode == assignment.subjectCode,
            orElse: () => SubjectData(subjectCode: assignment.subjectCode, subjectName: ''),
          );
          
          // Parse and set selected chapters
          final chapterIdList = (assignment.chapter)
              .split(',')
              .map((id) => id.trim())
              .where((id) => id.isNotEmpty)
              .toList();

          selectedChapters = chapterList
              ?.where((c) => chapterIdList.contains(c.chapterId))
              .toList() ?? [];
 
        }
        notifyListeners();
      }
    } catch (e) {
      isLoadingEditData = false;
      log("fetchAssignments ERROR → $e");
      // hasMore = false;
    } finally {
      isLoadingEditData = false;
      notifyListeners();
    }
  }


  Future<void> deleteAttachment(
    String appSerial, 
    String fileId) async { 
      final url = ApiEndpoints.deleteHomeWorkAttachment; 
      
      final body = {"app_serial": appSerial, "file_id": fileId}; 
      
      try { 
        final response = await postRequest( url, body, ); 
        
        if (response != null){ 
          existingFiles.removeWhere((e) => e.fileId == fileId); 
          _updateAttachmentLabel(); 
          notifyListeners();
        }
      } catch (e) {
          log("deleteAttachment error → $e"); 
        } 
      }

  // ------------------------------------------------------------
  // DROPDOWN CHANGES
  // ------------------------------------------------------------
  
  Future<void> onClassChanged(String? value) async {
    selectedClass = value;

    selectedSubject = null;
    selectedBook = null;
    subjectList = null;
    bookList = null;
    chapterList = null;
    selectedChapters.clear();

    notifyListeners();

    final parts = value?.split("_");
    if (parts != null && parts.length == 3) {
      className = parts[0];
      // final stream = parts[1];
      // final section = parts[2];
    }

    await loadSubjects();
  }

  Future<void> onSubjectChanged(String? value) async {
    selectedSubject = value;

    dataSubjectList = subjectList?.firstWhere(
            (subject) => subject.subjectCode == selectedSubject,
            orElse: () => SubjectData(subjectCode: selectedSubject!, subjectName: ''),
          );

    selectedBook = null;
    bookList = null;
    chapterList = null;
    selectedChapters.clear();

    notifyListeners();

    await loadBooks();
  }

  Future<void> onBookChanged(String? value) async {
    selectedBook = value;

    chapterList = null;
    selectedChapters.clear();

    notifyListeners();

    await loadChapters();
  }

  void onChapterConfirm(List<ChapterData> values) {
    selectedChapters = values;
    notifyListeners();
  }

  void removeChapter(ChapterData chapter) {
    selectedChapters.removeWhere((c) => c.chapterId == chapter.chapterId);
    notifyListeners();
  }

  // ------------------------------------------------------------
  // API CALLS FOR DROPDOWN LISTS
  // ------------------------------------------------------------

  Future<void> loadClasses() async {
    isLoadingClasses = true;
    notifyListeners();

    final body = {
      "empid": empId, 
      "fromyear": fromYear, 
      "toyear": toYear
    };

    log("this log is for the body: $body");

    try {
      final data =
          await postRequest(ApiEndpoints.getClassListForHomework, body);

      if(data != null){
        final res = ClassResponse.fromJson(data);
        classList = res.data;
      }
    } catch (e) {
      log("loadClasses error: $e");
    }

    isLoadingClasses = false;
    notifyListeners();
  }

  Future<void> loadSubjects() async {
    isLoadingSubjects = true;
    notifyListeners();

    final parts = selectedClass?.split("_") ?? [];
    if (parts.length < 3) return;

    final body = {
      "empid": empId,
      "fromyear": fromYear,
      "class_name": parts[0],
      "stream": parts[1],
      "section": parts[2],
    };

    try {
      final data =
          await postRequest(ApiEndpoints.getSubjectListByClass, body);

      if(data != null){
        final subject = SubjectResponse.fromJson(data);
        subjectList = subject.data;
      }
    } catch (e) {
      log("loadSubjects error: $e");
    }

    isLoadingSubjects = false;
    notifyListeners();
  }

  Future<void> loadBooks() async {
    isLoadingBooks = true;
    notifyListeners();

    final parts = selectedClass?.split("_") ?? [];

    final body = {
      "empid": empId,
      "fromyear": fromYear,
      "class_name": parts[0],
      "stream": parts[1],
      "sub_code": selectedSubject,
    };

    try {
      final data =
          await postRequest(ApiEndpoints.getBookListByClass, body);
      if(data != null){
        final book = BookResponse.fromJson(data);
        bookList = book.data;
      }
    } catch (e) {
      log("loadBooks error: $e");
    }

    isLoadingBooks = false;
    notifyListeners();
  }

  Future<void> loadChapters() async {
    isLoadingChapters = true;
    notifyListeners();

    final parts = selectedClass?.split("_") ?? [];

    final body = {
      "empid": empId,
      "fromyear": fromYear,
      "class_name": parts[0],
      "book_id": selectedBook,
    };

    try {
      final data =
          await postRequest(ApiEndpoints.getChapterListByBook, body);
      if(data != null){
        final chapter = ChapterResponse.fromJson(data);
        chapterList = chapter.data;
      }
      
    } catch (e) {
      log("loadChapters error: $e");
    }

    isLoadingChapters = false;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // FORM CONTROL
  // ------------------------------------------------------------

  void cancelForm() {
    isAdding = false;
    isEditMode = false;
    clearForm();
    notifyListeners();
  }

  void clearForm() {
    selectedClass = null;
    selectedSubject = null;
    selectedBook = null;

    subjectList = null;
    bookList = null;
    chapterList = null;

    selectedChapters.clear();

    issueDateController.clear();
    submissionDateController.clear();
    detailsController.clear();
    attachmentController.clear();

    newFiles.clear();
    existingFiles.clear();

    dataSubjectList = null;
    appSerial = null;

    _updateAttachmentLabel();
  }

  void clearAllExistingFiles() {
    existingFiles.clear();
    _updateAttachmentLabel();
    notifyListeners();
  }

  void removeExistingFile(String fileId) {
    existingFiles.removeWhere((f) => f.fileId == fileId);
    _updateAttachmentLabel();
    notifyListeners();
  }

  // ------------------------------------------------------------
  // SUBMIT FORM
  // ------------------------------------------------------------

  Future<bool> submitAssignment(BuildContext context, String empName) async {
    if (!_validate()) return false;

    isSubmitting = true;
    notifyListeners();

    final endpoint = isEditMode ? 
      ApiEndpoints.editAssignment
      : ApiEndpoints.addAssignment;

    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
    final url = Uri.parse("${ApiConfig.baseUrl}$endpoint");

    final request = http.MultipartRequest("POST", url);

    final parts = selectedClass?.split("_") ?? [];

    isEditMode ?
      request.fields.addAll({
        "empid": empId!,
        "assign_mode": isOwnChecked ? "1" : "2",
        "class_string": selectedClass!,
        "subject_code": selectedSubject!,
        "bookid": selectedBook!,
        "chapter_array":
          selectedChapters.map((c) => c.chapterId).join(','),
        "assignment_date": issueDateController.text,
        "submission_date": submissionDateController.text,
        "due_date": submissionDateController.text,
        "subject_name": dataSubjectList!.subjectName ,
        "teacher_name": empName,
        "assignment_detail": detailsController.text,
        "fromyear": fromYear!,
        "toyear": toYear!,
        "app_serial": appSerial ?? "", 
        "class_name": parts[0], 
      })
    : request.fields.addAll({
        "empid": empId ?? "",
        "assign_mode": isOwnChecked ? "1" : "2",
        "class_string": selectedClass ?? "",
        "subject_code": selectedSubject ?? "",
        "bookid": selectedBook ?? "",
        "chapter_array":
          selectedChapters.map((c) => c.chapterId).join(','),
        "assignment_date": issueDateController.text,
        "submission_date": submissionDateController.text,
        "due_date": submissionDateController.text,
        "teacher_name": empName,
        "subject_name": dataSubjectList!.subjectName,
        "assignment_detail": detailsController.text,
        "fromyear": fromYear ?? "",
        "toyear": toYear ?? "",
        "class_name": className ?? '',
      });

    for (var file in newFiles) {
      request.files.add(
        await http.MultipartFile.fromPath("attachments", file.path),
      );
    }

    request.headers.addAll({"ApiKey": apiKey ?? ''});

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      return response.statusCode == 200;
    } catch (e) {
      log("submitAssignment error: $e");
      return false;
    } finally {
      
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // VALIDATION
  // ------------------------------------------------------------


  void clearAssignmentProviderData() {
    // Flags
    isAdding = false;
    isEditMode = false;
    isSubmitting = false;
    isLoadingEditData = false;
    isLoadingClasses = false;
    isLoadingSubjects = false;
    isLoadingBooks = false;
    isLoadingChapters = false;
    isOwnChecked = true;

    // IDs / meta
    empId = null;
    fromYear = null;
    toYear = null;
    appSerial = null;
    className = null;

    // Lists & selections
    classList = null;
    subjectList = null;
    bookList = null;
    chapterList = null;

    selectedClass = null;
    selectedSubject = null;
    selectedBook = null;

    selectedChapters.clear();
    newFiles.clear();
    existingFiles.clear();

    // Edit / models
    editAssignmentResponseModel = null;
    editAssignmentData = null;
    dataSubjectList = null;

    // Controllers
    issueDateController.clear();
    submissionDateController.clear();
    detailsController.clear();
    attachmentController.clear();

    _updateAttachmentLabel();

    notifyListeners();
  }

  bool _validate() {
    if (selectedClass == null) return false;
    if (selectedSubject == null) return false;
    if (issueDateController.text.isEmpty) return false;
    if (submissionDateController.text.isEmpty) return false;
    if (detailsController.text.isEmpty) return false;

    return true;
  }


  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Success"),
        content: Text("Assignment added successfully!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close the dialog
      }
    });
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Failed"),
        content: Text("Something went wrong. Please try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close the dialog
      }
    });
  }



  String cleanHtml(String html) {
    html = html.replaceAllMapped(
      RegExp(r'(\w)[\n\r\u00AD\u200B]+(\w)'),
          (m) => '${m[1]}${m[2]}',
    );
    html = html.replaceAll(RegExp(r'[\n\r\u00A0]+'), ' ');

    html = html.replaceAll(RegExp(r'\s{2,}'), ' ');

    html = html.replaceAllMapped(
      RegExp(r'(\w)-\s*(\w)'),
          (m) => '${m[1]}${m[2]}',
    );

    return html.trim();
  }
}
