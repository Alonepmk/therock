import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ManageExportExcel extends StatefulWidget {
  const ManageExportExcel({super.key});

  @override
  State<ManageExportExcel> createState() => _ManageExportExcelState();
}

class _ManageExportExcelState extends State<ManageExportExcel> {
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Align(
              child: Text(
                "Export Excel",
                style: TextStyle(
                  fontSize: screenWidth / 25,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: screenWidth / 2,
                  height: screenHeight / 16,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      exportAllGymUserExcel();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey.shade400),
                    ),
                    child: Text(
                      "Generate User XLSX",
                      style: TextStyle(
                        fontSize: screenWidth / 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future exportReport() async {
    var excel = Excel.createExcel();
    DateTime _now = DateTime.now();
    String _name = DateFormat('yyyy-MM-dd').format(_now);
    String _fileName = 'yar-' + _name;

    Sheet sheet = excel[_fileName];
    var cell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));

    cell.value = TextCellValue('Index ke A1');

    List<int>? potato = excel.save(fileName: _name);

    PermissionStatus status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      await File('/storage/emulated/0/Download/$_fileName.xlsx')
          .writeAsBytes(potato!, flush: true)
          .then((value) {
        print('saved');
      });
    } else if (status == PermissionStatus.denied) {
      print(
          'Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    return null;
  }

  exportAllGymUserExcel() async {
    Excel excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, "Entire Gym Users");

    Sheet sheet = excel["Entire Gym Users"];
    var cell =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));

    cell.value = TextCellValue('Index ke A1');

    var cell2 =
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));

    cell2.value = TextCellValue('Index ke A2');
    final permissionStatus = await Permission.storage.status;
    //PermissionStatus status = await Permission.storage.request();
    await Permission.storage.request();

    if (permissionStatus == PermissionStatus.granted) {
    } else if (permissionStatus == PermissionStatus.denied) {
      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();

      File("/storage/emulated/0/Download/output_file_name.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      print('${directory.path}');
      openAppSettings();
      print(
          'Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
    }

    excel.save(fileName: "Entire Gym Users.xlsx");
  }
}
