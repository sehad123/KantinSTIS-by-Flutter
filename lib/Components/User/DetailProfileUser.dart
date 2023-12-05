import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Screens/User/ProfileUserScreen.dart';
import 'package:kantin_stis/Screens/User/Transaksi/DataTransaksiBerhasil.dart';
import 'package:kantin_stis/Utils/constants.dart';

class DetailProfileUser extends StatefulWidget {
  @override
  State<DetailProfileUser> createState() => _DetailProfileUserState();
}

class _DetailProfileUserState extends State<DetailProfileUser> {
  TextEditingController txtTambahSaldo = TextEditingController(),
      txtPassLama = TextEditingController(),
      txtPassBaru = TextEditingController();
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
          Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  await _pickImage(); // Memilih gambar baru
                  uploadFoto(image!.path); // Mengirim gambar terpilih ke server
                },
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
                          // child: Image.network(
                          //   '$baseUrl/${ProfileUserScreen.data_user['gambar']}',
                          //   height: 150,
                          //   width: 130,
                          // ),
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
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.rightSlide,
                      dialogType: DialogType.info,
                      title: 'Peringatan',
                      desc: 'Yakin Ingin hapus foto',
                      btnCancelOnPress: () {},
                      btnCancelText: 'Tidak',
                      btnOkText: 'Yakin',
                      btnOkOnPress: () {
                        setState(() {
                          image = null;
                        });
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.rightSlide,
                          dialogType: DialogType.success,
                          title: 'Peringatan',
                          desc: 'Gambar Berhasil dihapus',
                          btnOkOnPress: () {},
                        ).show();
                      },
                    ).show();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Selamat Datang ${ProfileUserScreen.data_user['nama']}",
            style: mTitleStyle,
          ),
          Text(
            "${ProfileUserScreen.data_user['email']}",
          ),
          Text(
            "${ProfileUserScreen.data_user['no_hp']}",
          ),
          SizedBox(height: 10),
          buildListTile("Ubah Password", "assets/images/pass.png", () {
            _showChangePasswordDialog();
          }),
          buildListTile("Informasi Saldo", "assets/images/saldo.png", () {
            _showBalanceInfoModal(context);
          }),
          buildListTile("Tambah Saldo", "assets/images/plus.png", () {
            showAddBalanceDialog();
          }),
          buildListTile("Riwayat Belanja", "assets/images/check.png", () {
            Navigator.pushNamed(context, DataTransaksiBerhasil.routeName);
          }),
          buildListTile("Sign Out", "assets/images/logout.png", () {
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
          }),
        ],
      ),
    );
  }

  void uploadFoto(gambar) async {
    bool status;
    var msg;
    try {
      var formData = FormData.fromMap({
        'gambar': await MultipartFile.fromFile(gambar),
      });
      response = await dio.put(
          "$urluploadfoto/${ProfileUserScreen.data_user['_id']}",
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
            // Navigator.pushNamed(context, UserScreen.routeName,
            //     arguments: UserScreen.dataUserLogin);
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

// Method untuk menampilkan modal informasi saldo
  void _showBalanceInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Informasi Saldo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Rp ${ProfileUserScreen.data_user['saldo']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Fungsi untuk memunculkan dialog untuk mengubah password
  void _showChangePasswordDialog() {
    String oldPassword = '';
    String newPassword = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubah Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  oldPassword = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  newPassword = value;
                },
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
            TextButton(
              onPressed: () async {
                if (newPassword.length < 8 ||
                    !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])')
                        .hasMatch(newPassword)) {
                  // Validasi password baru (minimal 8 karakter dan kombinasi huruf dan angka)
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc:
                        'Password minimal harus 8 karakter dan kombinasi huruf dan angka',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  var success = await changePassword(oldPassword, newPassword);

                  if (success != null && success) {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.rightSlide,
                      dialogType: DialogType.success,
                      title: 'Sukses',
                      desc: 'Password berhasil diubah',
                      btnOkOnPress: () {
                        Navigator.pop(context);
                      },
                    ).show();
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.rightSlide,
                      dialogType: DialogType.error,
                      title: 'Peringatan',
                      desc: 'Password lama Anda salah',
                      btnOkOnPress: () {},
                    ).show();
                  }
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    bool status;
    var msg;
    var dataUser;
    try {
      Response response = await dio
          .put("$urlchangepass/${ProfileUserScreen.data_user['_id']}", data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      status = response!.data['sukses'];
      msg = response!.data['msg'];

      if (status) {
        print(msg);
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Sukses',
          desc: 'Password berhasil diubah',
          btnOkOnPress: () {},
        ).show();
        Navigator.pop(context);
        return true;
      } else {
        print(msg);

        return false;
      }
    } catch (error) {
      print('Error: $error');
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'Terjadi kesalahan pada server => $error',
        btnOkOnPress: () {},
      ).show();
      return false;
    }
  }

  Future<void> showAddBalanceDialog() async {
    String amount = '';

    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Saldo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Top Up Saldo',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  amount = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (amount.isEmpty ||
                    int.tryParse(amount) == null ||
                    int.parse(amount) <= 0) {
                  // Validasi jika input tidak valid
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'Masukkan jumlah saldo yang valid',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  var success = await addBalance(int.parse(amount));
                  if (success) {
                    // Perbarui saldo secara langsung pada tampilan
                    setState(() {
                      ProfileUserScreen.data_user['saldo'] += int.parse(amount);
                    });

                    // Refresh halaman
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DetailProfileUser(),
                      ),
                    );
                  }
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.error,
                    title: 'Peringatan',
                    desc: 'Saldo berhasil ditambahkan',
                    btnOkOnPress: () {},
                  ).show();
                  Navigator.pop(context, success);
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> addBalance(int addedBalance) async {
    bool status;
    var msg;

    try {
      Response response = await dio.put(
        "$urltambahsaldo/${ProfileUserScreen.data_user['_id']}",
        data: {'addedBalance': addedBalance},
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['sukses'] != null) {
          status = response.data['sukses'];
          msg = response.data['msg'];

          if (status) {
            print(msg);
            // Tambahkan dialog atau logika sukses di sini
            AwesomeDialog(
              context: context,
              animType: AnimType.rightSlide,
              dialogType: DialogType.error,
              title: 'Peringatan',
              desc: 'Saldo berhasil ditambahkan $msg',
              btnOkOnPress: () {},
            ).show();
            return true;
          } else {
            AwesomeDialog(
              context: context,
              animType: AnimType.rightSlide,
              dialogType: DialogType.success,
              title: 'Peringgatan',
              desc: 'Saldo berhasil ditambahkan ',
              btnOkOnPress: () {
                Navigator.pop(context);
              },
            ).show();
            // Refresh halaman
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DetailProfileUser(),
              ),
            );
            print(msg);
            // Tambahkan dialog atau logika error di sini
            return false;
          }
        } else {
          print('Invalid response format');
          AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.success,
            title: 'Peringgatan',
            desc: 'Saldo berhasil ditambahkan ',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
          ).show();
          // Tambahkan dialog atau logika untuk respons tidak valid di sini
          return false;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Tambahkan dialog atau logika error di sini jika respons tidak 200
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan',
          desc: msg,
          btnOkOnPress: () {},
        ).show();
        return false;
      }
    } catch (error) {
      print('Error: $error');
      // Tambahkan dialog atau logika error di sini untuk error lainnya
      return false;
    }
  }
}
