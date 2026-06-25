import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/student/get_session.dart';
import '../../../providers/auth_provider/auth_provider.dart';

class DuplicateSessionDropdown extends StatefulWidget {
  /// Called whenever a new session is selected
  /// Provides: fromYear, toYear
  final Future<void> Function(String fromYear, String toYear) onDuplicateSessionChanged;
  final bool disable;

  /// Optional: controls margin or style overrides
  const DuplicateSessionDropdown({
    super.key,
    required this.onDuplicateSessionChanged,
    required this.disable,
  });

  @override
  State<DuplicateSessionDropdown> createState() => _DuplicateSessionDropdownState();
}

class _DuplicateSessionDropdownState extends State<DuplicateSessionDropdown> {
  String? selectedFromYear;
  String? selectedToYear;

  @override
  void initState() {
    super.initState();
    _setDefaultSession();
  }

  void _setDefaultSession() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      selectedFromYear = auth.loginData?.currentyearfrom;
      selectedToYear = auth.loginData?.currentyearto;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessProvider = Provider.of<SessionProvider>(context);
    

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: CustomColor.colorSession,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width:2, color: CustomColor.colorSessionBorder ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          dropdownColor: CustomColor.colorWhite,
          menuMaxHeight: 250,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
          value: selectedFromYear != null && selectedToYear != null
              ? "$selectedFromYear-$selectedToYear"
              : null,
          hint: Text(
            "Select Year",
            style: TextStyle(
              color: CustomColor.primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          selectedItemBuilder: (context) {
            return sessProvider.sessionData2?.map((session) {
              String label = "${session.fromYear}-${session.toYear}";
              return Text(
                label,
                style: TextStyle(
                  color: CustomColor.colorWhite, // Selected color
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList() ?? [];
          },
          items: sessProvider.sessionData2?.map((session) {
                String label = "${session.fromYear}-${session.toYear}";
                return DropdownMenuItem<String>(
                  value: label,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: CustomColor.primaryOne,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList() ??
              [],
          onChanged: !widget.disable ? null : (value) async {
            if (value == null) return;
            final parts = value.split('-');
            if (parts.length == 2) {
              final newFrom = parts[0];
              final newTo = parts[1];
              setState(() {
                selectedFromYear = newFrom;
                selectedToYear = newTo;
              });

              await widget.onDuplicateSessionChanged(newFrom, newTo);
            }
          },
        ),
      ),
    );
  }
}
