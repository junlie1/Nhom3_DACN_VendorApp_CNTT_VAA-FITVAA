import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/global_varibles.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/vendor.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/vender_provider.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/services/manager_http_response.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/authenication/login_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/main_vendor_screen.dart';

class VendorAuthController {
  /*Import sử dụng thư viên*/
  ProviderContainer providerContainer = ProviderContainer();

  Future<void> signUpVendor({
    required context,
    required String fullName,
    required String email,
    required String password
  }) async{
    try{
      Vendor vendor = Vendor(
          id: '', 
          fullName: fullName,
          email: email,
          state: '', 
          city: '', 
          locality: '', 
          role: '', 
          password: password
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/vendor/signup"),
        body: vendor.toJson(),
        headers: <String, String> {
          "Content-Type" : 'application/json; charset=UTF-8',
        }
      );
      managerHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Bạn đã đăng ký tài khoản thành công");
          }
      );
    }
    catch(e) {

    }
  }

  /*SignIn Vendor*/
  Future<void> signInVendor({required context, required email, required password})async{
    try {
      http.Response response = await http.post(
          Uri.parse('$uri/api/vendor/signin'),
          body: jsonEncode({
            'email':email,
            'password': password}),
          headers: <String, String> {
            "Content-Type" : 'application/json; charset=UTF-8',
          });
      managerHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            /*Lưu trữ thông tin user bằng SharedPreferences*/
            //Khởi tạo SharedPreferences
            SharedPreferences preferences = await SharedPreferences.getInstance();

            //Giải mã token từ body để sử dụng trong app
            String token = jsonDecode(response.body)['token'];
            await preferences.setString('auth_token', token);

            // Mã hóa user data nhận được từ backend trả về không lấy password trong vendor.js
            final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);
            providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);

            //Lưu trữ dữ liệu user cho sau này sử dụng
            await preferences.setString('vendor', vendorJson);

            /* Navigator.pushAndRemoveUntil(context, newRoute, predicate)
      Là đẩy sang trang mới và xóa dữ liệu trang cũ
      predicate là một hàm bool Function(Route) trả về giá trị true hoặc false */
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainVendorScreen()), (route)=> false
            );
            showSnackBar(context, "Bạn đã đăng nhập thành công");
          });
    }
    catch(e) {
      print("Error: $e");
    }
  }

  /*Đăng xuất Vendor*/
  Future<void> signOutVendor({required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      //Xóa thông tin theo key
      preferences.remove('auth_token');
      preferences.remove('vendor');
      providerContainer.read(vendorProvider.notifier).signOutVender();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), (route)=> false
      );
      showSnackBar(context, "Bạn đã đăng xuất thành công");
    }
    catch(e) {
      print("Error: $e");
    }
  }
}