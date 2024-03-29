import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/Transaksi/UploadBuktiBayar/UploadPembayaranComponent.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class UploadBuktiPembayaranScreen extends StatelessWidget {
  static var routeName = '/upload_bukti_pembayaran';
  static var dataTransaksi;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataTransaksi = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Upload Bukti Pembayaran",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: UploadPembayaranComponent(),
    );
  }
}
