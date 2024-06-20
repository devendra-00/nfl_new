import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class EarningsDeductiomModel {
  final String code;
  final String label;
  final String earn_deduc;
  final String hlabel;
  final String amount;

  EarningsDeductiomModel({required this.code,required this.label,required this.earn_deduc, required this.hlabel,required this.amount});

  factory EarningsDeductiomModel.fromJson(Map<String, dynamic> json) {
    return EarningsDeductiomModel(
      code: json['code'],
      label: json['label'],
      earn_deduc:json['earn_deduc'],
      hlabel: json['hlabel'],
      amount: json['amount']  ,

    );
  }
}

Future<List<EarningsDeductiomModel>> fetchEarnings(BuildContext context,int empno, int date) async {

  String url_ = 'http://10.0.2.2:3000/earn_deduct?empno=$empno&date=$date';
  final url = Uri.parse(url_);

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((entry) => EarningsDeductiomModel.fromJson(entry))
          .toList();
    }else if(response.statusCode == 500){
      showError(context, 'Internal server error' );
      throw Exception('Internal server error' );
    }else if(response.statusCode == 404){
      showError(context, 'No data available' );
      throw Exception('No data available' );
    }else{
      showErrorWithReport(context, "Unexpected Error");
      throw Exception('Unexpected Error');
    }
  } on SocketException catch (e) {

    if (e.osError != null && e.osError!.message.contains('Connection refused')) {
      showError(context, "Server is down. Please try again later.");
    } else {
      showError(context, "No internet connection. Please check your network settings.");
    }
    throw Exception('Network error: $e');
  }
}

void showError(context,String err){
  showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.teal.shade100,
          content: Text('${err}',style: TextStyle(fontSize: 18),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      }
  );
}

void showErrorWithReport(context,String err){
  showDialog(
      context: context,
      builder:(BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.teal.shade100,
          content: Text('${err}',style: TextStyle(fontSize: 18),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Report Bug'),
            ),

          ],
        );
      }
  );
}

Future<void> showEarningsDialog(BuildContext context, List<EarningsDeductiomModel> earningsList) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.teal.shade100,
        content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: earningsList.map((entry) {
                      return Card(
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))

                        ),
                        borderOnForeground: false,
                        color: Colors.transparent,
                        surfaceTintColor: Colors.blue,
                        child: SizedBox(
                            height: 20,width: MediaQuery.of(context).size.width,
                            child: Text('${entry.earn_deduc}-----${entry.label}----₹${entry.amount}')),
                      );
                    }).toList(),

                  )
              )
            ]
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget ShowEarnDeductScreen(BuildContext context, List<EarningsDeductiomModel> EList, List<EarningsDeductiomModel> DList){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Earnings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: EList.length,
                    itemBuilder: (context, index) {
                      final entry = EList[index];
                      return ListTile(
                        title: Text('${entry.label}'),
                        subtitle: Text('₹${entry.amount}'),
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Deductions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: DList.length,
                    itemBuilder: (context, index) {
                      final entry = DList[index];
                      return ListTile(
                        title: Text('${entry.label}'),
                        subtitle: Text('₹${entry.amount}'),
                        dense: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}