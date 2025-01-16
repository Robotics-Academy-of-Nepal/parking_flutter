import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sumi/componets/history.dart';
import 'package:sumi/componets/history_manager.dart';
import 'package:sumi/homepage.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_qrcode_style.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_text_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

class Exit extends StatefulWidget {
  const Exit({super.key});

  @override
  State<Exit> createState() => _ExitState();
}

class _ExitState extends State<Exit> {
  Barcode? result;
  Map<String, dynamic>? ticketData;
  double? parkingFee;

  String VN = "";
  String VT = "";
  String RID = "";
  DateTime? CT;
  DateTime? CO;

  // Function to parse QR data
  Map<String, dynamic>? _parseQRCode(String data) {
    print(data);
    try {
      // Split the data by " ;" and trim each part
      final parts = data.split(' ;').map((part) => part.trim()).toList();

      if (parts.length < 4) {
        throw Exception("Invalid QR Code data format");
      }

      // Assign parts to respective variables
      final vehicleNumber = parts[0];
      final vehicleType = parts[1];
      final receiptID = parts[2];
      final checkInTime = DateTime.parse(parts[3]);

      return {
        'vehicleNumber': vehicleNumber,
        'vehicleType': vehicleType,
        'receiptID': receiptID,
        'checkInTime': checkInTime,
      };
    } catch (e) {
      print("Error parsing QR Code: $e");
      return null; // Return null if parsing fails
    }
  }

  // Function to calculate the parking fee
  double _calculateParkingFee(Map<String, dynamic> data) {
    final checkInTime = data['checkInTime'] as DateTime;
    final vehicleType = data['vehicleType'] as String;

    final now = DateTime.now();
    final duration = now.difference(checkInTime).inMinutes; // Time in minutes
    final hours = (duration / 60).ceil(); // Round up to the nearest hour

    final rate = (vehicleType == 'Four') ? 80 : 25;
    return hours * rate.toDouble();
  }

  void handleCheckout(
      Map<String, dynamic> ticketData, double calculatedPrice) async {
    try {
      //Add the history entry
      await HistoryManager.addHistoryEntry(
        HistoryEntry(
          receiptId: ticketData['receiptID'] ?? 'Unknown',
          vehicleNumber: ticketData['vehicleNumber'] ?? 'Unknown',
          vehicleType: ticketData['vehicleType'] ?? 'Unknown',
          checkOutTime: DateTime.now(),
          price: calculatedPrice,
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout successful! History updated.')),
      );

      // Perform additional actions if needed (like printing a bill)
    } catch (error) {
      // Handle duplicate Receipt ID or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void printtext() async {
    CO = DateTime.now();
    // await SunmiPrinter.printText('Parking Slip');
    // await SunmiPrinter.printText('Bold text centered',
    //     style: SunmiTextStyle(
    //       bold: true,
    //       align: SunmiPrintAlign.CENTER,
    //     ));

    // await SunmiPrinter.lineWrap(2); // Jump 2 lines
    await SunmiPrinter.printText('Parking Slip',
        style: SunmiTextStyle(
          bold: true,
          fontSize: 40,
        ));

    await SunmiPrinter.lineWrap(20);

    await SunmiPrinter.printText(
        'Vehicle Number: ${ticketData?['vehicleNumber'] ?? 'Unknown'} \nVehicle Type: ${ticketData?['vehicleType'] ?? 'Unknown'} \nReceipt ID: ${ticketData?['receiptID'] ?? 'Unknown'} \nCheck-in Time: ${ticketData?['checkInTime'] != null ? DateFormat('yyyy-MM-dd HH:mm').format(ticketData!['checkInTime']) : 'Unknown'} \nCheck-out Time: ${CO}',
        style: SunmiTextStyle(
          bold: true,
          fontSize: 20,
        ));

    await SunmiPrinter.lineWrap(20);

    await SunmiPrinter.printText('Total fee: RS ${parkingFee}',
        style: SunmiTextStyle(
          bold: true,
          fontSize: 40,
        ));

    await SunmiPrinter.lineWrap(100); // Jump 2 lines
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exit Parking")),
      body: Column(
        children: [
          // QR Scanner
          Expanded(
            flex: 3,
            child: MobileScanner(
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                if (barcode.rawValue != null) {
                  setState(() {
                    result = barcode;
                    ticketData = _parseQRCode(barcode.rawValue!);
                    if (ticketData != null) {
                      parkingFee = _calculateParkingFee(ticketData!);
                    }
                  });
                }
              },
            ),
          ),
          // Display scanned data
          Expanded(
            flex: 2,
            child: result != null
                ? ticketData != null
                    ? Card(
                        margin: const EdgeInsets.all(16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Vehicle Number: ${ticketData?['vehicleNumber'] ?? 'Unknown'}"),
                              Text(
                                  "Vehicle Type: ${ticketData?['vehicleType'] ?? 'Unknown'}"),
                              Text(
                                  "Receipt ID: ${ticketData?['receiptID'] ?? 'Unknown'}"),
                              Text(
                                  "Check-in Time: ${ticketData?['checkInTime'] != null ? DateFormat('yyyy-MM-dd HH:mm').format(ticketData!['checkInTime']) : 'Unknown'}"),
                              SizedBox(height: 8.0),
                              Divider(),
                              Text(
                                  "Total Fee: Rs. ${parkingFee?.toStringAsFixed(2) ?? '0.00'}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )
                    : Text("Invalid QR Code")
                : Text("Scan a QR Code to retrieve details"),
          ),
          // Buttons to clear or save history
          if (result != null)
            Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 200,
                  child: GestureDetector(
                    onTap: () {
                      if (ticketData != null && parkingFee != null) {
                        handleCheckout(ticketData!, parkingFee!);
                        printtext();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Invalid data! Please scan a valid QR.')),
                        );
                      }

                      goto_Home();
                    },
                    child: Card(
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          "Print",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     if (ticketData != null && parkingFee != null) {
                //       handleCheckout(ticketData!, parkingFee!);
                //       printtext();
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //             content:
                //                 Text('Invalid data! Please scan a valid QR.')),
                //       );
                //     }

                //     goto_Home();
                //   },
                //   child: Text("Print"),
                // ),
              ],
            ),
        ],
      ),
    );
  }

  void goto_Home() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  }
}
