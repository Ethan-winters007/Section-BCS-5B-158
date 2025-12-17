import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final f = NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ');
  return f.format(value);
}
