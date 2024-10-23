import 'dart:io';
import 'package:expanses_task11/models/expense_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/user_model.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper getInstance = DbHelper._();
  Database? mainDb;
  SharedPreferences? prefs;

  //tables
  static String Table_user = 'user';
  static String Table_Expense = 'expense';

  //User tables column
  static String User_Id = 'uid';
  static String User_fname = 'fname';
  static String User_lname = 'lname';
  static String User_email = 'email';
  static String User_phone = 'phone';
  static String User_pass = 'pass';

  //Expense tables column
  //we have to add uid as fk here
  static String Exp_Id = 'eid';
  static String Exp_title = 'title';
  static String Exp_desc = 'desc';
  static String Exp_Amt = 'amt';
  static String Exp_Cat = 'cat';
  static String Exp_Type = 'type';
  static String Exp_Time = 'time';
  static String Exp_Bal = 'bal';

  static String Prefs_uid = 'uid';

  Future<Database> getDb() async {
    mainDb ??= await openDb();
    return mainDb!;
  }

  Future<Database> openDb() async {
    Directory myDirectory = await getApplicationDocumentsDirectory();
    String myPath = myDirectory.path;
    String rootPath = join(myPath, 'expense.db');

    return openDatabase(rootPath, version: 1, onCreate: (db, version) {
      db.rawQuery('''create table $Table_user ( 
      $User_Id integer primary key autoincrement ,
      $User_fname text,
      $User_lname text,
      $User_email text unique,
      $User_phone integer,
      $User_pass text
      )''');

      db.rawQuery('''create table $Table_Expense ( 
      $Exp_Id integer primary key autoincrement,
      $User_Id integer,
      $Exp_title text,
      $Exp_desc text,
      $Exp_Amt real,
      $Exp_Type integer,
      $Exp_Cat integer, 
      $Exp_Time text,
      $Exp_Bal real
      )''');
    });
  }

  //User Queries
  //sign up only if user not exist
  Future<bool> signUp(UserModel newModel) async {
    var db = await getDb();
    bool check = await checkIfEmailExist(newModel.email);
    bool rowsEffected = false;
    if (!check) {
      int count = await db.insert(Table_user, newModel.toMap());
      rowsEffected = count > 0;
    }
    return rowsEffected;
  }

  Future<bool> checkIfEmailExist(String email) async {
    var db = await getDb();
    var data = await db
        .query(Table_user, where: '$User_email = ?', whereArgs: [email]);
    return data.isNotEmpty;
  }

  //login--> id user is valid move to home page
  Future<bool> checkAuthenticate(String email, String pass) async {
    var db = await getDb();
    var data = await db.query(Table_user,
        where: '$User_email = ? and $User_pass = ?', whereArgs: [email, pass]);
    if (data.isNotEmpty) {
      setUId(UserModel.fromMap(data[0]).uid!);
    }
    return data.isNotEmpty;
  }

  void setUId(int uid) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setInt(Prefs_uid, uid);
  }

  Future<int> getUid() async {
    prefs = await SharedPreferences.getInstance();
    int uid = prefs!.getInt(Prefs_uid)!;
    return uid;
  }

  Future<List<String>> getUserDetails() async {
    var db = await getDb();
    int uid = await getUid();
    var data =
        await db.query(Table_user, where: '$User_Id = ?', whereArgs: ['$uid']);
    String fname = UserModel.fromMap(data[0]).fname;
    String lname = UserModel.fromMap(data[0]).lname;
    String email = UserModel.fromMap(data[0]).email;
    List<String> mList = [];
    //0--> name
    mList.add("${fname} ${lname}");
    //1--> email
    mList.add(email);
    return mList;
  }

  //Expense Queries

  Future<bool> addExpenseDb(ExpenseModel newExp) async {
    var db = await getDb();
    int count = await db.insert(Table_Expense, newExp.toMap());
    return count > 0;
  }

  Future<List<ExpenseModel>> getExpensesDb() async {
    var db = await getDb();
    int uid = await getUid();
    List<Map<String, dynamic>> exp = await db
        .query(Table_Expense, where: '$User_Id = ?', whereArgs: ['$uid']);
    List<ExpenseModel> mExp = [];
    for(Map<String,dynamic> eachMap in exp){
      mExp.add(ExpenseModel.fromMap(map: eachMap));
    }
    return mExp;
  }


}
