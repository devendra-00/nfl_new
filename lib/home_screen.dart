import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nfl_new/functionalities/user_profile.dart';
import 'package:nfl_new/functionalities/computercomplaint/computer_complaint.dart';


import 'dataclasses/functionalities_listtile.dart';
import 'functionalities/computercomplaint/computer_complaint_IT.dart';
import 'functionalities/computercomplaint/computer_complaint_others.dart';
import 'functionalities/salary_slip.dart';
import 'login.dart';

final _storage = FlutterSecureStorage();

class homeScrren extends StatefulWidget {
  const homeScrren({super.key});

  @override
  State<homeScrren> createState() => _homeScrrenState();
}

class _homeScrrenState extends State<homeScrren> {
  String employeeName="XXXXX XXXX";
  String employeeNumber="XXXX";

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    Future<String> _getEmployeeName = getEmployeeName();
    Future<String> _getEmployeeNo = getEmployeeNo();
    _getEmployeeName.then((name) {
      setState(() {
        employeeName = name;
      });
    });
    _getEmployeeNo.then((no) {
      setState(() {
        employeeNumber = no;
      });
    });

      return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade100,Colors.grey.shade200,  ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: TextField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Perform search functionality here
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey.shade50,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan.shade50,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(employeeName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_rounded),
              title: Text('Employee Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => userProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => userProfile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact'),
              onTap: () {
                // Update the state of the app
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Signout(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: listTiles.length,
        itemBuilder: (context, index) {
          final listTile = listTiles[index];
          if (_searchQuery.isNotEmpty && !listTile.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
            return SizedBox.shrink();
          }
          return Card(
            surfaceTintColor: Colors.teal,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade200,
                  child: Icon(listTile.icon)),
              title: Text(
                listTile.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                listTile.description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => listTile.destinationScreen),
                );

              },
            ),
          );
        },
      )

    );
  }
  void Signout(BuildContext context) async {
    await _storage.write(key: 'LoggedIn', value: 'false');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Replace with your actual login screen widget
    );
  }

  Future<String> getEmployeeName() async {
    String? name = await _storage.read(key: 'Employee_Name');
    if (name == null) {
      name = 'XXX XXXXXXX'; // Default name if not found
    }
    return name;
  }
  Future<String> getEmployeeNo() async {
    String? no = await _storage.read(key: 'Employee_Number');
    if (no == null) {
      no = 'XXX XXXXXXX'; // Default name if not found
    }
    return no;
  }


  List<ListTileData> listTiles = [
    ListTileData('Financial Details', 'Earnings and Deductions',Icons.currency_rupee,SalarySlipScreen()),
    ListTileData('Computer Complaint', 'IT Department',Icons.desktop_windows_sharp,CompputerComplaintScreen()),

    // Add more list tile data here
  ];
}
