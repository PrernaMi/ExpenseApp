import 'expense_model.dart';

class FilterExpenseModel {
  num amount;
  String date;
  List<ExpenseModel> allExp;

  FilterExpenseModel(
      {required this.date, required this.amount, required this.allExp});
}
