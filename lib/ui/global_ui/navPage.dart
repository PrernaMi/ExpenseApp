import 'package:expanses_task11/bloc/bloc_expense.dart';
import 'package:expanses_task11/bloc/bloc_states.dart';
import 'package:expanses_task11/start_screens/log_out.dart';
import 'package:expanses_task11/ui/expenses_add/add_expense.dart';
import 'package:expanses_task11/ui/global_ui/expense_graph.dart';
import 'package:expanses_task11/ui/global_ui/setting_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashBoard_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/color_constant.dart';

class NavPage extends StatefulWidget{
  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  List<Widget> navPages = [
    DashBoardPage(),
    SettingPage(),
  ];
  double balance = 0;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navPages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_filled,color: ColorConstant.colors[0],size: 30,), label: "Home"),
          NavigationDestination(icon: Icon(Icons.settings,size: 30,color: Colors.grey.shade400,), label: "Settings"),
        ],
        onDestinationSelected: (val){
          selectedIndex = val;
          setState(() {

          });
        },
      ),
      // floatingActionButton: BlocBuilder<ExpenseBloc,ExBlocState>(
      //   builder: (_,mState) {
      //     if (mState is LoadingState) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (mState is ErrorState) {
      //       return Center(
      //         child: Text("Error is: ${mState.errorMsg}"),
      //       );
      //     } else if(mState is LoadedState){
      //       var allExpense = mState.mExp;
      //       return FloatingActionButton(onPressed: (){
      //         Navigator.push(context, MaterialPageRoute(builder: (context){
      //           return AddExpense(balanceTillNow: allExpense.last.eBal,);
      //         }));
      //       },
      //         backgroundColor: ColorConstant.colors[0],
      //         child: Icon(Icons.add,size:30,color: Colors.white,),
      //       );
      //     }
      //     return Container();
      //   }
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}