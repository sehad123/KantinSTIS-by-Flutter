import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/Produk/ProdukComponents.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class DataProdukScreen extends StatelessWidget {
  static var routeName = '/list_produk_user_screens';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Daftar Produk",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ProdukComponent(),
    );
  }
}
