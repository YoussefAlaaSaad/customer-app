// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Wish {
  final String productName;
  final int productPrice;
  final String category;
  final String image;
  final String vendorId;
  final int productQuantity;
  final int quantity;
  final String productId;
  final String description;
  final String name;

  Wish({required this.productName, required this.productPrice, required this.category, required this.image, required this.vendorId, required this.productQuantity, required this.quantity, required this.productId, required this.description, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productName': productName,
      'productPrice': productPrice,
      'category': category,
      'image': image,
      'vendorId': vendorId,
      'productQuantity': productQuantity,
      'quantity': quantity,
      'productId': productId,
      'description': description,
      'name': name,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      productName: map['productName'] as String,
      productPrice: map['productPrice'] as int,
      category: map['category'] as String,
      image: map['image'] as String,
      vendorId: map['vendorId'] as String,
      productQuantity: map['productQuantity'] as int,
      quantity: map['quantity'] as int,
      productId: map['productId'] as String,
      description: map['description'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wish.fromJson(String source) => Wish.fromMap(json.decode(source) as Map<String, dynamic>);
}
