// Package imports:
import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy/MM/dd');
    return formatter.format(date);
  }
}
