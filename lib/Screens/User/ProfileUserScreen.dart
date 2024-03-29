import 'package:flutter/material.dart';
import 'package:kantin_stis/Components/Admin/Crud/InputProduk/EditProduk/EditProdukComponent.dart';
import 'package:kantin_stis/Components/User/ProfileUserComponent.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class ProfileUserScreen extends StatelessWidget {
  static var routeName = '/profile_user_screen';
  static var data_user;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    data_user = ModalRoute.of(context)!.settings.arguments as Map;
    print(data_user);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: (ProfileUserComponent()),
    );
  }
}
