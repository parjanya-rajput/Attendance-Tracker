import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gsheets/gsheets.dart';

// api credentials
const _credentials = r'''
{
  //Api Credentials are not uploaded to the repository
}
''';

late Worksheet sheet;

class ScanBarcode extends StatefulWidget {
  final String spreadsheetId;
  final String worksheetId;
  const ScanBarcode(
      {super.key, required this.spreadsheetId, required this.worksheetId});

  @override
  State<ScanBarcode> createState() =>
      _ScanBarcodeState(spreadsheetId: spreadsheetId, worksheetId: worksheetId);
}

class _ScanBarcodeState extends State<ScanBarcode> {
  String spreadsheetId;
  _ScanBarcodeState({required this.spreadsheetId, required this.worksheetId});
  String worksheetId;
  @override
  void initState() {
    makeConnection();
    // print(spreadsheetId);
    // print(worksheetId);
    super.initState();
  }

  Future<void> makeConnection() async {
    //initialize the google sheet api
    final gsheets = GSheets(_credentials);
    //fetch spreadsheet by its id
    final ssheet = await gsheets.spreadsheet(spreadsheetId);
    //get the worksheet of your spreadsheet by its title
    sheet = (await ssheet.worksheetByTitle(worksheetId))!;
  }

  var _scanBarcodeResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: Builder(
        builder: (context) => Container(
          alignment: Alignment.center,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: normalScanBarcode,
                child: const Text('Scan Barcode!'),
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushNamedAndRemoveUntil(
              //         context, '/login_page', (route) => false);
              //   },
              //   child: const Text('Change User!'),
              // ),
              Text('Last Scan result: $_scanBarcodeResult')
            ],
          ),
        ),
      ),
    );
  }

  Future<void> normalScanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      // SnackBar snackBar = SnackBar(
      //   content: Text('Barcode Scan Result: $barcodeScanRes'),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    setState(() {
      _scanBarcodeResult = barcodeScanRes;
    });
    if (barcodeScanRes != '-1') {
      writeData();
    }
  }

  Future<void> writeData() async {
    //write data to the google sheet
    // await sheet.values.insertValue("Test-1", column: 1, row: 1);
    await sheet.values.appendRow([_scanBarcodeResult]);
    SnackBar snackBar = SnackBar(
      content: Text('Data written to Google Sheet Successfully'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
