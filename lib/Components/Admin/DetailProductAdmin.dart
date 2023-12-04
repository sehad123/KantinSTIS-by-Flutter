import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Admin/Crud/DetailProductScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class DetailProductAdmin extends StatefulWidget {
  @override
  State<DetailProductAdmin> createState() => _DetailProductAdminState();
}

class _DetailProductAdminState extends State<DetailProductAdmin> {
  Response? response;
  var dio = Dio();
  @override
  Widget build(BuildContext context) {
    print(DetailProductScreen.dataProduk);
    return Form(
        child: Column(
      children: [
        Image.network(
          "$baseUrl/${DetailProductScreen.dataProduk['gambar']}",
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
                "${DetailProductScreen.dataProduk['nama']}",
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
                "Rp ${DetailProductScreen.dataProduk['harga']}",
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
                "Stock Produk",
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
                "${DetailProductScreen.dataProduk['qty']}",
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
                "${DetailProductScreen.dataProduk['tipe']}",
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
                "${DetailProductScreen.dataProduk['deskripsi']}",
              )
            ],
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
      ],
    ));
  }
}
