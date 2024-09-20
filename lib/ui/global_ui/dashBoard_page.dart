import 'package:expanses_task11/bloc/bloc_events.dart';
import 'package:expanses_task11/bloc/bloc_expense.dart';
import 'package:expanses_task11/bloc/bloc_states.dart';
import 'package:expanses_task11/data/local/db_helper.dart';
import 'package:expanses_task11/start_screens/log_out.dart';
import 'package:expanses_task11/ui/expenses_add/add_expense.dart';
import 'package:expanses_task11/ui/global_ui/expense_graph.dart';
import 'package:expanses_task11/widgets/icon_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/expense_model.dart';
import '../../models/filter_expense_model.dart';
import '../../widgets/color_constant.dart';

class DashBoardPage extends StatefulWidget {
  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  MediaQueryData? mqData;
  SharedPreferences? prefs;
  double balance = 0.0;

  bool isCat = false;
  String? userEmail;
  String? userName;

  DateFormat filteredDf = DateFormat.MMMMEEEEd();
  DateFormat monthDf = DateFormat.yMMM();
  DateFormat yearDf = DateFormat.y();

  List<FilterExpenseModel> allFilteredExp = [];
  List<Object> allFilteredList = ["Month", "Year", "Date", "Category"];

  String selectedType = "Date";
  double totalAmt = 0;
  bool isLight = false;
  // bool isPortrait = false;

  @override
  void initState() {
    findProfileInfo();
    context.read<ExpenseBloc>().add(GetExBloc());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    //globally declare to avoid redundancy
    // isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLight ? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: isLight ? Colors.white : Colors.black,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                size: 30,
              ))
        ],
      ),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20.0),
          child: Column(
            children: [
              /*-----Profile------*/
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.account_circle),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('${userEmail}'), Text('${userName}')],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              /*-----Setting------*/
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 30,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Settings"),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              /*-----Logout------*/
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Logout();
                  }));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExBlocState>(builder: (_, state) {
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ErrorState) {
          return Center(
            child: Text("Error is: ${state.errorMsg}"),
          );
        } else if (state is LoadedState) {
          var allExpenses = state.mExp;
          // balance = state.mExp.last.eBal;
          totalAmt = allExpenses.length == 0 ? 0 : allExpenses.last.eBal;
          filterExpDateWise(allExpenses, isCat);
          return MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [profileUI(isLanScape: false), listUI(allExpenses)],
                )
          //When Screen will be in landscape mode we will divide
          //UI part in two field first is only for profile and
          //another for List
              : Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.4,
                        child: profileUI(isLanScape: true)),
                    listUI(allExpenses)
                  ],
                );
        }
        return Container();
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return AddExpense(balanceTillNow: totalAmt);
        }));
      },
        backgroundColor: ColorConstant.colors[0].withOpacity(0.2),
        child: Icon(Icons.add,size:30,color: Colors.white,),
      ),
    );
  }

  Widget listUI(List<ExpenseModel> allExpenses) {
    return Expanded(
      child: Column(
        children: [
          /*-------------------Expense List Name------------------*/
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transaction",
                  style: TextStyle(
                      color: isLight ? Colors.black : Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ExpBarGraph(
                          allFilteredExp: allFilteredExp,
                          filterdName: selectedType);
                    }));
                  },
                  child: Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                        child: Text(
                      "View Graph",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    )),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          /*-------------------UI Content------------------*/
          allExpenses.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allFilteredExp.length,
                      itemBuilder: (_, Index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(allFilteredExp[Index].date,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isLight
                                                  ? Colors.black
                                                  : Colors.white)),
                                      Text("\$${allFilteredExp[Index].amount}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isLight
                                                ? Colors.black
                                                : Colors.white,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Container(
                                      height: 2,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey.shade400,
                                                  width: 1))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          allFilteredExp[Index].allExp.length,
                                      itemBuilder: (_, childIndex) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1),
                                          child: ListTile(
                                            leading: Image.asset(
                                              IconList.mListCategory[
                                                  allFilteredExp[Index]
                                                          .allExp[
                                                              childIndex]
                                                          .eCatId -
                                                      1]['img_path'],
                                              height: 35,
                                            ),
                                            title: Text(
                                              allFilteredExp[Index]
                                                  .allExp[childIndex]
                                                  .eTitle,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              allFilteredExp[Index]
                                                  .allExp[childIndex]
                                                  .eDesc,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 0),
                                            trailing: Text(
                                              "\$${allFilteredExp[Index].allExp[childIndex].eAmt}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: allFilteredExp[Index]
                                                              .allExp[
                                                                  childIndex]
                                                              .eType ==
                                                          0
                                                      ? ColorConstant.colors[0]
                                                      : ColorConstant.colors[5],
                                                  fontSize: 14),
                                            ),
                                          ),
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/icon/empty_logo.png",
                        color: CupertinoColors.systemGrey2,
                        height: 200,
                      ),
                    ),
                    Center(
                      child: Text(
                        "No Expenses Yet!!!",
                        style: TextStyle(
                            color: CupertinoColors.systemGrey2,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  Widget expenseTotal({required bool isLandScape}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        // height: 130, //instead of giving fixed height we will use mediaQuery
        height: MediaQuery.of(context).size.height*0.13,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorConstant.colors[1],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: isLandScape ?EdgeInsets.symmetric(horizontal: 15,vertical: 10) :EdgeInsets.symmetric(horizontal: 10,),
          child: Row(
            mainAxisAlignment: isLandScape ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Expense total",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "\$ ${totalAmt}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 20,
                            width: 50,
                            decoration: BoxDecoration(
                                color: ColorConstant.colors[4],
                                borderRadius: BorderRadius.circular(3)),
                          ),
                          Positioned(
                              top: 2,
                              left: 4,
                              child: Center(
                                  child: Text(
                                "+\$340",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11),
                              )))
                        ],
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        "then last month",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7), fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
              isLandScape? Container():SizedBox(
                height: 70,
                child: Image.asset(
                  "assets/images/Box_image.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileUI({required bool isLanScape}) {
    return isLanScape ? Column(
      children: [
        /*-------------------Profile------------------*/
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1),
          child: ListTile(
            title: Text(
              "Morning",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/images/contact_avatar.png"),
            ),
            subtitle: Text(
              "${userName}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: DropdownButton(
              dropdownColor: isLight ? Colors.white : Colors.black,
              style: TextStyle(color: isLight ? Colors.black : Colors.white),
              value: selectedType,
              items: allFilteredList
                  .map((eachValue) => DropdownMenuItem(
                        value: eachValue,
                        child: Text(eachValue.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedType = value.toString();
                if (selectedType == "Category") {
                  isCat = true;
                } else {
                  isCat = false;
                }
                setState(() {});
              },
            ),
          ),
        ),
        /*-------------------Expense Total------------------*/
        MediaQuery.of(context).orientation == Orientation.portrait
            ? expenseTotal(isLandScape: false)
            : Expanded(child: expenseTotal(isLandScape: true)),
      ],
    ) : Column(
      children: [
        /*-------------------Profile------------------*/
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListTile(
            title: Text(
              "Morning",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage("assets/images/contact_avatar.png"),
            ),
            subtitle: Text(
              "${userName}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: DropdownButton(
              dropdownColor: isLight ? Colors.white : Colors.black,
              style: TextStyle(color: isLight ? Colors.black : Colors.white),
              value: selectedType,
              items: allFilteredList
                  .map((eachValue) => DropdownMenuItem(
                value: eachValue,
                child: Text(eachValue.toString()),
              ))
                  .toList(),
              onChanged: (value) {
                selectedType = value.toString();
                if (selectedType == "Category") {
                  isCat = true;
                } else {
                  isCat = false;
                }
                setState(() {});
              },
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        /*-------------------Expense Total------------------*/
        MediaQuery.of(context).orientation == Orientation.portrait
            ? expenseTotal(isLandScape: false)
            : Expanded(child: expenseTotal(isLandScape: true)),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void findProfileInfo() async {
    var db = DbHelper.getInstance;
    List<String> name = await db.getUserDetails();
    userName = name[0];
    userEmail = name[1];
    setState(() {});
  }

  void filterExpDateWise(List<ExpenseModel> allExpenses, bool isCat) {
    allFilteredExp.clear();
    if (isCat) {
      var uniqueCategory = IconList.mListCategory;

      for (int i = 0; i < IconList.mListCategory.length; i++) {
        int id = uniqueCategory[i][IconList.img_id];
        num amt = 0;

        List<ExpenseModel> uniqueExp = [];
        for (ExpenseModel eachExp in allExpenses) {
          int expCatId = eachExp.eCatId;
          if (expCatId == id) {
            uniqueExp.add(eachExp);
            if (eachExp.eType == 0) {
              amt -= eachExp.eAmt;
            } else {
              amt += eachExp.eAmt;
            }
          }
        }

        if (uniqueExp.isNotEmpty)
          allFilteredExp.add(FilterExpenseModel(
              date: uniqueCategory[i][IconList.img_name],
              amount: amt,
              allExp: uniqueExp));
      }
    } else {
      var uniqueDates = [];
      for (ExpenseModel eachExp in allExpenses) {
        var date = "";
        if (selectedType == "Date") {
          date = filteredDf.format(
              DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.eTime)));
        } else if (selectedType == "Month") {
          date = monthDf.format(
              DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.eTime)));
        } else {
          date = yearDf.format(
              DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.eTime)));
        }
        if (!uniqueDates.contains(date)) {
          uniqueDates.add(date);
        }
      }

      for (String eachDateInUniqueDates in uniqueDates) {
        List<ExpenseModel> allExpOfUniqueDate = [];
        num amt = 0;
        //this loop will add All expense of same date
        for (ExpenseModel eachExp in allExpenses) {
          var date = "";
          if (selectedType == "Date") {
            date = filteredDf.format(
                DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.eTime)));
          } else if (selectedType == "Month") {
            date = monthDf.format(
                DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.eTime)));
          } else {
            date = yearDf.format(
                DateTime.fromMillisecondsSinceEpoch(int.parse(eachExp.eTime)));
          }
          if (date == eachDateInUniqueDates) {
            allExpOfUniqueDate.add(eachExp);
            if (eachExp.eType == 0) {
              amt -= eachExp.eAmt;
            } else if (eachExp.eType == 1) {
              amt += eachExp.eAmt;
            }
          }
        }
        allFilteredExp.add(FilterExpenseModel(
            date: eachDateInUniqueDates,
            amount: amt,
            allExp: allExpOfUniqueDate));
      }
    }
  }

}