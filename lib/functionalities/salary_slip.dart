import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../server/salary_slip_api.dart';
import 'package:krutidevtounicode/krutidevtounicode.dart';

final _storage = FlutterSecureStorage();

class SalarySlipScreen extends StatefulWidget {
  const SalarySlipScreen({Key? key}) : super(key: key);

  @override
  State<SalarySlipScreen> createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
  late Widget _selectYearMonthText;
  String submitBtnText = "";
  bool _isSubmitEnabled = false;

  late DateTime _selectedYear;
  late int _selectedMonth;
  late String showYear;
  late String showMonth;
  int? employeeNo;

  @override
  void initState() {
    super.initState();
    _selectYearMonthText = Text(
      "Select Year and Month",
      style: TextStyle(fontSize: 24),
    ).animate().fadeIn(duration: Duration(seconds: 2));

    _selectedYear = DateTime.now();
    _selectedMonth = DateTime.now().month;
    showYear = "${DateTime.now().year}";
    showMonth = "${DateTime.now().month}";

    _loadEmployeeNo(); // Load employee number when the widget initializes
  }

  void _loadEmployeeNo() async {
    int? empNo = await _getEmployeeNo();
    setState(() {
      employeeNo = empNo;
      _isSubmitEnabled = empNo != null; // Enable submit button if employee number is loaded
    });
  }

  Future<int?> _getEmployeeNo() async {
    String? empNoString = await _storage.read(key: 'Employee_Number');
    return empNoString != null ? int.tryParse(empNoString) : null;
  }

  void _storeEmployeeNo(int empNo) async {
    await _storage.write(key: 'Employee_Number', value: empNo.toString());
  }

  void _selectYear(BuildContext context) {
    print("Calling date picker for year");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Year"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 10, 1),
              lastDate: DateTime(2025),
              initialDate: DateTime.now(),
              selectedDate: _selectedYear,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedYear = dateTime;
                  showYear = "${dateTime.year}";
                });
                Navigator.pop(context);
                _selectMonth(context); // Call the month picker after selecting the year
              },
            ),
          ),
        );
      },
    );
  } //Selects Year

  void _selectMonth(BuildContext context) {
    print("Calling date picker for month");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Month"),
          content: SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
              ),
              itemCount: 12,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMonth = index + 1;
                      showMonth = "${index + 1}";
                      _selectYearMonthText = Text(
                        "Year:${showYear}     Month:${showMonth}",
                        style: TextStyle(fontSize: 24),
                      ).animate().fadeIn(duration: Duration(seconds: 2));
                      submitBtnText = "Submit";
                    });
                    Navigator.pop(context);
                    print("Selected Month: ${index + 1}");
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: _selectedMonth == index + 1
                          ? Colors.blue
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  } //Selects Month

  @override
  Widget build(BuildContext context) {
    int getDate() {
      String finalDate;
      if (showMonth.length == 1) {
        finalDate = '0$showMonth$showYear';
      } else {
        finalDate = '$showMonth$showYear';
      }
      int d = int.parse(finalDate);
      print(d);
      return d;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text("Financial Details"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade100, Colors.grey.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade50, Colors.grey.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _selectYearMonthText, // Text for guidance to select

            IconButton(
              onPressed: () => _selectYear(context),
              icon: Icon(Icons.calendar_today, size: 70, color: Colors.teal),
            ) // Button for Calendar
                .animate(onComplete: (controller) => controller.repeat())
                .shimmer(duration: Duration(seconds: 2)),

            ElevatedButton(
              // Button for Submit
              onPressed: _isSubmitEnabled
                  ? () {
                if (employeeNo != null) {
                  gotoSalary_slip_api(employeeNo!, getDate());
                }
              }
                  : null,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.teal),
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.all(Colors.teal),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                side: MaterialStateProperty.all(
                    BorderSide(color: Colors.black26, width: 2)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              ),
              child: Text("${submitBtnText}"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gotoSalary_slip_api(int empno, int date) async {
    List<EarningsDeductiomModel> list =
    await fetchEarnings(context, employeeNo!, date);

    List<EarningsDeductiomModel> listED = list
        .where((element) => element.amount != "0.00")
        .toList();

    double totalEarnings = 0.0;
    double totalDeductions = 0.0;

    for (var item in listED) {
      if (item.earn_deduc == "E") {
        totalEarnings += double.parse(item.amount);
      } else if (item.earn_deduc == "D") {
        totalDeductions += double.parse(item.amount);
      }
    }
    // Calculate net pay
    double netPay = totalEarnings - totalDeductions;

    // Filter the list where earn_deduc is "E" and amount is not "0.00"
    List<EarningsDeductiomModel> listE =
    listED.where((element) => element.earn_deduc == "E").toList();

    // Filter the list where earn_deduc is "D" and amount is not "0.00"
    List<EarningsDeductiomModel> listD =
    listED.where((element) => element.earn_deduc == "D").toList();

    // Format numbers to two decimal places
    String formattedTotalEarnings = totalEarnings.toStringAsFixed(2);
    String formattedTotalDeductions = totalDeductions.toStringAsFixed(2);
    String formattedNetPay = netPay.toStringAsFixed(2);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows more control over the height
        builder: (context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 1.0, // Set the initial height to 80% of the screen height
            minChildSize: 0.5, // Minimum height
            maxChildSize: 1.0, // Maximum height
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                        itemCount: listED.length, // Number of items in the list
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),

                                color: listED[index].earn_deduc=="E" ? Colors.teal.shade50 : Colors.red.shade100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text("  ${listED[index].code}  ${listED[index].label}",style: TextStyle(fontSize: 14),),
                                    ),
                                    Container(
                                        child:Row(
                                          children: [
                                            Text("",style: TextStyle(fontSize: 14),),
                                            Text(KrutidevToUnicode.convertToUnicode(listED[index].hlabel),style: TextStyle(fontSize: 14),),
                                          ],
                                        )
                                    ),
                                    Container(
                                      child:Text('${listED[index].amount}   ',style: TextStyle(fontSize: 15),),
                                    ),
                                  ],
                                ),
                              )
                          );
                        },
                      )
                  ),
                  Container(

                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                            colors: [Colors.teal.shade100,Colors.grey.shade200, ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                        ),
                      ),
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Text("Gross Earn   : ₹ ${formattedTotalEarnings}",style: TextStyle(fontSize: 18)),
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Text("Gross Dedn  : ₹ ${formattedTotalDeductions}",style: TextStyle(fontSize: 18)),
                          ),
                          Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Text("Net Pay         : ₹ ${formattedNetPay}",style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      )

                  ),
                ],
              );
            },
          );
        }
    );
  }

}
