import 'dart:developer';

class PaymentDateUtils {
  static String formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';

    try {
      DateTime dateTime;

      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          dateTime = DateTime(year, month, day);
        } else {
          return dateString;
        }
      } else {
        dateTime = DateTime.parse(dateString);
      }

      return '${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.year}';
    } catch (e) {
      log('error $e');
      return dateString;
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  /// Cleans and normalizes URL strings by:
  /// - Removing double slashes (//)
  /// - Replacing backslashes (\) with forward slashes (/)
  /// - Trimming whitespace
  static String cleanUrl(String url) {
    if (url.isEmpty) return url;
    
    try {
      // Replace backslashes with forward slashes
      String cleanedUrl = url.replaceAll('\\', '/');
      
      // Remove double slashes but preserve protocol (http://, https://)
      cleanedUrl = cleanedUrl.replaceAllMapped(
        RegExp(r'(?<!:)//'),
        (match) => '/'
      );
      
      // Trim whitespace
      cleanedUrl = cleanedUrl.trim();
      log(cleanedUrl);
      return cleanedUrl;
    } catch (e) {
      log('Error cleaning URL: $e');
      return url; // Return original URL if cleaning fails
    }
  }
}