import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_do_an_chuyen_nganh_nhom3/global_varibles.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/product.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/services/manager_http_response.dart';

class ProductController {
  Future<void> uploadProduct({
    required context,
  required String productName,
  required int productPrice,
  required int quantity,
  required String description,
  required String category,
  required String vendorId,
  required String fullName,
  required String subCategory,
  required List<File>? pickedImage
  }) async{
    if(pickedImage != null) {
      final _cloudinary = CloudinaryPublic('dotszztq0', 'upload_nhom3');
        List<String> images = [];

      /*Vòng lặp duyệt qa tất cả image có trong mảng images*/
      for(var i=0; i < pickedImage.length; i++) {
        CloudinaryResponse cloudinaryResponse = await _cloudinary.uploadFile(CloudinaryFile.fromFile(pickedImage[i].path, folder: productName));
        images.add(cloudinaryResponse.secureUrl);
      }
      if(category.isNotEmpty && subCategory.isNotEmpty) {
        Product product = Product(
          id: '',
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images
        );
        http.Response response = await http.post(
          Uri.parse("$uri/api/add-product"),
          body: product.toJson(),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
        );
        managerHttpResponse(response: response, context: context, onSuccess: (){
          showSnackBar(context, "Bạn đã đăng sản phẩm thành công");
        });
      }
      else {
        showSnackBar(context, "Bạn hãy chọn category hoặc subcategory");
      }
    }
    else {
      showSnackBar(context, "Hãy chọn ít nhất 1 ảnh");
    }
  }
}