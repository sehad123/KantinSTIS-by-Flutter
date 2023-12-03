import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Components/default_button_cusomte_color.dart';
import 'package:kantin_stis/Screens/User/Transaksi/TransaksiScreen.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class TransaksiForm extends StatefulWidget {
  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  var total = 0.0;
  var jumlahBeli = 0.0;
  var hargaProduk = TransaksiScreen.dataProduk['harga'];

  Response? response;
  var dio = Dio();
  @override
  Widget build(BuildContext context) {
    print(TransaksiScreen.dataProduk);
    return Form(
        child: Column(
      children: [
        Image.network(
          "$baseUrl/${TransaksiScreen.dataProduk['gambar']}",
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${TransaksiScreen.dataProduk['nama']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Harga Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rp ${TransaksiScreen.dataProduk['harga']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tipe Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${TransaksiScreen.dataProduk['tipe']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deskripsi",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${TransaksiScreen.dataProduk['merk']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jumlah Beli",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, top: 5),
            child: SpinBox(
                min: 0,
                max: 100,
                value: 0,
                onChanged: (value) {
                  setState(() {
                    jumlahBeli = value;
                    total = jumlahBeli * hargaProduk;
                  });
                })),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total ",
                    style: mTitleStyle,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp $total",
                    style: mTitleStyle,
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        DefaultButtonCustomeColor(
          color: kPrimaryColor,
          text: "Beli",
          press: () {
            if (total <= 0 || jumlahBeli <= 0) {
              AwesomeDialog(
                context: context,
                animType: AnimType.rightSlide,
                dialogType: DialogType.info,
                title: 'Peringatan ',
                desc: 'Jumlah pembelian minimal 1',
                btnOkOnPress: () {
                  print(TransaksiScreen.dataProduk['_id']);
                  print(UserScreen.dataUserLogin['_id']);
                  prosesTransaksi(
                      TransaksiScreen.dataProduk['_id'],
                      UserScreen.dataUserLogin['_id'],
                      jumlahBeli,
                      hargaProduk,
                      total);
                },
              ).show();
            } else {
              AwesomeDialog(
                      context: context,
                      animType: AnimType.rightSlide,
                      dialogType: DialogType.info,
                      title: 'Peringatan ',
                      btnOkText: "Yakin",
                      btnCancelText: "Tidak",
                      desc:
                          'Yakin ingin melakukan pembelian ${TransaksiScreen.dataProduk['nama']}',
                      btnOkOnPress: () {
                        prosesTransaksi(
                            TransaksiScreen.dataProduk['_id'],
                            UserScreen.dataUserLogin['_id'],
                            jumlahBeli,
                            hargaProduk,
                            total);
                      },
                      btnCancelOnPress: () {})
                  .show();
            }
          },
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
      ],
    ));
  }

  void prosesTransaksi(idBarang, idUser, jumlah, harga, total) async {
    bool status;
    var msg;
    try {
      response = await dio.post(createTransaksi, data: {
        'idBarang': idBarang,
        'idUser': idUser,
        'jumlah': jumlah,
        'harga': harga,
        'total': total,
      });

      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        // print("Berhasil Registrasi");
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan ',
          desc: 'Transaksi Berhasil',
          btnOkOnPress: () {
            Navigator.pushNamed(context, UserScreen.routeName,
                arguments: UserScreen.dataUserLogin);
          },
        ).show();
      } else {
        // print("Gagal");
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan ',
          desc: 'gagal Transaksi => $msg',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan ',
        desc: 'Terjadi Kesalahan Server',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
