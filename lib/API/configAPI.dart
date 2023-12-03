// String baseUrl = 'http://localhost:5001';
String baseUrl = 'http://192.168.184.241:5001';
// String baseUrl = 'http://192.168.100.172:5001';

//users
String urlsignIn = "$baseUrl/user/login";
String urlsignUp = "$baseUrl/user/register";

// crud produk
String urlCreate = "$baseUrl/gitar/create";
String urlEdit = "$baseUrl/gitar/edit";
String urlgetAll = "$baseUrl/gitar/getAll";
String urlHapus = "$baseUrl/gitar/hapus";
String urlgetById = "$baseUrl/gitar/getbyid";

// transaksi
String createTransaksi = "$baseUrl/transaksi/create";
String getTransaksi = "$baseUrl/transaksi/getbyiduser";
String urluploadbutki = "$baseUrl/transaksi/upload-bukti";
String getTransaksiById = "$baseUrl/transaksi/getbyiduserlimit";
