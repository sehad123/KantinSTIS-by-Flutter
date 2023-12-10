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

enum ProductType { All, Food, Drink } // Tambahkan enum untuk tipe produk

class _ProdukComponentState extends State<ProdukComponent> {
  ProductType _selectedType = ProductType
      .All; // Tambahkan variabel untuk menyimpan tipe produk terpilih
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
            SizedBox(height: 10),
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
            Container(
              margin: EdgeInsets.only(left: 250),
              child: DropdownButton<ProductType>(
                value: _selectedType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                    filterByType(
                        _selectedType); // Panggil fungsi filter berdasarkan tipe
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: ProductType.All,
                    child: Text('Semua'),
                  ),
                  DropdownMenuItem(
                    value: ProductType.Food,
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem(
                    value: ProductType.Drink,
                    child: Text('Minuman'),
                  ),
                ],
              ),
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

  void filterByType(ProductType selectedType) {
    List<dynamic> filteredList = [];
    if (selectedType == ProductType.All) {
      filteredList.addAll(dataProduk);
    } else {
      dataProduk.forEach((item) {
        if (selectedType == ProductType.Food && item['tipe'] == 'Makanan') {
          filteredList.add(item);
        } else if (selectedType == ProductType.Drink &&
            item['tipe'] == 'Minuman') {
          filteredList.add(item);
        }
      });
    }
    setState(() {
      filteredData = filteredList;
    });
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
        child: Container(
          height: 300, // Atur tinggi card di sini
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      child: Image.network(
                        '$baseUrl/${data['gambar']}',
                        height: 150,
                        fit: BoxFit.cover,
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
                      fontSize: 16,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    " Rp ${data['harga']} ",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.blue[400],
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
