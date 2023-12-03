import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/Admin/Crud/InputProduk/EditProduk/EditProdukComponent.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class UserByIdScreen extends StatelessWidget {
  static var routeName = '/profile_screen';
  static var dataProduk;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataProduk = ModalRoute.of(context)!.settings.arguments as Map;
    print(dataProduk);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: EditProdukComponent(),
    );
  }
}
