import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/User/Transaksi/TransaksiScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class ProdukComponent extends StatefulWidget {
  @override
  State<ProdukComponent> createState() => _ProdukComponentState();
}

class _ProdukComponentState extends State<ProdukComponent> {
  Response? response;
  var dio = Dio();
  var dataProduk;

  @override
  void initState() {
    super.initState();
    getDataProduk();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: dataProduk == null ? 0 : dataProduk.length,
          itemBuilder: (BuildContext context, int index) {
            return cardProduk(dataProduk[index]);
          },
        ),
      ),
    );
  }

  Widget cardProduk(data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TransaksiScreen.routeName,
            arguments: data);
      },
      child: Card(
        elevation: 10.0,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: 100,
                    child: Image.network('$baseUrl/${data['gambar']}'),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "${data['nama']} ",
                  style: TextStyle(
                      color: mTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  "${data['tipe']} ",
                  style: TextStyle(
                      color: mTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  "Rp ${data['harga']} ",
                  style: TextStyle(
                      color: mTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  "${data['merk']} ",
                  style: TextStyle(
                      color: mTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getDataProduk() async {
    bool status;
    var msg;
    try {
      response = await dio.get(urlgetAll);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        setState(() {
          dataProduk = response!.data['data'];
          print(dataProduk);
        });
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan',
          desc: ' produk tidak ditemukan',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'Kesalahan Internal Server',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
