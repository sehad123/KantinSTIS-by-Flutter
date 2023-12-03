import 'package:flutter/material.dart';
import 'package:kantin_stis/Screens/User/EditUserScreen.dart';
import 'package:kantin_stis/Screens/User/Produk/DataProdukScreen.dart';
import 'package:kantin_stis/Screens/Admin/Crud/EditProdukScreen.dart';
import 'package:kantin_stis/Screens/Admin/Crud/InputScreen.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Screens/Register/Registrasi.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Screens/User/Transaksi/DataTransaksiUser.dart';
import 'package:kantin_stis/Screens/User/Transaksi/TransaksiScreen.dart';
import 'package:kantin_stis/Screens/User/Transaksi/UploadBuktiBayar.dart';
import 'package:kantin_stis/Screens/User/UserByIdScreen.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';

final Map<String, WidgetBuilder> routes = {
  // route login & register
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),

  // route admin
  HomeAdminScreen.routeName: (context) => HomeAdminScreen(),
  InputScreen.routeName: (context) => InputScreen(),
  EditScreen.routeName: (context) => EditScreen(),

  // route user
  UserScreen.routeName: (context) => UserScreen(),
  DataProdukScreen.routeName: (context) => DataProdukScreen(),
  TransaksiScreen.routeName: (context) => TransaksiScreen(),
  DataTransaksiScreen.routeName: (context) => DataTransaksiScreen(),
  EditUserScreen.routeName: (context) => EditUserScreen(),
  UserByIdScreen.routeName: (context) => UserByIdScreen(),
  UploadBuktiPembayaranScreen.routeName: (context) =>
      UploadBuktiPembayaranScreen(),

  // Transaksi
};
