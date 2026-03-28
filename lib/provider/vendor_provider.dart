import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/vendor_model.dart';

class VendorProvider extends StateNotifier<List<Vendor>> {
  VendorProvider() : super([]);

  //set the list of banners
  void setVendors(List<Vendor> vendors) {
    state = vendors;
  }
}

final vendorProvider =
    StateNotifierProvider<VendorProvider, List<Vendor>>((ref) {
  return VendorProvider();
});
