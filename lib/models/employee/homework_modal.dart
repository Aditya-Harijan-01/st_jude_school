class HomeworkModel {
  final int slNo;
  final String date;
  final String className;
  final String subject;
  final String status;
  final String? bookName;
  final String? chapter;
  final String? details;
  final String? issueDate;
  final String? submissionDate;

  HomeworkModel({
    required this.slNo,
    required this.date,
    required this.className,
    required this.subject,
    required this.status,
    this.bookName,
    this.chapter,
    this.details,
    this.issueDate,
    this.submissionDate,
  });

  static List<HomeworkModel> getDummyData() {
    return [
      HomeworkModel(
        slNo: 1,
        date: '24/10/24',
        className: '3',
        subject: 'English',
        status: 'Pending',
        bookName: 'English Grammer #3',
        chapter: '10',
        details: 'xxxxxxxx xxxxxx xxxxxx xxxxxxxxxx xxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx',
        issueDate: '24/10/24',
        submissionDate: '30/10/24',
      ),
      HomeworkModel(
        slNo: 2,
        date: 'xx/xx/xx',
        className: '5',
        subject: 'EVS',
        status: 'Pending',
      ),
      HomeworkModel(
        slNo: 3,
        date: 'xx/xx/xx',
        className: '6',
        subject: 'English',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 4,
        date: 'xx/xx/xx',
        className: '4',
        subject: 'EVS',
        status: 'Pending',
      ),
      HomeworkModel(
        slNo: 5,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 6,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 7,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 8,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 9,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 10,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 11,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
      HomeworkModel(
        slNo: 12,
        date: 'xx/xx/xx',
        className: 'X',
        subject: 'xxxxxxx',
        status: 'Complete',
      ),
    ];
  }
}