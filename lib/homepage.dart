// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sumi/componets/Ticket_model.dart';
import 'package:sumi/pages/entry.dart';
import 'package:sumi/pages/exit.dart';
import 'package:sumi/pages/history.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_qrcode_style.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_text_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _VController = TextEditingController();

  String VehicleType = "";
  String VN = "";
  String VT = "";
  String RID = "";
  DateTime? CT;

  void _showPopup(BuildContext context) {
    // final TextEditingController _VController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vehicle Number"),
          content: TextField(
            controller: _VController,
            decoration: InputDecoration(hintText: "Type something..."),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                printtext();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Print"),
            ),
          ],
        );
      },
    );
  }

  void printtext() async {
    VN = _VController.text;
    VT = VehicleType;
    RID = Ticket.generateReceiptID();
    CT = DateTime.now();

    await SunmiPrinter.printText('Parking Slip',
        style: SunmiTextStyle(
          bold: true,
          fontSize: 40,
        ));

    await SunmiPrinter.lineWrap(20);

    await SunmiPrinter.printText(
        'Vehicle Number: ${VN} \nVehicle Type: ${VT} \nReceipt ID: ${RID} \nCheck-in Time: ${CT.toString()}',
        style: SunmiTextStyle(
          bold: true,
          fontSize: 30,
        ));

    await SunmiPrinter.lineWrap(50);

    await SunmiPrinter.printQRCode('${VN} ; ${VT} ;${RID} ;${CT.toString()}',
        style: SunmiQrcodeStyle(
          qrcodeSize: 7,
          errorLevel: SunmiQrcodeLevel.LEVEL_H,
        ));

    await SunmiPrinter.lineWrap(50);

    await SunmiPrinter.printText(
        "For your own convenience, please don't loose this slip'.\nIn case of lost, full charges will apply.",
        style: SunmiTextStyle(
          bold: true,
          fontSize: 30,
        ));

    await SunmiPrinter.lineWrap(150); // Jump 2 lines
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Parking app"),
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: IconButton(
              onPressed: goto_history,
              icon: Icon(
                Icons.history,
                size: 30,
                color: Colors.black,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),

                Text(
                  "Vehicle Type",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 160,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            VehicleType = "Two";
                          });
                          _showPopup(context);
                        },
                        child: Card(
                            elevation: 20,
                            color: Colors.white,
                            child: Image.asset("assets/bike.jpg")),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 160,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            VehicleType = "Four";
                          });
                          _showPopup(context);
                        },
                        child: Card(
                            elevation: 20,
                            color: Colors.white,
                            child: Image.asset("assets/car.jpg")),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 50,
                ),

                // exit point #########################################
                GestureDetector(
                  onTap: goto_exit,
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: Card(
                      elevation: 15,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "Check Out",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goto_history() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryPage()),
    );
  }

  void goto_entry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Entry()),
    );
  }

  void goto_exit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Exit()),
    );
  }
}
