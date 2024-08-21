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

String formatErrorMessage(String error) {
  if (error.contains('400')) {
    return 'Некорректные данные. Пожалуйста, проверьте введенную информацию.';
  } else if (error.contains('timeout')) {
    return 'Сервер не отвечает. Попробуйте позже.';
  } else if (error.contains('Network Error')) {
    return 'Проблемы с соединением. Проверьте интернет-соединение.';
  } else if (error.contains('500')) {
    return 'Ошибка на сервере. Попробуйте позже.';
  } else {
    return 'Произошла ошибка. Пожалуйста, попробуйте еще раз.';
  }
}
