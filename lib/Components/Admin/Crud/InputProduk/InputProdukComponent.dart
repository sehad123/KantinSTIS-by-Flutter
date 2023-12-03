import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/Admin/Crud/InputProduk/InputProdukForm.dart';
import 'package:kantin_stis/size_config.dart';

class InputProdukComponent extends StatefulWidget {
  @override
  _InputProdukComponent createState() => _InputProdukComponent();
}

class _InputProdukComponent extends State<InputProdukComponent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight = 0.04,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Input Data Produk",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FormInputProduk()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
