import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/User/Transaksi/TransaksiScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class ProdukComponent extends StatefulWidget {
  @override
  State<ProdukComponent> createState() => _ProdukComponentState();
}

class _ProdukComponentState extends State<ProdukComponent> {
  Response? response;
  var dio = Dio();
  var dataProduk;
  var filteredData = []; // Variable untuk menyimpan data hasil filter pencarian
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataProduk();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            // Widget untuk input pencarian
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari Produk...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filterData(value);
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: filteredData
                      .isEmpty // Ubah penanganan kasus ketika filteredData kosong
                  ? Center(
                      child: Text(
                        'Produk tidak ditemukan', // Tampilkan pesan 'Produk tidak ditemukan'
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: filteredData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardProduk(filteredData[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardProduk(data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TransaksiScreen.routeName,
            arguments: data);
      },
      child: Card(
        elevation: 10.0,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: 100,
                    child: Image.network(
                      '$baseUrl/${data['gambar']}',
                      height: 150,
                      width: 130,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "${data['nama']} ",
                  style: TextStyle(
                      color: mTitleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Center(
                child: Text(
                  " Rp ${data['harga']} ",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10.0), // Ubah nilai sesuai keinginan
                    color: Colors.blue[200],
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Text(
                    "Pesan Sekarang",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          print(dataProduk);
          filteredData.addAll(
              dataProduk); // Tambahkan ini untuk memastikan filteredData diisi saat data produk ditemukan
        });
      } else {
        setState(() {
          dataProduk = []; // Set dataProduk kosong saat produk tidak ditemukan
        });
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

  void filterData(String query) {
    List<dynamic> filteredList = [];
    if (query.isNotEmpty) {
      dataProduk.forEach((item) {
        if (item['nama'].toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(item);
        }
      });
    } else {
      filteredList.addAll(dataProduk);
    }
    setState(() {
      filteredData = filteredList;
    });
  }
}
