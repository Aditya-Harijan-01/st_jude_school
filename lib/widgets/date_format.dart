import 'package:intl/intl.dart';

String formatDate(String originalDate) {
    try {
      if (originalDate == "" || originalDate.isEmpty) return '--/--/----';
      // Input format: "05/08/2024, 05:35 PM"
      final inputFormat = DateFormat("dd/MM/yyyy, hh:mm a");
      final dateTime = inputFormat.parse(originalDate);

      // Output format: "05 Aug, 05:35 pm"
      final outputFormat = DateFormat("dd MMM, hh:mm a");
      return outputFormat.format(dateTime);
    } catch (e) {
      return originalDate; // fallback in case of error
    }
  }