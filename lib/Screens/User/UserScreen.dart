import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/User/HomeUserComponent.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Screens/User/ProfileUserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class UserScreen extends StatelessWidget {
  static String routeName = "/user_screen";
  static var dataUserLogin;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    dataUserLogin = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "KANTIN STIS",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
        leading: Icon(
          Icons.home,
          color: mTitleColor,
          size: 30,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProfileUserScreen.routeName,
                  arguments: dataUserLogin);
            },
            child: Icon(
              Icons.person,
              color: mTitleColor,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: HomeUserComponent(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
