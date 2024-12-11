import 'dart:convert';

import 'package:http/http.dart' as http;

import '../global_varibles.dart';
import '../models/sub_category.dart';

class SubcategoryController {
  Future<List<SubCategory>> getSubCategoryByCategoryName(String categoryName) async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/category/$categoryName/subcategories"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if(data.isNotEmpty) {
          return data.map((subcategory) => SubCategory.fromJson(subcategory)).toList() ;
        }
        else {
          print("Không tìm thấy sản phẩm con đó");
          return [];
        }
      }
      else if (response.statusCode == 404) {
        print("Không tìm thấy sản phẩm con đó");
        return [];
      }
      else {
        print("Lỗi truy vấn");
        return [];
      }
    }
    catch(e) {
      throw Exception(e);
      return [];
    }
  }
}