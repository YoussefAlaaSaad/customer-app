// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Product {
  final String id;
  final String productName;
  final int productPrice;
  final int quantity;
  final String description;
  final String category;
  final String vendorId;
  final String name;
  final String subCategory;
  final List<String> images;
  final double averageRating;
  final int totalRatings;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.description,
    required this.category,
    required this.vendorId,
    required this.name,
    required this.subCategory,
    required this.images,
    required this.averageRating,
    required this.totalRatings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'description': description,
      'category': category,
      'vendorId': vendorId,
      'name': name,
      'subCategory': subCategory,
      'images': images,
      'averageRating': averageRating,
      'totalRatings': totalRatings,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id']?.toString() ?? '',
      productName: map['productName']?.toString() ?? '',
      productPrice: (map['productPrice'] ?? 0).toInt(),
      quantity: (map['quantity'] ?? 0).toInt(),
      description: map['description']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      vendorId: map['vendorId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      subCategory: map['subCategory']?.toString() ?? '',
      images: List<String>.from((map['images'] ?? []).map((e) => e.toString())),
      averageRating: map['averageRating'] == null
          ? 0.0
          : (map['averageRating'] is int
              ? (map['averageRating'] as int).toDouble()
              : map['averageRating'] as double),
      totalRatings: (map['totalRatings'] ?? 0).toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
