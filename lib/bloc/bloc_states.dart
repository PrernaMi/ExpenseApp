import '../models/expense_model.dart';

abstract class ExBlocState {}

class InitialState extends ExBlocState{}
class LoadingState extends ExBlocState{}
class LoadedState extends ExBlocState{
  List<ExpenseModel> mExp = [];
  LoadedState({required this.mExp});
}
class ErrorState extends ExBlocState{
  String errorMsg;
  ErrorState({required this.errorMsg});
}
