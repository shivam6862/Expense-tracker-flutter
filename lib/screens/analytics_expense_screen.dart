import 'package:expense_tracker_flutter/resources/expense_methods.dart';
import 'package:expense_tracker_flutter/utils/colors.dart';
import 'package:expense_tracker_flutter/utils/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalyticsExpenseScreen extends StatefulWidget {
  final String uid;
  const AnalyticsExpenseScreen({super.key, required this.uid});

  @override
  State<AnalyticsExpenseScreen> createState() => _AnalyticsExpenseScreenState();
}

class _AnalyticsExpenseScreenState extends State<AnalyticsExpenseScreen> {
  Map<String, dynamic> _expensesByCategory = {};
  Map<String, dynamic> _expensesByDate = {};
  int maxValue = 20;

  @override
  void initState() {
    super.initState();
    getExpensesByCategory();
    getExpensesByDate();
  }

  void getExpensesByCategory() async {
    final Map<String, double> expensesByCategory =
        await ExpenseMethods().getExpensesByCategory();
    setState(() {
      _expensesByCategory = expensesByCategory;
    });
  }

  void getExpensesByDate() async {
    final Map<String, double> expensesByDate =
        await ExpenseMethods().getExpensesByDate();
    setState(() {
      _expensesByDate = expensesByDate;
      final List<double> values = expensesByDate.values.toList();
      values.sort();
      maxValue = values.isNotEmpty ? values.last.toInt() + 100 : 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Expense'),
        backgroundColor: whiteColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expenses by Category',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                      ),
                    ]),
              ),
            ),
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _expensesByCategory.entries.map((entry) {
                  final String key = entry.key;
                  final double value = entry.value;
                  return PieChartSectionData(
                    title: '$key\n$value',
                    value: value,
                    color:
                        colors[_expensesByCategory.keys.toList().indexOf(key)],
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                sectionsSpace: 0,
                centerSpaceRadius: 50,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expenses by Date',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                      ),
                    ]),
              ),
            ),
          ),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue.toDouble(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(4),
                    tooltipMargin: 8,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        '${rod.toY.round()}\n${DateFormat('dd MMM yyyy').format(
                          DateTime.parse(
                            _expensesByDate.keys.elementAt(group.x.toInt()),
                          ),
                        )}',
                        const TextStyle(
                          color: whiteColor,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: _expensesByDate.entries.map((entry) {
                  final String key = entry.key;
                  final double value = entry.value;
                  return BarChartGroupData(
                    x: _expensesByDate.keys.toList().indexOf(key),
                    barRods: [
                      BarChartRodData(
                        fromY: 0,
                        toY: value,
                        width: 10,
                        color:
                            colors[_expensesByDate.keys.toList().indexOf(key)],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
