import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Admin/Crud/DetailProductScreen.dart';
import 'package:kantin_stis/Screens/Admin/Crud/EditProdukScreen.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class AdminComponent extends StatefulWidget {
  @override
  _AdminComponent createState() => _AdminComponent();
}

class _AdminComponent extends State<AdminComponent> {
  Response? response;
  var dio = Dio();
  var dataProduk;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataProduk();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: dataProduk == null ? 0 : dataProduk.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cardProduk(dataProduk[index]);
                  },
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget cardProduk(data) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
            child: Image.network('$baseUrl/${data['gambar']}'),
          ),
          title: Text(
            "${data['nama']} ",
            style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, EditScreen.routeName,
                      arguments: data);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: kColorYellow,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                          color: mTitleColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              GestureDetector(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.info,
                    title: 'Peringatan',
                    desc: ' Yakin ingin hapus ${data['nama']} ?...',
                    btnCancelText: 'Tidak',
                    btnOkText: 'Yakin',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      getHapusProduk('${data['_id']}');
                    },
                  ).show();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: kColorRedSlow,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Hapus",
                      style: TextStyle(
                          color: mTitleColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, DetailProductScreen.routeName,
                  arguments: data);
            },
            child: Icon(
              Icons.keyboard_arrow_right,
              color: mTitleColor,
              size: 30.0,
            ),
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

  void getHapusProduk(id) async {
    bool status;
    var msg;
    try {
      response = await dio.delete('$urlHapus/$id');
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan',
          desc: ' $msg',
          btnOkOnPress: () {
            Navigator.pushNamed(context, HomeAdminScreen.routeName);
          },
        ).show();
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
