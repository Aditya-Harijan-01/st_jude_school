import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';

String parseHtmlString(String htmlString) {
  final document = html_parser.parse(htmlString);
  return document.body?.text ?? "";
}

String formatDate(String originalDate) {
  try {
    // Input format: "05/08/2024, 05:35 PM"
    final inputFormat = DateFormat("dd/MM/yyyy");
    final dateTime = inputFormat.parse(originalDate);

    // Output format: "05 Aug, 05:35 pm"
    final outputFormat = DateFormat("dd MMM, yyyy");
    return outputFormat.format(dateTime);
  } catch (e) {
    return originalDate; // fallback in case of error
  }
}