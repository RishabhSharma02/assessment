import 'package:intl/intl.dart';

String formatNumber(int number) {
  if (number >= 1000 && number < 1000000) {
    String result = '${(number / 1000).toStringAsFixed(1)}k';
    return result.length > 34 ? result.substring(0, 34) : result;
  } else if (number >= 1000000 && number < 1000000000) {
    String result = '${(number / 1000000).toStringAsFixed(1)}m';
    return result.length > 34 ? result.substring(0, 34) : result;
  } else if (number >= 1000000000) {
    String result = '${(number / 1000000000).toStringAsFixed(1)}b';
    return result.length > 34 ? result.substring(0, 34) : result;
  } else {
    String result = number.toString();
    return result.length > 34 ? result.substring(0, 34) : result;
  }

}
String convertKgRangeToTon(String input) {
  // Split the input string by " - " to separate the kilograms values
  List<String> parts = input.split("-");

  // Extract kg values from parts
  String kg1String = parts[0].replaceAll("Kg", " ");
  String kg2String = parts[1].replaceAll("kg", " ");

  // Parse kg values into doubles
  double kg1 = double.parse(kg1String);
  double kg2 = double.parse(kg2String);

  // Convert to tons if necessary
  String result;
  if (kg1 >= 1000 && kg2 >= 1000) {
    double ton1 = kg1 / 1000;
    double ton2 = kg2 / 1000;
    result = '${ton1.toStringAsFixed(1)} tons - ${ton2.toStringAsFixed(1)} tons';
  } else {
    result = '${kg1.toInt()} Kg - ${kg2.toInt()} kg';
  }

  return result;
}
String formatDate(String date) {
  DateTime convertedDate=DateTime.parse(date);
  return DateFormat('dd/MM/yyyy').format(convertedDate);
}