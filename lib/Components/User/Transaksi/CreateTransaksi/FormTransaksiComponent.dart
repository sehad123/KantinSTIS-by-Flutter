import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Components/default_button_cusomte_color.dart';
import 'package:kantin_stis/Screens/User/Transaksi/TransaksiScreen.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';
import 'package:kantin_stis/size_config.dart';

class TransaksiForm extends StatefulWidget {
  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

var amount = '';
var amount2 = '';

class _TransaksiFormState extends State<TransaksiForm> {
  var total = 0.0;
  var jumlahBeli = 0.0;
  var hargaProduk = TransaksiScreen.dataProduk['harga'];
  var stockQty = TransaksiScreen.dataProduk['qty'];
  Response? response;
  var dio = Dio();
  @override
  Widget build(BuildContext context) {
    print(TransaksiScreen.dataProduk);
    return Form(
        child: Column(
      children: [
        Image.network(
          "$baseUrl/${TransaksiScreen.dataProduk['gambar']}",
          width: 250,
          height: 250,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${TransaksiScreen.dataProduk['nama']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Harga Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rp ${TransaksiScreen.dataProduk['harga']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stock Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Update teks yang menampilkan Stock Produk
              Text(
                " $stockQty",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tipe Produk",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${TransaksiScreen.dataProduk['tipe']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Deskripsi",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${TransaksiScreen.dataProduk['deskripsi']}",
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jumlah Beli",
                style: mTitleStyle,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, top: 5),
          child: SpinBox(
            min: 0,
            max: (TransaksiScreen.dataProduk['qty']).toDouble(),
            value: jumlahBeli,
            onChanged: (value) {
              setState(() {
                jumlahBeli = value;
                stockQty =
                    TransaksiScreen.dataProduk['qty'] - jumlahBeli.toInt();
                total = jumlahBeli * hargaProduk;
              });
            },
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total ",
                    style: mTitleStyle,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp $total",
                    style: mTitleStyle,
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        DefaultButtonCustomeColor(
          color: kPrimaryColor,
          text: "Beli",
          press: () {
            if (total <= 0 || jumlahBeli <= 0) {
              AwesomeDialog(
                context: context,
                animType: AnimType.rightSlide,
                dialogType: DialogType.info,
                title: 'Peringatan ',
                desc: 'Jumlah pembelian minimal 1',
                btnOkOnPress: () {
                  print(TransaksiScreen.dataProduk['_id']);
                  print(UserScreen.dataUserLogin['_id']);
                },
              ).show();
            } else {
              AwesomeDialog(
                      context: context,
                      animType: AnimType.rightSlide,
                      dialogType: DialogType.info,
                      title: 'Peringatan ',
                      btnOkText: "Yakin",
                      btnCancelText: "Tidak",
                      desc:
                          'Yakin ingin melakukan pembelian ${TransaksiScreen.dataProduk['nama']}',
                      btnOkOnPress: () {
                        updateSaldoUser(
                          UserScreen.dataUserLogin['saldo'] - total,
                        );
                        minusQty(jumlahBeli.toInt());
                        minusBalance(total.toInt());
                        prosesTransaksi(
                            TransaksiScreen.dataProduk['_id'],
                            UserScreen.dataUserLogin['_id'],
                            jumlahBeli,
                            hargaProduk,
                            total);
                      },
                      btnCancelOnPress: () {})
                  .show();
            }
          },
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
      ],
    ));
  }

  void prosesTransaksi(idBarang, idUser, jumlah, harga, total) async {
    var saldoUser = UserScreen.dataUserLogin['saldo'];
    if (saldoUser >= total) {
      bool status;
      var msg;
      try {
        response = await dio.post(createTransaksi, data: {
          'idBarang': idBarang,
          'idUser': idUser,
          'jumlah': jumlah,
          'harga': harga,
          'total': total,
        });

        status = response!.data['sukses'];
        msg = response!.data['msg'];
        if (status) {
          AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.success,
            title: 'Peringatan ',
            desc: 'Transaksi Berhasil',
            btnOkOnPress: () {
              Navigator.pushNamed(context, UserScreen.routeName,
                  arguments: UserScreen.dataUserLogin);
            },
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            animType: AnimType.rightSlide,
            dialogType: DialogType.error,
            title: 'Peringatan ',
            desc: 'Gagal Transaksi => $msg',
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
    } else {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.warning,
        title: 'Peringatan',
        desc: 'Saldo Anda tidak mencukupi untuk pembelian ini',
        btnOkOnPress: () {},
      ).show();
    }
  }

  void updateSaldoUser(newSaldo) async {
    bool status;
    var msg;
    try {
      var formData = FormData.fromMap({
        'saldo': newSaldo,
      });
      response = await dio.put(
          "$urlupdatesaldo/${UserScreen.dataUserLogin['_id']}",
          data: formData);
      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        setState(() {
          UserScreen.dataUserLogin['saldo'] = newSaldo;
        });
        print('Saldo user diperbarui: $newSaldo dan $msg');
      } else {
        print('Gagal memperbarui saldo: $msg');
      }
    } catch (e) {
      print('Terjadi kesalahan saat memperbarui saldo: $e');
    }
  }

  Future<bool> minusQty(int stock) async {
    bool status;
    var msg;

    try {
      Response response = await dio.put(
        "$urlupdateProductQty/${TransaksiScreen.dataProduk['_id']}",
        data: {'stock': stock},
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['sukses'] != null) {
          status = response.data['sukses'];
          msg = response.data['msg'];

          if (status) {
            print(msg);
            TransaksiScreen.dataProduk['qty'] += stock;
            return true;
          } else {
            return false;
          }
        } else {
          print('Invalid response format');

          return false;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Tampilkan pesan error untuk respons yang tidak berhasil (status bukan 200)
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<bool> minusBalance(int addedBalance) async {
    bool status;
    var msg;

    try {
      Response response = await dio.put(
        "$urlminussaldo/${UserScreen.dataUserLogin['_id']}",
        data: {'addedBalance': addedBalance},
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['sukses'] != null) {
          status = response.data['sukses'];
          msg = response.data['msg'];

          if (status) {
            print(msg);
            UserScreen.dataUserLogin['saldo'] += addedBalance;
            return true;
          } else {
            return false;
          }
        } else {
          print('Invalid response format');

          return false;
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }
}
