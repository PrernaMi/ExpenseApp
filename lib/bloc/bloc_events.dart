import 'package:expanses_task11/models/expense_model.dart';

abstract class ExBlocEvents{}

class AddExpBloc extends ExBlocEvents{
  ExpenseModel newExp;
  AddExpBloc({required this.newExp});
}
class GetExBloc extends ExBlocEvents{}