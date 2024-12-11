import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/category.dart';

import '../global_varibles.dart';

class CategoryControllers {
  Future<List<Category>> loadCategories() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$uri/api/categories"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories = data.map((category) => Category.fromJson(category)).toList();
        return categories;
      }
      else {
        throw Exception("Không nhận đc phản hồi từ DB");
      }
    }
    catch(e) {
      throw Exception("Lỗi kết nối");
    }
  }
}