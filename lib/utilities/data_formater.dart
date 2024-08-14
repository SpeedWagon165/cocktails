import 'package:easy_localization/easy_localization.dart';

String formatDate(String date) {
  // Преобразование из 'dd.MM.yyyy' в 'yyyy-MM-dd'
  final parsedDate = DateFormat('dd.MM.yyyy').parse(date);
  return DateFormat('yyyy-MM-dd').format(parsedDate);
}

String formatPhoneNumber(String phoneNumber) {
  // Удаляем все символы, кроме цифр
  return phoneNumber.replaceAll(RegExp(r'\D'), '');
}
