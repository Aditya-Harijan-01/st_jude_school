class EmployeeSlotWiseTaskResponse {
  final String? statusCode;
  final String? message;
  final List<SlotData>? data;

  EmployeeSlotWiseTaskResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory EmployeeSlotWiseTaskResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeSlotWiseTaskResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((e) => SlotData.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class SlotData {
  final String? slotId;
  final String? slotTime;
  final String? slotAssignTime;
  final List<Task>? taskList;

  SlotData({
    this.slotId,
    this.slotTime,
    this.slotAssignTime,
    this.taskList,
  });

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      slotId: json['slot_id'],
      slotTime: json['slot_time'],
      slotAssignTime: json['slot_assign_time'],
      taskList: json['task_list'] != null
          ? (json['task_list'] as List).map((e) => Task.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slot_id': slotId,
      'slot_time': slotTime,
      'slot_assign_time': slotAssignTime,
      'task_list': taskList?.map((e) => e.toJson()).toList(),
    };
  }
}

class Task {
  final String? id;
  final String? tasktype;
  final String? urgency;
  final String? assignto;
  final String? assignedby;
  final String? forwardedby;
  final String? completedby;
  final String? startdate;
  final String? enddate;
  final String? taskdate;
  final String? taskcloneid;
  final String? timeslotid;
  final String? requiredtime;
  final String? head;
  final String? details;
  final String? status;
  final String? iscompleted;
  final String? createdate;
  final String? updatedby;
  final String? updatedate;
  final String? completedate;
  final String? completedateFontColor;
  final String? remark;
  final String? assignbyname;
  final String? frdbyname;
  final String? taskstatus;
  final String? taskBorderColor;
  final String? isUnderline;
  final String? cloneColor;

  Task({
    this.id,
    this.tasktype,
    this.urgency,
    this.assignto,
    this.assignedby,
    this.forwardedby,
    this.completedby,
    this.startdate,
    this.enddate,
    this.taskdate,
    this.taskcloneid,
    this.timeslotid,
    this.requiredtime,
    this.head,
    this.details,
    this.status,
    this.iscompleted,
    this.createdate,
    this.updatedby,
    this.updatedate,
    this.completedate,
    this.completedateFontColor,
    this.remark,
    this.assignbyname,
    this.frdbyname,
    this.taskstatus,
    this.taskBorderColor,
    this.isUnderline,
    this.cloneColor,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      tasktype: json['tasktype'],
      urgency: json['urgency'],
      assignto: json['assignto'],
      assignedby: json['assignedby'],
      forwardedby: json['forwardedby'],
      completedby: json['completedby'],
      startdate: json['startdate'],
      enddate: json['enddate'],
      taskdate: json['taskdate'],
      taskcloneid: json['taskcloneid'],
      timeslotid: json['timeslotid'],
      requiredtime: json['requiredtime'],
      head: json['head'],
      details: json['details'],
      status: json['status'],
      iscompleted: json['iscompleted'],
      createdate: json['createdate'],
      updatedby: json['updatedby'],
      updatedate: json['updatedate'],
      completedate: json['completedate'],
      completedateFontColor: json['completedate_font_color'],
      remark: json['remark'],
      assignbyname: json['assignbyname'],
      frdbyname: json['frdbyname'],
      taskstatus: json['taskstatus'],
      taskBorderColor: json['task_border_color'],
      isUnderline: json['is_underline'],
      cloneColor: json['cloneColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tasktype': tasktype,
      'urgency': urgency,
      'assignto': assignto,
      'assignedby': assignedby,
      'forwardedby': forwardedby,
      'completedby': completedby,
      'startdate': startdate,
      'enddate': enddate,
      'taskdate': taskdate,
      'taskcloneid': taskcloneid,
      'timeslotid': timeslotid,
      'requiredtime': requiredtime,
      'head': head,
      'details': details,
      'status': status,
      'iscompleted': iscompleted,
      'createdate': createdate,
      'updatedby': updatedby,
      'updatedate': updatedate,
      'completedate': completedate,
      'completedate_font_color': completedateFontColor,
      'remark': remark,
      'assignbyname': assignbyname,
      'frdbyname': frdbyname,
      'taskstatus': taskstatus,
      'task_border_color': taskBorderColor,
      'is_underline': isUnderline,
      'cloneColor': cloneColor,
    };
  }
}
