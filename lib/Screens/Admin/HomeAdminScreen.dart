import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/Admin/AdminComponent.dart';
import 'package:kantin_stis/Screens/Admin/Crud/InputScreen.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class HomeAdminScreen extends StatelessWidget {
  static var routeName = "/home_admin";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Halaman Admin ",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        leading: const Icon(
          Icons.home,
          color: mTitleColor,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, InputScreen.routeName);
            },
            child: Row(children: const [
              Icon(Icons.add, color: mTitleColor),
              Text(
                "Input Data",
                style:
                    TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
              )
            ]),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: AdminComponent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.info,
            title: 'Peringatan',
            desc: 'Yakin Ingin Keluar dari aplikasi',
            btnCancelOnPress: () {},
            btnCancelText: 'Tidak',
            btnOkText: 'Yakin',
            btnOkOnPress: () {
              Navigator.pushNamed(context, LoginScreen.routeName);
            },
          ).show();
        },
        backgroundColor: kColorRedSlow,
        child: Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
