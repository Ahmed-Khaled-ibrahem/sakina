import 'package:intl/intl.dart';


String convertTo12Hour(String time24, String locale) {
  try {
    // Parse input time (24-hour format)
    final dateTime = DateFormat("HH:mm").parse(time24);

    // Format based on locale (Arabic or English)
    if (locale.startsWith('ar')) {
      // Arabic format (e.g., "٠٥:٣٠ م")
      return DateFormat("hh:mm a", 'ar').format(dateTime);
    } else {
      // English format (e.g., "05:30 PM")
      return DateFormat("hh:mm a", 'en').format(dateTime).toUpperCase();
    }
  } catch (e) {
    return "Invalid time format";
  }
}