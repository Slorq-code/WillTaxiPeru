import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  static final DateFormat _dateFormatHHmm = DateFormat('HH:mm');

  String formatHHmm() => _dateFormatHHmm.format(this);
}
