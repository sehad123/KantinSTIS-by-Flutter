import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/Admin/Crud/InputProduk/InputProdukComponent.dart';
import 'package:kantin_stis/Utils/constants.dart';

class InputScreen extends StatelessWidget {
  static var routeName = '/input_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Input Data Produk",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: InputProdukComponent(),
  );
  }
}
