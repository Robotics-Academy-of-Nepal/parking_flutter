import 'package:flutter/material.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_qrcode_style.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_text_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

class Sumi extends StatefulWidget {
  const Sumi({super.key});

  @override
  State<Sumi> createState() => _SumiState();
}

class _SumiState extends State<Sumi> {
  void printtext() async {
    await SunmiPrinter.printText('Simple raw text');
    await SunmiPrinter.printText('Bold text centered',
        style: SunmiTextStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));

    await SunmiPrinter.lineWrap(2); // Jump 2 lines
    await SunmiPrinter.printText('Very Large font!',
        style: SunmiTextStyle(
          fontSize: 80,
        ));

    await SunmiPrinter.printText('Custom font size!!!',
        style: SunmiTextStyle(
          fontSize: 32,
        ));

    await SunmiPrinter.printQRCode('https://github.com/brasizza/sunmi_printer',
        style: SunmiQrcodeStyle(
          qrcodeSize: 3,
          errorLevel: SunmiQrcodeLevel.LEVEL_H,
        )); // PRINT A QRCODE
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: printtext, child: Text(" print the data"))
          ],
        ),
      ),
    );
  }
}
