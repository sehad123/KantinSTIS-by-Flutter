import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/Transaksi/CreateTransaksi/FormTransaksiComponent.dart';
import 'package:kantin_stis/size_config.dart';

class TransaksiComponent extends StatefulWidget {
  @override
  _TransaksiComponent createState() => _TransaksiComponent();
}

class _TransaksiComponent extends State<TransaksiComponent> {
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
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 9.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Halaman Transaksi!",
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
                TransaksiForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
