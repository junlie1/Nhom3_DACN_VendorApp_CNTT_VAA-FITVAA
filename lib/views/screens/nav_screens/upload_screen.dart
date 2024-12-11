import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/controllers/product_controller.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/controllers/subcategory_controller.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/category.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/sub_category.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/vender_provider.dart';

import '../../../controllers/category_controller.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final ImagePicker picker = ImagePicker();
  List<File> images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProductController _productController = ProductController();

  ////Khai báo Category để chọn Sub theo name
  late Future<List<Category>> futureCategories;
  Future<List<SubCategory>>? futureSubcategories;
  Category? selectedCategory;
  SubCategory? selectedSubcategory;
  late String productName;
  late int productPrice;
  late int quantity;
  late String description;

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryControllers().loadCategories();
  }

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile == null) {
      print("Không có ảnh đc chọn");
    }
    else {
      /*Nếu có ảnh thì setState, thêm đường dẫn ảnh của object File vào images*/
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  getSubcategoryByCategoryName(value) {
      setState(() {
        futureSubcategories = SubcategoryController().getSubCategoryByCategoryName(value.name);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: images.length + 1, //Bao gồm cả button add product
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4
              ),
              itemBuilder: (context,index) {
                /* Kiểm tra có sản phẩm nào chưa */
                return index == 0
                    ? Center(
                  child: IconButton(
                      onPressed: () {
                        chooseImage();
                      },
                      icon: Icon(Icons.add)
                  ),
                )
                    : SizedBox(
                  width: 50,
                  height: 40,
          /*Vì index == 0 là button add, nên phải trừ 1 của cái đó đi sẽ ra list images*/
                  child: Image.file(images[index - 1]),
                );
              }
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Product Name
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            onChanged: (value) {
                              productName = value;
                            },
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Hãy nhập tên sản phẩm";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Tên sản phẩm",
                                hintText: "Nhập tên sản phẩm",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              productPrice = int.parse(value);
                            },
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Hãy nhập giá sản phẩm";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: " Giá sản phẩm",
                                hintText: "Nhập giá sản phẩm",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              quantity = int.parse(value);
                            },
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Hãy nhập số lượng sản phẩm";
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Số lượng sản phẩm",
                                hintText: "Nhập số lượng sản phẩm",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

      /*Chọn Category*/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: futureCategories,
                            builder: (context,snapshot) {
                              if(snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text("Không có dữ liệu của Categories trong DB"),
                                );
                              }
                              else if(snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              }
                              else {
                                return DropdownButton<Category>(
                                    value: selectedCategory,
                                    hint: Text("Chọn Category"),
                                    items: snapshot.data!.map((Category category){
                                      return DropdownMenuItem(
                                          value: category,
                                          child: Text(category.name)
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value;
                                      });
                                      getSubcategoryByCategoryName(selectedCategory);
                                    }
                                );
                              }
                        }),
                      ],
                    ),
                  ),

      /*Chọn Subcategory theo CategoryName*/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Column(
                      children: [
                        futureSubcategories != null ? FutureBuilder(
                          future: futureSubcategories,
                          builder: (context,snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Text("Không có dữ liệu của Subcategories trong DB"),
                              );
                            }
                            else if(snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            }
                            else {
                              return DropdownButton<SubCategory>(
                                  value: selectedSubcategory,
                                  hint: Text("Chọn Subcategory"),
                                  items: snapshot.data!.map((SubCategory subcategory){
                                    return DropdownMenuItem(
                                        value: subcategory,
                                        child: Text(subcategory.subCategoryName)
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSubcategory = value;
                                    });
                                  }
                              );
                            }
                          },
                        ) : Text("Hãy chọn Category để hiển thị Subcategory")
                      ],
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextFormField(
                            onChanged: (value) {
                              description = value;
                            },
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Hãy nhập mô tả sản phẩm";
                              }
                              else{
                                return null;
                              }
                            },
                            minLines: 3,
                            maxLines: 500,
                            decoration: InputDecoration(
                                labelText: "Mô tả sản phẩm",
                                hintText: "Nhập mô tả sản phẩm",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          final fullName = ref.read(vendorProvider)!.fullName;
                          final vendorId = ref.read(vendorProvider)!.id;
                          if(_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                         await _productController.uploadProduct(
                            context: context,
                            productName: productName,
                            productPrice: productPrice,
                            quantity: quantity,
                            description: description,
                            category: selectedCategory!.name,
                            vendorId: vendorId,
                            fullName: fullName,
                            subCategory: selectedSubcategory!.subCategoryName,
                            pickedImage: images)
                             .whenComplete(() {
                               setState(() {
                                 isLoading = false;
                               });
                               selectedSubcategory = null;
                               selectedCategory = null;
                               images.clear();
                             });
                          }
                          else {
                            print("Nhập đầy đủ sản phẩm");
                          }
                        },
                        child: isLoading ? CircularProgressIndicator(color: Colors.white) : Text("Upload Product")
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
