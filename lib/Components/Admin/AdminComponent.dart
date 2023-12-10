import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Admin/Crud/DetailProductScreen.dart';
import 'package:kantin_stis/Screens/Admin/Crud/EditProdukScreen.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class AdminComponent extends StatefulWidget {
  @override
  _AdminComponent createState() => _AdminComponent();
}

class _AdminComponent extends State<AdminComponent> {
  Response? response;
  var dio = Dio();
  var dataProduk;
  var datauser;
  var dataTransaksi;
  var dataOmset;
  int totalOmset = 0; // Menyimpan jumlah total omset

  @override
  void initState() {
    super.initState();
    getDataProduk();
    getJumlahTransaksi();
    getJumlahUser();
    getTotalJumlah();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                  children: [
                    buildCardWithNumber(
                        Icons.food_bank, dataProduk?.length ?? 0),
                    buildCardWithNumber(Icons.person, datauser?.length ?? 0),
                    buildCardWithNumber(
                        Icons.list_alt, dataTransaksi?.length ?? 0),
                    buildCardWithNumber(
                        Icons.monetization_on_outlined, totalOmset ?? 0),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: dataProduk == null ? 0 : dataProduk!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return cardProduk(dataProduk[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun card dengan angka
  Widget buildCardWithNumber(IconData icon, int number) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 3),
            Text(
              icon == Icons.monetization_on_outlined
                  ? "Rp " + formatRupiah(int.parse(number.toString()))
                  : number
                      .toString(), // Tampilkan angka atau format Rupiah untuk total omset
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String formatRupiah(int nominal) {
    String nominalString = nominal.toString();
    String result = "";
    int count = 0;
    for (int i = nominalString.length - 1; i >= 0; i--) {
      result = nominalString[i] + result;
      count++;
      if (count % 3 == 0 && count != nominalString.length) {
        result = "." + result;
      }
    }
    return result;
  }

  Widget cardProduk(data) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
            child: Image.network('$baseUrl/${data['gambar']}'),
          ),
          title: Text(
            "${data['nama']} ",
            style: TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, EditScreen.routeName,
                      arguments: data);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: kColorYellow,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                          color: mTitleColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              GestureDetector(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.rightSlide,
                    dialogType: DialogType.info,
                    title: 'Peringatan',
                    desc: ' Yakin ingin hapus ${data['nama']} ?...',
                    btnCancelText: 'Tidak',
                    btnOkText: 'Yakin',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      getHapusProduk('${data['_id']}');
                    },
                  ).show();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: kColorRedSlow,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Hapus",
                      style: TextStyle(
                          color: mTitleColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, DetailProductScreen.routeName,
                  arguments: data);
            },
            child: Icon(
              Icons.keyboard_arrow_right,
              color: mTitleColor,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }

  void getJumlahUser() async {
    bool status;
    var msg;
    try {
      response = await dio.get(urlgetuser);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        setState(() {
          datauser = response!.data['data'];
          // datauser.length;
          print(datauser);
        });
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan',
          desc: ' produk tidak ditemukan',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'Kesalahan Internal Server',
        btnOkOnPress: () {},
      ).show();
    }
  }

  void getJumlahTransaksi() async {
    bool status;
    var msg;
    try {
      response = await dio.get(getallTransaksi);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        setState(() {
          dataTransaksi = response!.data['data'];
          // dataTransaksi.length;
          print(dataTransaksi);
        });
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan',
          desc: ' produk tidak ditemukan',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'Kesalahan Internal Server',
        btnOkOnPress: () {},
      ).show();
    }
  }

  void getTotalJumlah() async {
    bool status;
    var msg;
    try {
      response = await dio.get(getallTransaksi);
      status = response!.data['sukses'];
      msg = response!.data['msg'];

      if (status) {
        setState(() {
          dataOmset = response!.data['data'];

          // Menghitung total omset dari nilai atribut 'total'
          totalOmset = calculateTotalOmset(dataOmset);
          print('Total Omset: $totalOmset');
        });
      } else {
        throw Exception('Gagal mendapatkan jumlah transaksi');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

// Fungsi untuk menghitung total omset
  int calculateTotalOmset(List<dynamic>? data) {
    int total = 0;
    if (data != null) {
      for (var transaksi in data) {
        total += double.parse(transaksi['total'].toString()).round();
      }
    }
    return total;
  }

  void getDataProduk() async {
    bool status;
    var msg;
    try {
      response = await dio.get(urlgetAll);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        setState(() {
          dataProduk = response!.data['data'];
          // dataProduk.length;
          print(dataProduk);
        });
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan',
          desc: ' produk tidak ditemukan',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'Kesalahan Internal Server',
        btnOkOnPress: () {},
      ).show();
    }
  }

  void getHapusProduk(id) async {
    bool status;
    var msg;
    try {
      response = await dio.delete('$urlHapus/$id');
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan',
          desc: ' $msg',
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
          desc: ' produk tidak ditemukan',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      print(e);
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan',
        desc: 'Kesalahan Internal Server',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
