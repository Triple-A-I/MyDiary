import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatDateFromTimeStamp(Timestamp timeStamp) {
  return DateFormat.yMMMd().add_EEEE().format(timeStamp.toDate());
}

String formatDateFromTimeStampHour(Timestamp timeStamp) {
  return DateFormat.jm().format(timeStamp.toDate());
}
