import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/Transaksi/DataTransaksi/DataTransaksiComponent.dart';
import 'package:kantin_stis/Components/User/Transaksi/DataTransaksi/DataTransaksiComponentBerhasil.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class DataTransaksiBerhasil extends StatelessWidget {
  static var routeName = '/data_transaksiberhasil_screens';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Riwayat Transaksi",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: DataTransaksiComponentBerhasil(),
    );
  }
}
