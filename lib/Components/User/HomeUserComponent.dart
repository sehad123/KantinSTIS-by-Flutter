import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/User/Produk/DataProdukScreen.dart';
import 'package:kantin_stis/Screens/User/Transaksi/DataTransaksiUser.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class HomeUserComponent extends StatefulWidget {
  @override
  _HomesUserComponent createState() => _HomesUserComponent();
}

class _HomesUserComponent extends State<HomeUserComponent> {
  var dataTransaksi;

  Response? response;
  var dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Layanan",
                    style: mTitleStyle,
                  ),
                ),
                menuLayanan(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Data Transaksi Anda",
                    style: mTitleStyle,
                  ),
                ),
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

  Widget menuLayanan() {
    return Container(
      height: 70,
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, DataProdukScreen.routeName);
              },
              child: Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                padding: EdgeInsets.only(left: 16),
                height: 64,
                decoration: BoxDecoration(
                    color: mFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: mBorderColor, width: 1)),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/product.png",
                      height: 50,
                      width: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Produk",
                            style: mServiceTitleStyle,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "List Data Produk",
                            style: mServiceSubtitleStyle,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, DataTransaksiScreen.routeName);
              },
              child: Container(
                margin: EdgeInsets.only(left: 8, right: 8),
                padding: EdgeInsets.only(left: 16),
                height: 64,
                decoration: BoxDecoration(
                    color: mFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: mBorderColor, width: 1)),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/transaksi.png",
                      height: 50,
                      width: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Transaksi",
                            style: mServiceTitleStyle,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Data Transaksi ",
                            style: mServiceSubtitleStyle,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        )
      ]),
    );
  }

  Widget cardTransaksi(data) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, UploadBuktiPembayaranScreen.routeName,
        //     arguments: data);
      },
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
          child: Container(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.0, color: Colors.white24))),
                child:
                    Image.network('$baseUrl/${data['dataBarang']['gambar']}'),
              ),
              title: Text(
                "${data['dataBarang']['nama']} ",
                style:
                    TextStyle(color: mTitleColor, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Harga Rp. ${data['harga']} ",
                    style: TextStyle(
                        color: mTitleColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Jumlah Item : ${data['jumlah']} ",
                    style: TextStyle(
                        color: mTitleColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Total Rp. ${data['total']} ",
                    style: TextStyle(
                        color: mTitleColor, fontWeight: FontWeight.bold),
                  ),
                  data['buktiPembayaran'] == null
                      ? Text(
                          "Pending ",
                          style: TextStyle(
                              color: kColorYellow, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Berhasil ",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getDataTransaksi() async {
    bool status;
    var msg;
    try {
      response =
          await dio.get("$getTransaksiById/${UserScreen.dataUserLogin['_id']}");
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
        desc: 'Kesalahan Internal Server =>$msg',
        btnOkOnPress: () {},
      ).show();
    }
  }
}
