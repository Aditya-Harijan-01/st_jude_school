class ApiConfig {
  // static const String baseUrl = 'https://apiv2.realitypublicschool.in/api';
  static const String baseUrl = 'https://api.stjudedibrugarh.org/api';
}


class ApiEndpoints {

  //--------------------Common API Url-Total=4-----------------//
  static const String loadMenuStructure = "/LoadMenuStructure";
  static const String loadEmployeeMenuStructure = "/LoadEmployeeMenuStructure";
  static const String authLogin = '/commonloginusername';
  static const String authPassword = '/commonloginpassword';
  //-----------------XXX-Total=30------------------//
  static const String redirectToReadmission = '/RedirectToReadmission';
  static const String getStudentProfile ='/GetStudentProfile';
  static const String forgotPassword = '/ForgotPasswordByUsername';
  static const String changePassword = '/ChangePassword';
  static const String getLibrary = '/GetStudentLibraryRecords';
  static const String getSubjectListForSyllabus = '/GetSubjectListForSyllabus';
  static const String getSyllabusDetails = '/GetSyllabusDetails';
  static const String getSyllabusDetailsByExam = '/GetSyllabusDetailsByExam';
  static const String getNotification = '/GetStudentNotification';
  static const String getExaminationList = '/GetExaminationList';
  static const String getDashboardRecentNotifications ='/GetDashboardRecentNotifications';
  static const String getStudentSession ='/GetAllValidSession';
  static const String getStudentAssignment ='/GetStudentAssignmentDetails';
  static const String getAcademicCalendar ='/GetAcademicCalendar';
  static const String getStudentTransportStatus = '/GetStudentTransportStatus';
  static const String getTransportTrackingDetails = '/GetTransportTrackingDetails';
  static const String getStudentQueryHistory = '/GetStudentQueryHistory';
  static const String getContactUs = '/GetContactUs';
  static const String getStudentTransportFeeStructure = '/GetStudentTransportFeeStructure';
  static const String getPhotoAlbum = '/GetPhotoAlbum';
  static const String getStudentContactToTheSchool = '/GetStudentContactToTheSchool';
  static const String getStudentQueryHistoryData = '/GetStudentQueryHistory';
  static const String getConcernTypeList = '/GetConcernTypeList';
  static const String getDaywiseTimetableDetails = "/GetDaywiseTimetableDetails";
  static const String getStudentsPerformanceChartByExamination = '/GetStudentsPerformanceChartByExamination';
  static const String getApiKey = '/GetApikey';
  static const String submitCoCurricullarApplication = '/SubmitCoCurricullarApplication';
  static const String replyStudentConcern = '/ReplyStudentConcern';
  static const String createStudentNewConcern = '/CreateStudentNewConcern';
  static const String getTransportAssignedRouteDetails = '/GetTransportAssignedRouteDetails';
  static const String initiateTransportPayment = '/InitiateTransportPayment';
  static const String getStudentTransportReceipt = "/GetStudentTransportReceipt";
  static const String getStudentNotification = "/GetStudentNotification";

  static const String addFcmToken = "/AddFCMToken";
  static const String generateOtp = "/generateOtp";
  
  ////----====----====----====Employee-Total=3----====----====----====////
  static const String getEmployeeProfile = "/GetEmployeeProfile";
  static const String getAllValidSessionEmployee = "/GetAllValidSessionEmployee";
  static const String getEmployeeNotification = "/GetEmployeeNotification";


  // static const String getEmployeeDashboardData = "/GetEmployeeDashboardData";



  ////----====----====----====Employee-Leave-Total=7----====----====----====////
  static const String getEmployeeLeaveSummery = "/GetEmployeeLeaveSummery";
  static const String getEmployeeLeaveHistory = "/GetEmployeeLeaveHistory";
  static const String getEmployeeLeaveTypeMaster = "/GetEmployeeLeaveTypeMaster";
  static const String verifyEmployeeLeaveRequest = "/VerifyEmployeeLeaveRequest";
  static const String getRequestedLeaveDescription = "/GetRequestedLeaveDescription";
  static const String employeeLeaveApply = "/EmployeeLeaveApply";
  static const String cancelEmployeeLeave = "/CancelEmployeeLeave";


  ////----====----====----====Employee-syllabus-Total=5----====----====----====////
  static const String activeClassList = "/GetAllActiveClassListForSyllabus";
  static const String subjectType = "/GetSubjectTypeForSyllabus";
  static const String allSubjectList = "/GetAllSubjectListForSyllabus";
  static const String bookList = "/GetBookListByClassForSyllabus";
  static const String getSyllabusByBook = "/GetSyllabusByBook";


  ////----====----====----====Employee-HomeWork-Total=9----====----====----====////
  static const String getAssignment = "/GetAssigmentDetails";
  static const String getClassListForHomework = "/GetClassListForHomework";
  static const String getSubjectListByClass = "/GetSubjectListByClassForHomework";
  static const String getBookListByClass = "/GetBookListByClassForHomework";
  static const String getChapterListByBook = "/GetChapterListByBookForHomework";
  static const String getAssignmentForEdit = "/GetAssigmentDetailsForEdit";
  static const String addAssignment = "/AddNewAssignment";
  static const String editAssignment = "/EditAssignment";
  static const String deleteHomeWorkAttachment = "/DeleteHomeworkAttachment";

  //----====----====----====Employee-Contact-To-School-Total=5====----====----====////
  static const String fetchEmpContactTOSchool = "/GetEmployeeContactToTheSchool";
  static const String fetchConcernTypeList = "/GetConcernTypeList";
  static const String createEmpConcern = "/CreateEmployeeNewConcern";
  static const String fetchEmpConcernHistory = "/GetEmployeeQueryHistory";
  static const String replyEmployeeConcern = "/ReplyEmployeeConcern";


  //////=======================Employee-Compensation-Total=2===========================////
  static const String fetchCompensationHistory = "/GetEmployeeSalaryHistory";
  static const String downloadPaySlip = "/DownloadSalarySlip";
  

  //----====----====----====Employee-Student-Attandence-Total=5====----====----====////
  static const String getSessionDate = "/GetSessionDate";
  static const String activeClsForStdAttend = "/GetAllActiveClassForStudentAttendance";
  static const String activeStdForAttend = "/GetAllActiveStudentForAttendance";
  static const String updateStdAttend = "/UpdateStudentAttendance";
  static const String updateBatchStdAttend = "/UpdateBatchStudentAttendance";

  //----====----====----====Employee-Communication====----====----====////
  static const String getCommunicationList = "/GetCommunicationList";
  static const String getAnnouncmentType = "/GetAnnouncementType";
  static const String getClassListForCommunication = "/GetClassListForCommunication";
  static const String getClasswiseStudentListForCommunication = "/GetClasswiseStudentListForCommunication";
  static const String getEmployeeCategoryForCommunication = "/GetEmployeeCategoryForCommunication";
  static const String getEmployeeListByCategoryForCommunication = "/GetEmployeeListByCategoryForCommunication";
  static const String getGroupForCommunication = "/GetGroupForCommunication";
  static const String getGroupMemberListForCommunication = "/GetGroupMemberListForCommunication";
  static const String createNewNotice = "/CreateNewNotice";


  /////--------------Time-Table-----------------/////
  static const String getEmployeeDaywiseTimetableDetails  = "/GetEmployeeDaywiseTimetableDetails";


  //meraj

  //payment
  static const String getFeeStructureByStudent = '/GetFeeStructureByStudent';
  static const String getFineDetailByStudent = '/GetFineDetailByStudent';
  static const String getInitiateFeePayment = '/InitiateFeePayment';
  static const String getInitiateFinePayment = '/InitiateFinePayment';
  //Print Receipt
  static const String printStudentPaymentReceipt = '/PrintStudentPaymentReceipt';//download

  //admit
  static const String getAllAdmitCard = '/GetAllAdmitCard';
  static const String downloadAdmitCard = '/DownloadAdmitCard';//download


  //attendance
  static const String getStudentAttendanceSummery = '/GetStudentAttendanceSummery';
  static const String getStudentMonthwiseAttendanceDetail = '/GetStudentMonthwiseAttendanceDetail';

  //assesment
  static const String getStudentsReportCards = '/GetStudentsReportCards';
  static const String getStudentsAnalysisByExamination = '/GetStudentsAnalysisByExamination';

  static const String getExaminationReportCard = '/GetExaminationReportCard';//download

  //EMPLOYEE

  //mark_entry----------------------------------------------------------------------
  static const String getClassForMarkEntry = '/GetClassForMarkEntry';
  static const String getTeacherForMarkEntry = '/GetTeacherForMarkEntry';
  static const String getExaminationForMarkEntry = '/GetExaminationForMarkEntry';
  static const String getSubjectGroupForMarkEntry = '/GetSubjectGroupForMarkEntry';
  static const String getSubjectListForMarkEntry = '/GetSubjectListForMarkEntry';
  static const String getStudentListForMarkEntry = '/GetStudentListForMarkEntry';

  static const String saveMarkEntry = '/SaveMarkEntry';
  static const String deleteDuplicateMarkEntry = '/DeleteDuplicateMarkEntry';


  //appraisal----------------------------------------------------------------------
  static const String getEmployeeAppraisalReport = '/GetEmployeeAppraisalReport';

  //attendance----------------------------------------------------------------------
  static const String getEmployeeAttendanceSummery = '/GetEmployeeAttendanceSummery';
  static const String getEmployeeMonthwiseAttendanceDetail = '/GetEmployeeMonthwiseAttendanceDetail';


  //calendar----------------------------------------------------------------------
  static const String getEmployeeAcademicCalendar = '/GetEmployeeAcademicCalendar';

  //library----------------------------------------------------------------------
  static const String getEmployeeLibraryRecords = '/GetEmployeeLibraryRecords';


  //Task----------------------------------------------------------------------
  static const String getEmployeeListForTask = '/GetEmployeeListForTask';
  static const String getEmployeeSlotWiseTask = '/GetEmployeeSlotWiseTask';
  //add_new_Task:
  static const String addNewTask = '/AddNewTask';

  //task-functions:
  static const String moveTaskToAnotherSlot = '/MoveTaskToAnotherSlot';
  static const String cloneTask = '/CloneTask'; //done
  static const String editTaskDetail = '/EditTaskDetail'; //done
  static const String changeTaskStatus = '/ChangeTaskStatus'; //done
  static const String deleteTaskSendToPending = '/TaskSendToPending'; //done

  //task-pending
  static const String getEmployeePendingTask = '/GetEmployeePendingTask';

  //pending-functions:
  static const String taskAllotment = '/TaskAllotment';


  //Student Management
  static const String getAllActiveClassList = '/GetAllActiveClassList';
  static const String getAllActiveStudentListClassSectionWise = '/GetAllActiveStudentListClassSectionWise';
  static const String getStudentProfileImage = '/GetStudentProfileImage';

  //Employee Management
  static const String getEmployeeCounter = '/GetEmployeeCounter';
  static const String getEmployeeByCategory = '/GetEmployeeByCategory';

  //---------------------------------------DASHBOARD------------------------------------------------------//
  static const String getStudentDashboardData = '/GetStudentDashboardData';
  static const String getEmployeeDashboardData = '/GetEmployeeDashboardData';


  //remark_entry
  static const String getTermForRemarkEntry = '/GetTermForRemarkEntry';
  static const String getClassForRemarkEntry = '/GetClassForRemarkEntry';
  static const String getStudentRemarkEntryList = '/GetStudentRemarkEntryList';
  static const String setRemarkForExamination = '/SetRemarkForExamination';

  //hostel
  static const String getStudentHostelStatus = '/GetStudentHostelStatus';
  static const String getStudentHostelFeeStructure = '/GetStudentHostelFeeStructure';
  static const String initiateHostelPayment = '/InitiateHostelPayment';
}