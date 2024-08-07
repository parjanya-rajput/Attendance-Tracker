import 'package:barcode_scanner/barcode_scanner.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class SpreadSheetSelect extends StatefulWidget {
  const SpreadSheetSelect({super.key});

  @override
  State<SpreadSheetSelect> createState() => _SpreadSheetSelectState();
}

class _SpreadSheetSelectState extends State<SpreadSheetSelect> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final TextEditingController _spreadsheetIdController =
      TextEditingController();

  final TextEditingController _worksheetIdController = TextEditingController();
  bool _isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spreadsheet Select'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login_page', (route) => false);
              }
              _logout();
            },
            itemBuilder: (BuildContext context) {
              return const <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _spreadsheetIdController,
              decoration: const InputDecoration(
                labelText: 'SpreadSheet ID',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _worksheetIdController,
              decoration: const InputDecoration(
                labelText: 'Worksheet Name',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanBarcode(
                      spreadsheetId: _spreadsheetIdController.text,
                      worksheetId: _worksheetIdController.text,
                    ),
                  ) as Route<Object?>,
                );
              },
              child: const Text('Make Connection'),
            ),
            _connectionStatus == ConnectivityResult.none
                ? const Text('No internet connection')
                : const Text('Internet connection available'),
          ],
        ),
      ),
    );
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _connectionStatus = connectivityResult;
    });
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushNamedAndRemoveUntil(context, '/login_page', (route) => false);
  }

  // void showNoInternetSnackbar() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('No internet connection'),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

  // void showInternetSnackbar() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Internet connection available'),
  //       backgroundColor: Colors.green,
  //     ),
  //   );
  // }
}
