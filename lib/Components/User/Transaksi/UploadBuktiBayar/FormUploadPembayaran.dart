import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/User/Transaksi/UploadBuktiBayar.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:image_picker/image_picker.dart';

class FormUploadPembayaran extends StatefulWidget {
  @override
  _FormUploadPembayaran createState() => _FormUploadPembayaran();
}

class _FormUploadPembayaran extends State<FormUploadPembayaran> {
  FocusNode focusNode = new FocusNode();
  File? image;

  Response? response;
  var dio = Dio();

  Future<void> _pickImage() async {
    final pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
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
                'Pilih Bukti Pembayaran ',
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
                uploadBukti(image!.path);
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

  void uploadBukti(gambar) async {
    bool status;
    var msg;
    try {
      var formData = FormData.fromMap({
        'buktiPembayaran': await MultipartFile.fromFile(gambar),
      });
      response = await dio.put(
          "$urluploadbutki/${UploadBuktiPembayaranScreen.dataTransaksi['_id']}",
          data: formData);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan',
          desc: 'Gambar Berhasil diupload => $msg',
          btnOkOnPress: () {
            Navigator.pushNamed(context, UserScreen.routeName,
                arguments: UserScreen.dataUserLogin);
          },
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan',
          desc: 'Gagal mengambil foto => $msg',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'terjadi kesalahan server \n => $msg',
        btnOkOnPress: () {},
      ).show();
    }
  }
}

// // Fungsi untuk mengupdate foto profil ke server
//   Future<void> _updateProfilePicture(gambar) async {
//     if (image != null) {
//       try {
//         FormData formData = FormData.fromMap({
//           "gambar": await MultipartFile.fromFile(
//             image!.path,
//             filename: "profile_image.png",
//           ),
//         });

//         Response response = await dio.put(
//           "$urluploadfoto/${ProfileUserScreen.data_user['_id']}",
//           data: formData,
//         );

//         if (response.statusCode == 200) {
//           // Gambar profil berhasil diperbarui
//           // Tambahkan logika atau pesan sukses di sini
//           print("Gambar profil berhasil diperbarui");
//         } else {
//           // Tambahkan logika atau pesan error jika update gagal
//           print("Gagal mengupdate gambar profil");
//         }
//       } catch (error) {
//         // Tangani error yang terjadi selama proses update
//         print("Error: $error");
//       }
//     }
//   }
