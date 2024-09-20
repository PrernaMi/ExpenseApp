import 'package:expanses_task11/bloc/bloc_events.dart';
import 'package:expanses_task11/bloc/bloc_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/local/db_helper.dart';

class ExpenseBloc extends Bloc<ExBlocEvents, ExBlocState> {
  DbHelper mainDb;

  ExpenseBloc({required this.mainDb}) : super(InitialState()) {
    on<AddExpBloc>((event, emit) async {
      emit(LoadingState());
      bool check = await mainDb.addExpenseDb(event.newExp);
      if (check) {
        var exp = await mainDb.getExpensesDb();
        emit(LoadedState(mExp: exp));
      } else {
        emit(ErrorState(errorMsg: "No Expense Added"));
      }
    });

    on<GetExBloc>((event, emit) async {
      emit(LoadingState());
      var exp = await mainDb.getExpensesDb();
      emit(LoadedState(mExp: exp));
    });
  }
}
