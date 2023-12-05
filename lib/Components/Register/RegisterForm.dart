import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Utils/constants.dart';

class SignUpform extends StatefulWidget {
  @override
  _SignUpForm createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpform> {
  final formKey = GlobalKey<FormState>();
  String? namalengkap;
  String? username;
  String? no_hp;
  String? Email;
  String? Password;

  TextEditingController txtUsername = TextEditingController(),
      txtPassword = TextEditingController(),
      txtNamalengkap = TextEditingController(),
      txtsaldo = TextEditingController(),
      txtnohp = TextEditingController(),
      txtEmail = TextEditingController();

  FocusNode focusNode = new FocusNode();

  Response? response;
  var dio = Dio();

  @override
  void initState() {
    // prosesRegistrasi();
    super.initState();
  }

  bool containsLetterAndDigit(String value) {
    bool hasLetter = false;
    bool hasDigit = false;

    for (int i = 0; i < value.length; i++) {
      if (value[i].toUpperCase() != value[i].toLowerCase()) {
        // Karakter adalah huruf
        hasLetter = true;
      } else if (int.tryParse(value[i]) != null) {
        // Karakter adalah angka
        hasDigit = true;
      }
    }

    return hasLetter && hasDigit;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildNamaLengkap(),
          SizedBox(height: 30),
          buildUserName(),
          SizedBox(height: 30),
          buildNoHp(),
          SizedBox(height: 30),
          buildSaldo(),
          SizedBox(height: 30),
          buildEmail(),
          SizedBox(height: 30),
          buildPassword(),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (txtPassword.text.length < 8) {
                  showErrorDialog("Error", "password minimal 8 karakter");
                } else if (!containsLetterAndDigit(txtPassword.text)) {
                  showErrorDialog(
                      "Error", "password harus kombinasi angka dan huruf");
                } else if (txtnohp.text.length <= 11 &&
                    txtnohp.text.length > 12) {
                  showErrorDialog("Error", "No hp harus 11 atau 12 digit");
                  ;
                } else if (!txtEmail.text.contains('@gmail.com')) {
                  showErrorDialog("Error", "email tidak valid");
                } else {
                  prosesRegistrasi(
                      txtUsername.text,
                      txtPassword.text,
                      txtNamalengkap.text,
                      txtEmail.text,
                      txtnohp.text,
                      txtsaldo.text);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Ganti dengan warna yang diinginkan
              ),
              child: Text(
                'Register',
                style: TextStyle(color: Colors.white), // Atur warna teks tombol
              ),
            ),
          ),
          SizedBox(
              height: 20), // Memberikan jarak antara tombol 'Login' dan 'Row'

          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              child: Text(
                "SUdah Punya Akun ? Login",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField buildUserName() {
    return TextFormField(
      controller: txtUsername,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Usename',
          hintText: 'Masukkan username anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.people)),
    );
  }

  TextFormField buildNamaLengkap() {
    return TextFormField(
      controller: txtNamalengkap,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Nama Lengkap',
          hintText: 'Masukkan Nama Lengkap anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.people_alt_outlined)),
    );
  }

  TextFormField buildEmail() {
    return TextFormField(
      controller: txtEmail,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Masukkan Email anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.email)),
    );
  }

  TextFormField buildNoHp() {
    return TextFormField(
      controller: txtnohp,
      keyboardType: TextInputType.number,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'No Hp',
          hintText: 'Masukkan No Hp anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.phone)),
    );
  }

  TextFormField buildSaldo() {
    return TextFormField(
      controller: txtsaldo,
      keyboardType: TextInputType.number,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Saldo ',
          hintText: 'Masukkan Saldo anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.money)),
    );
  }

  TextFormField buildPassword() {
    return TextFormField(
      controller: txtPassword,
      obscureText: true,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Masukkan password anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.password)),
    );
  }

  void prosesRegistrasi(userName, password, nama, email, no_hp, saldo) async {
    bool status;
    var msg;
    try {
      response = await dio.post(urlsignUp, data: {
        'username': userName,
        'password': password,
        'nama': nama,
        'email': email,
        'no_hp': no_hp,
        'saldo': saldo,
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
          desc: 'Berhasil Registrasi',
          btnOkOnPress: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        ).show();
      } else {
        showErrorDialog("Error", "$msg");
      }
    } catch (e) {
      showErrorDialog("Error", "$msg");
    }
  }

  void showErrorDialog(String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  void showSuccessDialog(String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }
}
