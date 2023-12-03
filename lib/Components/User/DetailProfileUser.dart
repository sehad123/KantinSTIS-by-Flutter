import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Screens/User/ProfileUserScreen.dart';
import 'package:kantin_stis/Screens/User/Transaksi/DataTransaksiUser.dart';
import 'package:kantin_stis/Utils/constants.dart';

class DetailProfileUser extends StatefulWidget {
  @override
  State<DetailProfileUser> createState() => _DetailProfileUserState();
}

class _DetailProfileUserState extends State<DetailProfileUser> {
  FocusNode focusNode = FocusNode();
  File? image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Response? response;
  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: image != null
                  ? ClipOval(
                      child: Image.file(
                        image!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        "assets/images/User.png",
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Selamat Datang ${ProfileUserScreen.data_user['nama']}",
            style: mTitleStyle,
          ),
          Text(
            "${ProfileUserScreen.data_user['email']}",
          ),
          SizedBox(height: 10),
          buildListTile("Ubah Password", "assets/images/pass.png", () {
            Navigator.pushNamed(context, 'ChangePassword');
          }),
          buildListTile("Informasi Saldo", "assets/images/saldo.png", () {
            Navigator.pushNamed(context, 'BalanceInfo');
          }),
          buildListTile("Tambah Saldo", "assets/images/plus.png", () {
            Navigator.pushNamed(context, 'AddBalance');
          }),
          buildListTile("Riwayat Belanja", "assets/images/check.png", () {
            Navigator.pushNamed(context, DataTransaksiScreen.routeName);
          }),
          buildListTile("Sign Out", "assets/images/logout.png", () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          }),
        ],
      ),
    );
  }

  Widget buildListTile(String title, String imagePath, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 24,
              width: 24,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
