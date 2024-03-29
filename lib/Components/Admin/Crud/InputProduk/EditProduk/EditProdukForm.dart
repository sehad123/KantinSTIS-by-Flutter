import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Admin/Crud/EditProdukScreen.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class FormEditProduk extends StatefulWidget {
  @override
  _FormEditProduk createState() => _FormEditProduk();
}

class _FormEditProduk extends State<FormEditProduk> {
  String selectedTipe = '${EditScreen.dataProduk['tipe']}';
  TextEditingController txtNamaProduk =
      TextEditingController(text: '${EditScreen.dataProduk['nama']}');
  TextEditingController txtHargaProduk =
      TextEditingController(text: '${EditScreen.dataProduk['harga']}');
  TextEditingController txtQtyProduk =
      TextEditingController(text: '${EditScreen.dataProduk['qty']}');
  TextEditingController txtDeskripsiProduk =
      TextEditingController(text: '${EditScreen.dataProduk['deskripsi']}');

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
          buildQtyProduk(),
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
              : Image.network(
                  '$baseUrl/${EditScreen.dataProduk['gambar']}',
                  fit: BoxFit.cover,
                ),

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
                } else if (selectedTipe == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'tipe produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                } else if (txtHargaProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'harga produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                } else if (txtDeskripsiProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'deskripsi produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                } else if (txtQtyProduk.text == '') {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'stock produk tidak boleh kosong',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  EditData(
                      txtNamaProduk.text,
                      selectedTipe,
                      txtHargaProduk.text,
                      txtQtyProduk.text,
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

  DropdownButtonFormField<String> buildTipeProduk() {
    return DropdownButtonFormField<String>(
      value: selectedTipe,
      decoration: InputDecoration(
        labelText: 'Tipe Produk',
        hintText: 'Pilih tipe produk',
        labelStyle: TextStyle(
          color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.food_bank),
      ),
      items: <String>['Makanan', 'Minuman'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedTipe = newValue;
          });
        }
      },
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

  TextFormField buildQtyProduk() {
    return TextFormField(
      controller: txtQtyProduk,
      keyboardType: TextInputType.number,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Stock Produk',
          hintText: 'Masukkan Stock produk anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.production_quantity_limits)),
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

  void EditData(nama, tipe, harga, qty, deskripsi, gambar) async {
    bool status;
    var msg;
    try {
      var formData = FormData.fromMap({
        'nama': nama,
        'tipe': tipe,
        'harga': harga,
        'qty': qty,
        'deskripsi': deskripsi,
        'gambar': image == null ? '' : await MultipartFile.fromFile(gambar),
      });
      response = await dio.put('$urlEdit/${EditScreen.dataProduk['_id']}',
          data: formData);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan',
          desc: '$msg',
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
          desc: '$msg',
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
