import 'package:expanses_task11/bloc/bloc_events.dart';
import 'package:expanses_task11/bloc/bloc_expense.dart';
import 'package:expanses_task11/data/local/db_helper.dart';
import 'package:expanses_task11/models/expense_model.dart';
import 'package:expanses_task11/widgets/custom_text_field.dart';
import 'package:expanses_task11/widgets/icon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  double balanceTillNow;

  AddExpense({required this.balanceTillNow});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  TextEditingController amtController = TextEditingController();

  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();
  int selectedCategory = -1;
  String selectedMenu = "Debit";
  bool menuItemCheck = false;
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat.yMMMEd();
  bool isButtonEnabled = false;
  String errorMsg = "";
  List<String> menuTypeList = [
    "Debit",
    "Credit",
    "Loan",
    "Borrow",
  ];

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Add Your Expenses")),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? SingleChildScrollView(child: mainUI(isLandScape: false))
            : SingleChildScrollView(child: mainUI(isLandScape: true)),
      ),
    );
  }

  Widget mainUI({required bool isLandScape}) {
    if (isLandScape) {
      return Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    "Add Your Expenses",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Image.asset(
                    "assets/splash_img/non_tracking_expenses-removebg-preview.png",
                    fit: BoxFit.cover,
                  )
                ],
              )),
          Expanded(
            flex: 2,
            child: mainUICol(),
          ),
        ],
      );
    } else {
      return mainUICol();
    }
  }

  Widget mainUICol() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*---------Title--------*/
        CustomTextField(
          keyBoardType: TextInputType.text,
          mLabel: "Title",
          fieldWidth: double.infinity,
          mPrefixIcon: Icons.add_circle_outline,
          mController: titleController,
          mRadius: 12,
          mHint: "Enter your title",
        ),
        SizedBox(
          height: 7,
        ),
        /*---------Desc--------*/
        CustomTextField(
            keyBoardType: TextInputType.text,
            mLabel: "Description",
            fieldWidth: double.infinity,
            mPrefixIcon: Icons.description,
            mController: descController,
            mRadius: 12,
            mHint: "Enter your Description"),
        SizedBox(
          height: 7,
        ),
        /*---------Amount--------*/
        CustomTextField(
            keyBoardType: TextInputType.number,
            mLabel: "Expense",
            fieldWidth: double.infinity,
            mPrefixIcon: Icons.currency_rupee,
            mController: amtController,
            mRadius: 12,
            mHint: "Enter your Expense"),
        SizedBox(
          height: 7,
        ),
        /*---------Category--------*/
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return GridView.builder(
                          itemCount: IconList.mListCategory.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1 / 2,
                                  crossAxisSpacing: 11,
                                  mainAxisSpacing: 11,
                                  crossAxisCount: 4),
                          itemBuilder: (_, Index) {
                            return InkWell(
                              onTap: () {
                                selectedCategory =
                                    IconList.mListCategory[Index][IconList.img_id];
                                errorMsg = "";
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: Column(
                                  children: [
                                    Image.asset(IconList.mListCategory[Index]
                                        [IconList.img_path]),
                                    Text(
                                      IconList.mListCategory[Index][IconList.img_name],
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    });
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: selectedCategory == -1
                  ? Text("Select Category")
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Image.asset(
                            IconList.mListCategory[selectedCategory - 1]
                                [IconList.img_path],
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Text(
                          IconList.mListCategory[selectedCategory - 1]
                              [IconList.img_name],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
        ),
        SizedBox(
          height: 7,
        ),
        /*---------Expense Type--------*/
        DropdownMenu(
          inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          )),
          width: MediaQuery.of(context).size.width - 20,
          initialSelection: selectedMenu,
          onSelected: (value) {
            selectedMenu = value!;
            setState(() {});
          },
          dropdownMenuEntries: menuTypeList
              .map((eachType) =>
                  DropdownMenuEntry(value: eachType, label: eachType))
              .toList(),
        ),
        SizedBox(
          height: 7,
        ),
        /*---------Time--------*/
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now());
              setState(() {});
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(width: 2)),
            ),
            child: Text(df
                .format(selectedDate == null ? DateTime.now() : selectedDate!)),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        /*---------Button--------*/
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              DbHelper db = DbHelper.getInstance;
              String title = titleController.text.toString();
              String desc = descController.text.toString();
              String exp = amtController.text.toString();

              if (title.isNotEmpty && desc.isNotEmpty && exp.isNotEmpty) {
                //we will add all things if category will selected
                if (selectedCategory != -1) {
                  //we will add all details in Db

                  double amt = double.parse(amtController.text.toString());
                  double bal = widget.balanceTillNow;
                  if (selectedMenu == 'Debit') {
                    bal -= amt;
                  } else {
                    bal += amt;
                  }
                  int uid = await db.getUid();
                  context.read<ExpenseBloc>().add(AddExpBloc(
                      newExp: ExpenseModel(
                          uid: uid,
                          eTitle: titleController.text.toString(),
                          eTime:
                              selectedDate!.millisecondsSinceEpoch.toString(),
                          eAmt: amt,
                          eCatId: selectedCategory,
                          eDesc: descController.text.toString(),
                          eType: selectedMenu == 'Debit' ? 0 : 1,
                          eBal: bal)));
                  Navigator.pop(context);
                } else {
                  errorMsg = "Please choose any valid category";
                  setState(() {});
                }
              } else {
                errorMsg = "Please fill all required fields!!!";
                setState(() {});
              }
            },
            child: Text("Add Expense"),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        /*---------Error Message--------*/
        Text(
          errorMsg,
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}
