import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  /// Get the start of the day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of the day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Format the date as a string in 'yyyy-MM-dd' format
  String get formattedDate =>
      "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Add days to the date
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days from the date
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Get the age based on the date
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Get the difference in days between two dates
  int differenceInDays(DateTime otherDate) =>
      (otherDate.difference(this).inHours / 24).round();

  String format(String pattern) => DateFormat(pattern).format(this);

  String get dMY => format('d MMM, yyyy');

  String get fullDate => format('EEEE, d MMMM, yyyy');

  String get shortDate => format('dd/MM/yyyy');

  String get longDate => format('dd MMMM, yyyy');

  String get isoDate => format('dd-MM-yyyy');

  String get monthYear => format('MMMM yyyy');

  String get shortMonthYear => format('MMM yyyy');

  String get dayMonth => format('d MMMM');

  String get shortDayMonth => format('d MMM');

  String get hourMinute => format('HH:mm');

  String get hourMinute12Hour => format('hh:mm a');

  String get fullDateTime => format('EEEE, d MMMM, yyyy HH:mm:ss');

  String get fullDateTime12Hour => format('EEEE, d MMMM, yyyy hh:mm:ss a');

  Timestamp toTimestamp() {
    return Timestamp.fromDate(this);
  }
}
