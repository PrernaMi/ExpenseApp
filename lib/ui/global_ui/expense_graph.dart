import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/filter_expense_model.dart';

class ExpBarGraph extends StatefulWidget {
  List<FilterExpenseModel> allFilteredExp;
  String filterdName;

  ExpBarGraph({required this.allFilteredExp, required this.filterdName});

  @override
  State<ExpBarGraph> createState() => _ExpBarGraphState();
}

class _ExpBarGraphState extends State<ExpBarGraph> {
  //this is used for checking debit or credit to change the barRod color
  bool check = false;

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isLight ? Colors.white : Colors.black,
        title: Center(
            child: Text(
          "Transaction",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        )),
      ),
      backgroundColor: isLight ? Colors.white : Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 5 / 4,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: BarChart(BarChartData(
                barGroups: expenseBarData(),
                titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 46,
                        interval: 5000,
                      ),
                      axisNameWidget: Text(
                        "Expenses",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isLight ? Colors.black : Colors.white),
                      ),
                    ),
                    rightTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 28),
                      axisNameWidget: Text(widget.filterdName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    topTitles: AxisTitles()),
                barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      direction: TooltipDirection.top,
                    )))),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> expenseBarData() {
    return List.generate(widget.allFilteredExp.length, (index) {
      double amt = -widget.allFilteredExp[index].amount.toDouble();
      return amt >= 0
          ? BarChartGroupData(x: index + 1, barRods: [
              barRodData(amt: amt, check: false),
            ])
          : BarChartGroupData(
              x: index + 1, barRods: [barRodData(amt: -amt, check: true)]);
    });
  }

  BarChartRodData barRodData({required double amt, required bool check}) {
    return BarChartRodData(
      toY: amt,
      color: check ? Colors.greenAccent : Colors.redAccent.shade100,
      width: 20,
      borderRadius: BorderRadius.vertical(),
    );
  }
}
