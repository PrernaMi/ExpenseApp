import 'package:expanses_task11/data/local/db_helper.dart';

class ExpenseModel {
  int uid;
  int? eId;
  String eTitle;
  String eDesc;
  int eCatId;
  String eTime;
  int eType;
  double eAmt;
  double eBal;

  ExpenseModel({
    this.eId,
    required this.uid,
    required this.eTitle,
    required this.eTime,
    required this.eAmt,
    required this.eCatId,
    required this.eDesc,
    required this.eType,
    required this.eBal,
  });

  factory ExpenseModel.fromMap({required Map<String, dynamic>map}){
    return ExpenseModel(
        eId: map[DbHelper.Exp_Id],
        uid: map[DbHelper.User_Id],
        eTitle: map[DbHelper.Exp_title],
        eTime: map[DbHelper.Exp_Time],
        eAmt: map[DbHelper.Exp_Amt],
        eCatId: map[DbHelper.Exp_Cat],
        eDesc: map[DbHelper.Exp_desc],
        eType: map[DbHelper.Exp_Type],
      eBal: map[DbHelper.Exp_Bal]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      DbHelper.Exp_title : eTitle,
      DbHelper.Exp_desc : eDesc,
      DbHelper.Exp_Amt : eAmt,
      DbHelper.Exp_Cat : eCatId,
      DbHelper.Exp_Type : eType,
      DbHelper.Exp_Time : eTime,
      DbHelper.Exp_Bal : eBal,
      DbHelper.User_Id : uid,
    };
  }
}
