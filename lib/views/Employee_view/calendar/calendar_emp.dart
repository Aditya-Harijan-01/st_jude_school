// ignore_for_file: deprecated_member_use

import 'dart:developer';
import '../../../providers/student/acedemic_calandar.dart';
import '../widget/common_bottom_sheet_emp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../Student_views/calendar/widgets/event_loader.dart';

class EmpCalendarScreen extends StatefulWidget {
  const EmpCalendarScreen({super.key});

  @override
  State<EmpCalendarScreen> createState() => _EmpCalendarScreenState();
}

class _EmpCalendarScreenState extends State<EmpCalendarScreen> {
  DateTime now = DateTime.now();
  late DateTime _focusedDate;
  late DateTime? _selectedDate;

  late int _fromYear;
  late int _toYear;

  int? _sessionStartYear;
  int? _sessionEndYear;

  bool _showAllEvents = false;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _todayEventKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final isJanToMarch = now.month >= 1 && now.month <= 3;
    _focusedDate = DateTime(
      isJanToMarch
          ? int.parse(auth.loginData!.currentyearto)
          : int.parse(auth.loginData!.currentyearfrom),
      now.month,
      now.day,
    );
    _selectedDate = DateTime(
      isJanToMarch
          ? int.parse(auth.loginData!.currentyearto)
          : int.parse(auth.loginData!.currentyearfrom),
      now.month,
      now.day,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  void _initData() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _fromYear = int.parse(auth.loginData!.currentyearfrom);
    _toYear = int.parse(auth.loginData!.currentyearto);

    setState(() {
      _sessionStartYear = _fromYear;
      _sessionEndYear = _toYear;
    });
    _fetchAcademicCalendar();
  }

  Future<void> _fetchAcademicCalendar() async {
    try {
      final calendarProvider = Provider.of<AcedemicCalandarProvider>(
        context,
        listen: false,
      );

      await calendarProvider.getAcedemicCalandar(
        "emp",
        _fromYear.toString(),
        _toYear.toString(),
        _focusedDate.month.toString(),
      );
    } catch (e, s) {
      log('Error fetching academic calendar: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  bool get _canGoToNextMonth {
    if (_sessionEndYear == null) return true;
    if (_focusedDate.year == _sessionEndYear && _focusedDate.month == 3) {
      return false;
    }
    return true;
  }

  bool get _canGoToPreviousMonth {
    if (_sessionStartYear == null) return true;
    if (_focusedDate.year == _sessionStartYear && _focusedDate.month == 4) {
      return false;
    }
    return true;
  }

  Future<void> _goToNextMonth() async {
    if (!_canGoToNextMonth) return;

    final calendarProvider = Provider.of<AcedemicCalandarProvider>(
      context,
      listen: false,
    );

    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
      _selectedDate = DateTime(_focusedDate.year, _focusedDate.month, now.day);
      _showAllEvents = false;
    });

    await calendarProvider.getAcedemicCalandar(
      "emp",
      _fromYear.toString(),
      _toYear.toString(),
      _focusedDate.month.toString(),
    );
  }

  Future<void> _goToPreviousMonth() async {
    if (!_canGoToPreviousMonth) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final calendarProvider = Provider.of<AcedemicCalandarProvider>(
      context,
      listen: false,
    );

    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
      _selectedDate = DateTime(_focusedDate.year, _focusedDate.month, now.day);
      _showAllEvents = false;
    });

    await calendarProvider.getAcedemicCalandar(
      "emp",
      _fromYear.toString(),
      _toYear.toString(),
      _focusedDate.month.toString(),
    );
  }

  void _scrollToToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_todayEventKey.currentContext != null) {
        Scrollable.ensureVisible(
          _todayEventKey.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          alignment: 0.02,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          "Calendar",
          style: TextStyle(color: CustomColor.colorWhite, fontSize: 20.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AcedemicCalandarProvider>(
        builder: (context, provider, _) {
          final events = provider.academicDay ?? [];

          // Get current month’s events
          final monthEvents = events.where((e) {
            final date = parseDate(e.eDate);
            return date != null &&
                date.month == _focusedDate.month &&
                date.year == _focusedDate.year;
          }).toList();

          if (_showAllEvents && monthEvents.isNotEmpty) {
            _scrollToToday();
          }

          // Filter events for selected date
          final selectedEvents = _selectedDate == null
              ? []
              : events.where((e) {
                  final date = parseDate(e.eDate);
                  return date != null &&
                      date.year == _selectedDate!.year &&
                      date.month == _selectedDate!.month &&
                      date.day == _selectedDate!.day;
                }).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text(
                  "Academic Calendar",
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: CustomColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                buildCalendarCard(provider, events),

                // 🔘 Show All Events toggle
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    icon: Icon(
                      _showAllEvents
                          ? Icons.arrow_drop_up
                          : Icons.list_alt_rounded,
                      color: CustomColor.primaryColor,
                    ),
                    label: Text(
                      _showAllEvents ? "Hide Events" : "Show All Events",
                      style: TextStyle(
                        color: CustomColor.primaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _showAllEvents = !_showAllEvents;
                      });
                    },
                  ),
                ),

                if (_showAllEvents)
                  SizedBox(
                    height: 360.h,
                    child: monthEvents.isEmpty
                        ? Center(
                            child: Text(
                              "No events this month",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: () {
                                final todayIndex = monthEvents.indexWhere((e) {
                                  final eventDate = DateFormat(
                                    'dd-MM-yyyy',
                                  ).parse(e.eDate!);
                                  return eventDate.year ==
                                          _selectedDate?.year &&
                                      eventDate.month == _selectedDate?.month &&
                                      eventDate.day == _selectedDate?.day;
                                });

                                return monthEvents.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final e = entry.value;
                                  final eventDate = DateFormat(
                                    'dd-MM-yyyy',
                                  ).parse(e.eDate!);
                                  final isToday =
                                      eventDate.day == _selectedDate?.day &&
                                      eventDate.month == _selectedDate?.month &&
                                      eventDate.year == _selectedDate?.year;
                                  return GestureDetector(
                                    key: index == todayIndex
                                        ? _todayEventKey
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = eventDate;
                                        _showAllEvents = false;
                                      });
                                    },
                                    child: _buildInfoCard(
                                      color: isToday
                                          ? CustomColor.primaryLight
                                          : Colors.white,
                                      title: e.eventName?.first.typeCode ?? '',
                                      children:
                                          e.eventName
                                              ?.map(
                                                (name) => _buildInfoRow(
                                                  name.eventDetails ?? '',
                                                ),
                                              )
                                              .toList() ??
                                          [],
                                      date: DateFormat.yMMMd().format(
                                        eventDate,
                                      ),
                                    ),
                                  );
                                }).toList();
                              }(),
                            ),
                          ),
                  ),

                if (!_showAllEvents)
                  (provider.isLoading
                      ? buildShimmerEvents()
                      : selectedEvents.isEmpty
                      ? _buildNoEvents()
                      : _buildInfoCard(
                          color: Colors.white,
                          title:
                              selectedEvents.first.eventName!.first.typeCode ??
                              '',
                          children: selectedEvents
                              .expand(
                                (e) => e.eventName!.map(
                                  (name) =>
                                      _buildInfoRow(name.eventDetails ?? ''),
                                ),
                              )
                              .toList(),
                          date: DateFormat.yMMMd().format(_selectedDate!),
                        )),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: CommonBottomSheetEmp(
        content: SizedBox.shrink(),
        onSessionChange: (from, to) async {
          setState(() {
            _toYear = int.parse(to);
            _fromYear = int.parse(from);

            _sessionStartYear = _fromYear;
            _sessionEndYear = _toYear;
            _focusedDate = DateTime(_fromYear, now.month, now.day);

            _selectedDate = DateTime(_fromYear, now.month, now.day);
            _showAllEvents = false;
          });

          await _fetchAcademicCalendar();
        },
      ),
    );
  }

  Widget buildCalendarCard(
    AcedemicCalandarProvider provider,
    List<dynamic> events,
  ) {
    final currentDate = DateTime.now();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorShadow.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMMMM().format(_focusedDate),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _goToPreviousMonth,
                    child: Icon(
                      Icons.arrow_left_rounded,
                      size: 30.sp,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToNextMonth,
                    child: Icon(
                      Icons.arrow_right_rounded,
                      size: 30.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
            ),
            children: [
              TableRow(
                children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                    .map(
                      (day) => Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.h),
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ..._buildCalendarRows(
                provider,
                _focusedDate,
                currentDate,
                events,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildCalendarRows(
    AcedemicCalandarProvider provider,
    DateTime month,
    DateTime currentDate,
    List<dynamic> events,
  ) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startingWeekday = (firstDayOfMonth.weekday % 7);
    final totalCells = daysInMonth + startingWeekday;
    final rows = <TableRow>[];

    List<Widget> currentRow = [];

    for (int i = 0; i < totalCells; i++) {
      if (i < startingWeekday) {
        currentRow.add(Container());
      } else {
        final day = i - startingWeekday + 1;
        final date = DateTime(month.year, month.month, day);

        final hasEvent = events.any((e) {
          final eventDate = DateTime.tryParse(e.eDate ?? "");
          return eventDate != null &&
              eventDate.year == date.year &&
              eventDate.month == date.month &&
              eventDate.day == date.day;
        });

        final isToday =
            date.year == currentDate.year &&
            date.month == currentDate.month &&
            date.day == currentDate.day;

        final isSelected =
            _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;

        Color? bgColor;
        Color textColor = Colors.black87;

        if (isSelected) {
          bgColor = CustomColor.primaryColor;
          textColor = CustomColor.colorWhite;
        } else if (hasEvent) {
          bgColor = Colors.green.shade400;
          textColor = CustomColor.colorWhite;
        } else if (isToday) {
          bgColor = Colors.blueAccent;
          textColor = CustomColor.colorWhite;
        }

        currentRow.add(
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              margin: EdgeInsets.all(3.w),
              height: 30.h,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        );

        if (currentRow.length == 7) {
          rows.add(TableRow(children: currentRow));
          currentRow = [];
        }
      }
    }
    if (currentRow.isNotEmpty) {
      while (currentRow.length < 7) {
        currentRow.add(Container());
      }
      rows.add(TableRow(children: currentRow));
    }

    return rows;
  }

  Widget _buildNoEvents() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Lottie.asset('assets/animation/no_data.json',
      //     width: 250, height: 150, repeat: true),
      Text(
        "No events on this date.",
        style: TextStyle(color: CustomColor.colorGrey, fontSize: 14.sp),
      ),
    ],
  );

  Widget _buildInfoCard({
    required Color color,
    required String title,
    required String date,
    required List<dynamic> children,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColor.primaryColor),
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorShadow.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_note_rounded,
                color: CustomColor.primaryColor,
                size: 36.sp,
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Text(
        ' • $text',
        style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
      ),
    );
  }
}

DateTime? parseDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return null;
  try {
    return DateFormat('dd-MM-yyyy').parse(rawDate);
  } catch (_) {
    return null;
  }
}
