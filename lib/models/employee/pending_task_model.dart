class PendingTaskResponse {
  final String statusCode;
  final int userAccessValue;
  final List<PendingTaskData> data;

  PendingTaskResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory PendingTaskResponse.fromJson(Map<String, dynamic> json) {
    return PendingTaskResponse(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] ?? 0,
      data: (json['data'] as List?)
          ?.map((item) => PendingTaskData.fromJson(item))
          .toList() ?? [],
    );
  }
}

class PendingTaskData {
  final String id;
  final String tasktype;
  final String urgency;
  final String assignto;
  final String assignedby;
  final String forwardedby;
  final String completedby;
  final String startdate;
  final String enddate;
  final String taskdate;
  final String taskcloneid;
  final String timeslotid;
  final String requiredtime;
  final String takentime;
  final String head;
  final String details;
  final String status;
  final String iscompleted;
  final String createdate;
  final String updatedby;
  final String updatedate;
  final String completedate;
  final String remark;
  final String assignbyname;
  final String urgencyText;
  final String fontColor;

  PendingTaskData({
    required this.id,
    required this.tasktype,
    required this.urgency,
    required this.assignto,
    required this.assignedby,
    required this.forwardedby,
    required this.completedby,
    required this.startdate,
    required this.enddate,
    required this.taskdate,
    required this.taskcloneid,
    required this.timeslotid,
    required this.requiredtime,
    required this.takentime,
    required this.head,
    required this.details,
    required this.status,
    required this.iscompleted,
    required this.createdate,
    required this.updatedby,
    required this.updatedate,
    required this.completedate,
    required this.remark,
    required this.assignbyname,
    required this.urgencyText,
    required this.fontColor,
  });

  factory PendingTaskData.fromJson(Map<String, dynamic> json) {
    return PendingTaskData(
      id: json['id'] ?? '',
      tasktype: json['tasktype'] ?? '',
      urgency: json['urgency'] ?? '',
      assignto: json['assignto'] ?? '',
      assignedby: json['assignedby'] ?? '',
      forwardedby: json['forwardedby'] ?? '',
      completedby: json['completedby'] ?? '',
      startdate: json['startdate'] ?? '',
      enddate: json['enddate'] ?? '',
      taskdate: json['taskdate'] ?? '',
      taskcloneid: json['taskcloneid'] ?? '',
      timeslotid: json['timeslotid'] ?? '',
      requiredtime: json['requiredtime'] ?? '',
      takentime: json['takentime'] ?? '',
      head: json['head'] ?? '',
      details: json['details'] ?? '',
      status: json['status'] ?? '',
      iscompleted: json['iscompleted'] ?? '',
      createdate: json['createdate'] ?? '',
      updatedby: json['updatedby'] ?? '',
      updatedate: json['updatedate'] ?? '',
      completedate: json['completedate'] ?? '',
      remark: json['remark'] ?? '',
      assignbyname: json['assignbyname'] ?? '',
      urgencyText: json['urgency_text'] ?? '',
      fontColor: json['font_color'] ?? '',
    );
  }
}