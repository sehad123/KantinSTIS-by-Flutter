// String baseUrl = 'http://localhost:5001';
// realme c53
String baseUrl = 'http://192.168.165.241:5001';
// realme 3
// String baseUrl = 'http://192.168.43.177:5001';
// wifi duta
// String baseUrl = 'http://192.168.100.172:5001';

//users
String urlsignIn = "$baseUrl/user/login";
String urluserbyid = "$baseUrl/user";
String urlgetuser = "$baseUrl/user";
String urlcekemailbyid = "$baseUrl/user/check-email";
String urlupdatesaldo = "$baseUrl/user/update-balance";
String urltambahsaldo = "$baseUrl/user/add-balance";
String urlminussaldo = "$baseUrl/user/minus-balance";
String urlsignUp = "$baseUrl/user/register";
String urluploadfoto = "$baseUrl/user/upload-foto";
String urlhapusfoto = "$baseUrl/user/delete-foto";
String urlchangepass = "$baseUrl/user/change-password";
String urlresetpass = "$baseUrl/user/reset-password";
String urlforgotpass = "$baseUrl/user/forgot-password";

// produk
String urlCreate = "$baseUrl/produk/create";
String urlEdit = "$baseUrl/produk/edit";
String urlgetAll = "$baseUrl/produk/getAll";
String urlHapus = "$baseUrl/produk/hapus";
String urlgetById = "$baseUrl/produk/getbyid";
String urlupdateProductQty = "$baseUrl/produk/updateqty";

// transaksi
String createTransaksi = "$baseUrl/transaksi/create";
String getallTransaksi = "$baseUrl/transaksi/getall";
String getTransaksi = "$baseUrl/transaksi/getbyiduser";
String urluploadbutki = "$baseUrl/transaksi/upload-bukti";
String getTransaksiById = "$baseUrl/transaksi/getbyiduserlimit";
