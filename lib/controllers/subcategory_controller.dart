
import 'dart:convert';

import 'package:mac_store_app/global_variable.dart';
import 'package:mac_store_app/models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  Future<List<Subcategory>> getSubCategoriesByCategoryName(
      String categoryName) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/category/$categoryName/subcategories"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data
              .map((subcategory) => Subcategory.fromJson(subcategory))
              .toList();
        } else {
          print("No subcategories found for this category");
          return [];
        }
      } else if (response.statusCode == 404) {
        print("Category not found");
        return [];
      } else {
        print("Failed to load subcategories: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      return [];
    }
  }
}
