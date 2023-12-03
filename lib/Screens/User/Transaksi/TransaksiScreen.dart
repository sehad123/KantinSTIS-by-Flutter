import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/Transaksi/CreateTransaksi/TransaksiComponent.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class TransaksiScreen extends StatelessWidget {
  static var routeName = '/form_transaksi_screens';
  static var dataProduk;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataProduk = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Menu Transaksi",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: TransaksiComponent(),
    );
  }
}
