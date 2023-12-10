import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class DataTransaksiComponentBerhasil extends StatefulWidget {
  @override
  State<DataTransaksiComponentBerhasil> createState() =>
      _DataTransaksiComponentBerhasilState();
}

class _DataTransaksiComponentBerhasilState
    extends State<DataTransaksiComponentBerhasil> {
  Response? response;
  var dio = Dio();
  var dataTransaksi;

  @override
  void initState() {
    super.initState();
    getDataTransaksi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(20),
              vertical: getProportionateScreenHeight(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataTransaksi == null ? 0 : dataTransaksi.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cardTransaksi(dataTransaksi[index]);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardTransaksi(data) {
    return data['buktiPembayaran'] != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  Tanggal Pemesanan :             ${data['tanggal']}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  elevation: 10.0,
                  margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical:
                          8.0), // Mengubah margin vertical untuk memberikan jarak antar card
                  color: Colors.grey[100], // Ubah warna latar belakang card
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 7.0,
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(right: 2.0),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1.0,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                        child: Image.network(
                          '$baseUrl/${data['dataBarang']['gambar']}',
                        ),
                      ),
                      title: Text(
                        "Menu : ${data['dataBarang']['nama']} ",
                        style: TextStyle(
                          color: Colors.black, // Ubah warna teks judul
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Harga Rp. ${data['harga']} ",
                            style: TextStyle(
                              color: Colors.black, // Ubah warna teks subtitle
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Jumlah Item : ${data['jumlah']} ",
                            style: TextStyle(
                              color: Colors.black, // Ubah warna teks subtitle
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Total Rp. ${data['total']} ",
                            style: TextStyle(
                              color: Colors.black, // Ubah warna teks subtitle
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Status : Berhasil ",
                            style: TextStyle(
                              color: Colors.green, // Ubah warna teks "Berhasil"
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Text(
            "",
            style: mTitleStyle,
          );
  }

  void getDataTransaksi() async {
    bool status;
    var msg;
    try {
      response =
          await dio.get("$getTransaksi/${UserScreen.dataUserLogin['_id']}");
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        setState(() {
          dataTransaksi = response!.data['data'];
          print(dataTransaksi);
        });
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan',
          desc: 'Produk tidak ditemukan',
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
