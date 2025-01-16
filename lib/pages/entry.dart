import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sumi/componets/Ticket_model.dart';
import 'package:sumi/sumi.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_qrcode_style.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_text_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  final TextEditingController vehicleNumberController = TextEditingController();
  String selectedVehicleType = "Two";
  Ticket? generatedTicket;
  bool isgenrtated = false;

  String VN = "";
  String VT = "";
  String RID = "";
  DateTime? CT;

  // Function to show a popup message
  void showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to generate ticket
  void generateTicket() {
    final vehicleNumber = vehicleNumberController.text;

    if (vehicleNumber.isEmpty) {
      // Show popup if vehicle number is empty
      showPopupMessage("Please enter the vehicle number.");
      return;
    }

    final vehicleType = selectedVehicleType;
    final receiptID = Ticket.generateReceiptID();
    final checkInTime = DateTime.now();

    setState(() {
      generatedTicket = Ticket(
        vehicleNumber: vehicleNumber,
        vehicleType: vehicleType,
        receiptID: receiptID,
        checkInTime: checkInTime,
      );

      VN = vehicleNumber;
      VT = vehicleType;
      RID = receiptID;
      CT = checkInTime;

      isgenrtated = true;
    });
  }

  // primting

  void printtext() async {
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
    return Scaffold(
      appBar: AppBar(title: Text("Parking Ticket Generator")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input fields
              TextField(
                controller: vehicleNumberController,
                decoration: InputDecoration(labelText: "Vehicle Number"),
              ),

              // vechile options #############################

              SizedBox(
                height: 30,
              ),

              // SizedBox(
              //   height: 40,
              //   width: 120,
              //   child: GestureDetector(
              //     onTap: () {
              //       setState(() {
              //         isTab = false;
              //       });
              //     },
              //     child: Card(
              //       child: Center(child: Text("VehicleType")),
              //     ),
              //   ),
              // ),

              Row(
                children: [
                  Text(
                    "Vehicle Type:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton<String>(
                    value: selectedVehicleType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedVehicleType = newValue!;
                      });
                    },
                    items: <String>["Two", "Four"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: generateTicket,
                child: Text("Generate Ticket"),
              ),

              // Display Ticket Preview
              if (generatedTicket != null) TicketCard(ticket: generatedTicket!),

              isgenrtated
                  ? ElevatedButton(onPressed: printtext, child: Text(" print "))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Build the QR code data as a readable JSON format
    String qrData = '''
Vehicle Number: ${ticket.vehicleNumber}
Vehicle Type: ${ticket.vehicleType}
Receipt ID: ${ticket.receiptID}
Check-in Time: ${ticket.checkInTime.toString()}
''';

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text("Company Name", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8.0),
            Text("Printing Slip", style: TextStyle(fontSize: 18)),
            Divider(),
            Text("Vehicle Number: ${ticket.vehicleNumber}"),
            Text("Vehicle Type: ${ticket.vehicleType}"),
            Text("Receipt ID: ${ticket.receiptID}"),
            Text("Check-in Time: ${ticket.checkInTime.toString()}"),
            SizedBox(height: 16.0),
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
                foregroundColor: Colors.black,
              ),
            ) // QR Code

            ,
          ],
        ),
      ),
    );
  }
}
