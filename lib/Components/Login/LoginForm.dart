import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Screens/Register/Registrasi.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';

class SignInform extends StatefulWidget {
  @override
  _SignInForm createState() => _SignInForm();
}

class _SignInForm extends State<SignInform> {
  final formKey = GlobalKey<FormState>();
  String? username;
  String? Password;
  bool? remember = false;

  TextEditingController txtUsername = TextEditingController(),
      txtPassword = TextEditingController();

  FocusNode focusNode = new FocusNode();

  Response? response;
  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildUserName(),
          SizedBox(height: 30),
          buildPassword(),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                prosesLogin(txtUsername.text, txtPassword.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Ganti dengan warna yang diinginkan
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Atur warna teks tombol
              ),
            ),
          ),
          SizedBox(
              height: 10), // Memberikan jarak antara tombol 'Login' dan 'Row'

          Row(
            children: [
              Checkbox(
                  value: remember,
                  onChanged: (value) {
                    setState(() {
                      remember = value;
                    });
                  }),
              Text(
                "Tetap Masuk",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showForgetPasswordDialog();
                },
                child: Text(
                  "Lupa Password",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue[400],
                      fontSize: 16),
                ),
              )
            ],
          ),

          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RegisterScreen.routeName);
            },
            child: Text(
              "Belum Punya Akun ? Register ",
              style:
                  TextStyle(decoration: TextDecoration.underline, fontSize: 16),
            ),
          ),
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

  void prosesLogin(userName, password) async {
    bool status;
    var msg;
    var dataUser;
    try {
      response = await dio.post(urlsignIn, data: {
        'username': userName,
        'password': password,
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
          desc: 'Berhasil Login',
          btnOkOnPress: () {
            dataUser = response!.data['data'];
            if (dataUser['role'] == 1) {
              Navigator.pushNamed(context, UserScreen.routeName,
                  arguments: dataUser);
              print("ke halaman user");
            } else if (dataUser['role'] == 2) {
              Navigator.pushNamed(context, HomeAdminScreen.routeName);
              print("ke halaman admin ");
            } else {
              print("Halaman tidak tersedia");
            }
          },
        ).show();
      } else {
        // print("Gagal");
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan ',
          desc: 'gagal Login => $msg',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan ',
        desc: 'Terjadi Kesalahan Server',
        btnOkOnPress: () {},
      ).show();
    }
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

  void showForgetPasswordDialog() {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan Username'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                checkUsername(usernameController.text);
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void checkUsername(String username) async {
    try {
      Response response = await Dio().post(
        "$urlforgotpass",
        data: {
          'username': username,
        },
      );

      if (response.statusCode == 200) {
        var userData = response.data['data'];
        showEmailDialog(username, userData['_id']);
      } else {
        showErrorDialog(
            'Username tidak terdaftar', 'Username tidak terdaftar.');
      }
    } catch (e) {
      showErrorDialog('Error', 'Terjadi kesalahan saat memproses permintaan.');
    }
  }

  void showEmailDialog(String username, String userId) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan Email Anda'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!emailController.text.contains('@gmail.com')) {
                  showErrorDialog("Error", "email tidak valid");
                } else {
                  checkEmail(username, userId, emailController.text);
                }
              },
              child: Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void checkEmail(String username, String userId, String email) async {
    try {
      Response response = await Dio().post(
        "$urlcekemailbyid/$userId",
        data: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        var result = response.data;
        if (result['success']) {
          showResetPasswordDialog(email, userId);
        } else {
          showErrorDialog(
              'Email tidak sesuai', 'Email tidak sesuai dengan data pengguna.');
        }
      } else {
        showErrorDialog('Error', 'Terjadi kesalahan saat memeriksa email.');
      }
    } catch (e) {
      showErrorDialog('Error', 'Email tidak sesuai pada saat registrasi.');
    }
  }

  void showResetPasswordDialog(String email, String userId) {
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan Password baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text.length < 8)
                  showErrorDialog(
                      "Error", "Password minimal harus 8 karakter ");
                else if (!containsLetterAndDigit(newPasswordController.text))
                  showErrorDialog(
                      "Error", "Password harus berupa huruf dan angka ");
                else
                  updatePassword(userId, newPasswordController.text);
              },
              child: Text('Reset Password'),
            ),
          ],
        );
      },
    );
  }

  void updatePassword(String userId, String newPassword) async {
    try {
      Response response = await Dio().put(
        "$urlresetpass/$userId",
        data: {
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Berhasil",
          desc: "Password berhasil di reset, silahkan login",
          btnOkOnPress: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        ).show();
      } else {
        showErrorDialog('Gagal mereset password',
            'Terjadi kesalahan saat mereset password.');
      }
    } catch (e) {
      showErrorDialog('Error', 'Terjadi kesalahan saat memproses permintaan.');
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
