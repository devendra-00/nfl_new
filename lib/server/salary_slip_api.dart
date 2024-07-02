import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../dataclasses/salaryslip.dart';




Future<List<EarningsDeductiomModel>> fetchEarnings(BuildContext context,int empno, int date) async {

  String url_ = 'http://10.0.2.2:3000/earn_deduct?empno=$empno&date=$date';
  final url = Uri.parse(url_);

  try {
    final response = await http.get(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((entry) => EarningsDeductiomModel.fromJson(entry)).toList();
    }else if(response.statusCode == 500){
      showError(context, 'Internal server error' );
      throw Exception('Internal server error' );
    }else if(response.statusCode == 204){
      showError(context, 'No data available' );
      throw Exception('No data available' );
    }else{
      showErrorWithReport(context, "Unexpected Error");
      throw Exception(response.statusCode);
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
