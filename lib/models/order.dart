import 'dart:convert';

class Order {
  final String id;
  final String fullName;
  final String email;
  final String city;
  final String locality;
  final String phoneNumber;
  final String productName;
  final int productPrice;
  final int quantity;
  final String category;
  final String image;
  final String buyerId;
  final String vendorId;
  final bool processing;
  final bool shipping;
  final bool delivered;

  Order({
    required this.id,
    required this.fullName,
    required this.email,
    required this.city,
    required this.locality,
    required this.phoneNumber,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.category,
    required this.image,
    required this.buyerId,
    required this.vendorId,
    required this.processing,
    required this.shipping,
    required this.delivered
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'city': city,
      'locality': locality,
      'phoneNumber': phoneNumber,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'category': category,
      'image': image,
      'buyerId': buyerId,
      'vendorId': vendorId,
      'processing': processing,
      'shipping': shipping,
      'delivered': delivered
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Order.fromJson(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      city: map['city'] as String? ?? '',
      locality: map['locality'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      productPrice: map['productPrice'] as int? ?? 0,
      quantity: map['quantity'] as int? ?? 0,
      category: map['category'] as String? ?? '',
      image: map['image'] as String? ?? '',
      buyerId: map['buyerId'] as String? ?? '',
      vendorId: map['vendorId'] as String? ?? '',
      processing: map['processing'] as bool? ?? false,
      shipping: map['shipping'] as bool? ?? false,
      delivered: map['delivered'] as bool? ?? false,
    );
  }
}
