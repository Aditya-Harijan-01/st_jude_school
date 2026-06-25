import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/common_Session.dart';
import '../../../providers/student/timetable.dart';
import 'bottom_calendar_widget.dart';
import 'widgets/loader.dart';
import 'widgets/timetable_cards.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedFromYear = '';
  String selectedToYear = '';

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    selectedFromYear =
        auth.loginData?.currentyearfrom ?? DateTime.now().year.toString();
    selectedToYear =
        auth.loginData?.currentyearto ?? (DateTime.now().year + 1).toString();
    selectedDate = _clampToSession(selectedDate, selectedFromYear, selectedToYear);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchTimetable());
  }

  DateTime _clampToSession(DateTime day, String fromYear, String toYear) {
    final from = int.tryParse(fromYear) ?? day.year;
    final to = int.tryParse(toYear) ?? (from + 1);
    final firstDay = DateTime(from, 4, 1);
    final fallbackLast = DateTime(from + 1, 3, 31);
    final lastDay = DateTime(to, 3, 31);
    final safeLastDay = firstDay.isAfter(lastDay) ? fallbackLast : lastDay;

    final normalized = DateTime(day.year, day.month, day.day);
    if (normalized.isBefore(firstDay)) return firstDay;
    if (normalized.isAfter(safeLastDay)) return safeLastDay;
    return normalized;
  }

  Future<void> _fetchTimetable({
    String? fromYear,
    String? toYear,
    DateTime? day,
  }) async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final provider = Provider.of<TimetableProvider>(context, listen: false);
      final loginData = auth.loginData;
      if (loginData == null) return;

      final from = (fromYear != null && fromYear.trim().isNotEmpty)
          ? fromYear
          : (selectedFromYear.isNotEmpty
              ? selectedFromYear
              : loginData.currentyearfrom);
      final to = (toYear != null && toYear.trim().isNotEmpty)
          ? toYear
          : (selectedToYear.isNotEmpty ? selectedToYear : loginData.currentyearto);
      final safeDate = _clampToSession(day ?? selectedDate, from, to);

      if (mounted) {
        setState(() {
          selectedFromYear = from;
          selectedToYear = to;
          selectedDate = safeDate;
        });
      }

      await provider.getTimetableDetails(
        safeDate.toIso8601String(),
        loginData.regno,
        from,
        to,
      );
    } catch (e, s) {
      log('Error fetching timetable: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimetableProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomColor.colorWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Timetable',
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          SessionDropdown(
            onSessionChanged: (from, to) async {
              await _fetchTimetable(fromYear: from, toYear: to);
            },
            // fYear: selectedFromYear!,
            // tYear: selectedToYear!, 
            disable: true,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              child: provider.isLoading
                  ? TimetableCardShimmer()
                  : provider.timetableData == null ||
                          provider.timetableData!.isEmpty
                      ? const Center(child: Text("No timetable available"))
                      : _buildTimetableList(provider),
            ),
          ),
          BottomCalendarWidget(
            selectedDate: selectedDate,
            onDateSelected: (date) async {
              await _fetchTimetable(day: date);
            },
            fromYear: selectedFromYear.isNotEmpty
                ? selectedFromYear
                : DateTime.now().year.toString(),
            toYear: selectedToYear.isNotEmpty
                ? selectedToYear
                : (DateTime.now().year + 1).toString(),
          ),
        ],
      ),
    );
  }

  ///   Build Timetable ListView dynamically from API data
  Widget _buildTimetableList(TimetableProvider provider) {
    final groupedByPeriod = <String, List<dynamic>>{};

    // Group by period (e.g. Period-1, Period-2)
    for (var entry in provider.timetableData!) {
      groupedByPeriod.putIfAbsent(entry.period, () => []).add(entry);
    }

    final periods = groupedByPeriod.keys.toList();

    return ListView.builder(
      itemCount: periods.length,
      itemBuilder: (context, index) {
        final period = periods[index];
        final items = groupedByPeriod[period]!;

        final timetableItems = items.map((e) {
          return TimetableItem(
            subjectName: e.subject,
            teacher: e.teacher,
            img: e.teacherImage,
            time: e.periodTime ?? 'N/A', // optional field
            room: e.roomNo ?? '',
          );
        }).toList();

        return TimetableCards(period: period, items: timetableItems);
      },
    );
  }
}
