import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/Transaksi/DataTransaksi/DataTransaksiComponent.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class DataTransaksiScreen extends StatelessWidget {
  static var routeName = '/data_transaksiusers_screens';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Menu Transaksi",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: DataTransaksiComponent(),
    );
  }
}
