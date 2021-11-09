import 'package:intl/intl.dart';

var oCcy = NumberFormat.currency(locale: 'HI');

final oC = new NumberFormat("#,##,##,###", "en_IN");

class Utils {
  static formatPrice(double price) => '${oCcy.format(price)}';
  static formatExpense(int price) => '${oC.format(price)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
