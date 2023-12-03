import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class FormInputProduk extends StatefulWidget {
  @override
  _FormInputProduk createState() => _FormInputProduk();
}

class _FormInputProduk extends State<FormInputProduk> {
  TextEditingController txtNamaProduk = TextEditingController(),
      txtTipeProduk = TextEditingController(),
      txtHargaProduk = TextEditingController(),
      txtDeskripsiProduk = TextEditingController();

  FocusNode focusNode = new FocusNode();
  File? image;

  Response? response;
  var dio = Dio();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildNamaProduk(),
          SizedBox(height: 30),
          buildTipeProduk(),
          SizedBox(height: 30),
          buildHargaProduk(),
          SizedBox(height: 30),
          builDeskripsiProduk(),
          SizedBox(height: 30),
          // image == null ? Container() : Image.file(image!),
          // Image.file(image!),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              style: ElevatedButton.styleFrom(
                primary:
                    Colors.greenAccent, // Ganti dengan warna yang diinginkan
              ),
              child: Text(
                'Pilih Gambar Produk',
                style: TextStyle(color: Colors.white), // Atur warna teks tombol
              ),
            ),
          ),
          SizedBox(height: 20),
          // Tampilkan gambar yang dipilih di sini
          image != null
              ? Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Image.file(image!),
                )
              : Container(),

          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (txtNamaProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'nama produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                } else if (txtTipeProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'tipe produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                }
                if (txtHargaProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'harga produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                }
                if (txtDeskripsiProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'deskripsi produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  inputData(
                      txtNamaProduk.text,
                      txtTipeProduk.text,
                      txtHargaProduk.text,
                      txtDeskripsiProduk.text,
                      image?.path);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Ganti dengan warna yang diinginkan
              ),
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white), // Atur warna teks tombol
              ),
            ),
          ),
          SizedBox(
              height: 20), // Memberikan jarak antara tombol 'Login' dan 'Row'
        ],
      ),
    );
  }

  TextFormField buildNamaProduk() {
    return TextFormField(
      controller: txtNamaProduk,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Nama Produk',
          hintText: 'Masukkan Produk anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.add_chart_sharp)),
    );
  }

  TextFormField buildTipeProduk() {
    return TextFormField(
      controller: txtTipeProduk,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Tipe Produk',
          hintText: 'Masukkan tipe produk anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.food_bank)),
    );
  }

  TextFormField buildHargaProduk() {
    return TextFormField(
      controller: txtHargaProduk,
      keyboardType: TextInputType.number,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Harga Produk',
          hintText: 'Masukkan harga produk anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.price_change)),
    );
  }

  TextFormField builDeskripsiProduk() {
    return TextFormField(
      controller: txtDeskripsiProduk,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Deskripsi Produk',
          hintText: 'Masukkan Deskripsi produk anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.description)),
    );
  }

  void inputData(nama, tipe, harga, deskripsi, gambar) async {
    bool status;
    var msg;
    try {
      var formData = FormData.fromMap({
        'nama': nama,
        'tipe': tipe,
        'harga': harga,
        'merk': deskripsi,
        'gambar': await MultipartFile.fromFile(gambar),
      });
      response = await dio.post(urlCreate, data: formData);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan',
          desc: 'Produk Berhasil ditambahkan => $msg',
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
          desc: 'Produk gagal ditambahkan => $msg',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.success,
        title: 'Peringatan',
        desc: 'terjadi kesalahan server \n => $msg',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
