import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mac_store_app/global_variable.dart';
import 'package:mac_store_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController {
  //function to upload orders
  uploadOrders({
    required String id,
    required String name,
    required String email,
    required String state,
    required String city,
    required String locality,
    required String productName,
    required int productPrice,
    required int quantity,
    required String category,
    required String image,
    required String buyerId,
    required String vendorId,
    required bool processing,
    required bool delivered,
    required context,
    required String paymentStatus,
    required String paymentIntentId,
    required String paymentMethod,
   }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      final Order order = Order(
        id: id,
        name: name,
        email: email,
        state: state,
        city: city,
        locality: locality,
        productName: productName,
        productPrice: productPrice,
        quantity: quantity,
        category: category,
        image: image,
        buyerId: buyerId,
        vendorId: vendorId,
        processing: processing,
        delivered: delivered,
        paymentStatus: paymentStatus,
        paymentIntentId: paymentIntentId,
        paymentMethod: paymentMethod,
      );

      http.Response response = await http.post(
        Uri.parse("$uri/api/orders"),
        body: order.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'You have placed an order');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Method to GET Orders by buyer id

  Future<List<Order>> loadOrders({required String buyerId}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      //Send an HTTP GET request to get the orders by the buyerID
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      //Check if the response status code is 200(OK).
      if (response.statusCode == 200) {
        //Parse the Json response body into dynamic List
        //THIS convert the json data into a formate that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        //Map the dynamic list to list of Orders object using the fromjson factory method
        //this step coverts the raw data into list of the orders  instances , which are easier to work with
        List<Order> orders =
            data.map((order) => Order.fromJson(order)).toList();

        return orders;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        //throw an execption if the server responded with an error status code
        throw Exception("failed to load Orders");
      }
    } catch (e) {
      throw Exception('error Loading Orders');
    }
  }

  //delete order by ID
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");
      //send an HTTP Delete request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse("$uri/api/orders/$id"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      //handle the HTTP Response
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Order Deleted successfully');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<int> getDeliveredOrderCount({required String buyerId}) async {
    try {
      List<Order> orders = await loadOrders(buyerId: buyerId);
      // Filter only delivered orders belonging to the correct buyer ID
      int deliveredCount = orders
          .where((order) => order.delivered && order.buyerId == buyerId)
          .length;
      return deliveredCount;
    } catch (e) {
      throw Exception("Error counting Delivered Orders");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString("auth_token");

      http.Response response =
          await http.post(Uri.parse('$uri/api/payment-intent'),
              headers: <String, String>{
                "Content-Type": 'application/json; charset=UTF-8',
                'x-auth-token': token!,
              },
              body: jsonEncode({
                'amount': amount,
                'currency': currency,
              }));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to create payment  intent ${response.body}");
      }
    } catch (e) {
      throw Exception("Error Create  Payment Intent: $e");
    }
  }

  //retrive payment intent to know if the payment was successfull or not

  Future<Map<String, dynamic>> getPaymentIntentStatus({
    required BuildContext context,
    required String paymentIntentId,
  }) async {
     try {
       SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');

    http.Response response = await http.get(
      Uri.parse('$uri/api/payment-intent/$paymentIntentId'),
      headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to get payment  intent ${response.body}");
    }
     } catch (e) {
        throw Exception("Failed to get payment  intent $e");

     }
  }

  Future<Map<String, dynamic>> createStripeCustomer({
  required String name,
  required String email,
  required BuildContext context,
}) async {
  try {
    // Retrieve the token from SharedPreferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('auth_token');

    // Prepare the API request
    http.Response response = await http.post(
      Uri.parse('$uri/api/stripe/customers'),
      headers: <String, String>{
        "Content-Type": 'application/json; charset=UTF-8',
        'x-auth-token': token!,
      },
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    // Handle the response
    if (response.statusCode == 201) {
      // Parse and return the customer data
      return jsonDecode(response.body);
    } else {
      // Throw an error if the response is not successful
      throw Exception("Failed to create customer: ${response.body}");
    }
  } catch (e) {
    showSnackBar(context, "Error creating Stripe customer: $e");
    throw Exception("Error creating Stripe customer: $e");
  }
}

}
