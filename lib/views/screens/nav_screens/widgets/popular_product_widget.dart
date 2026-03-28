import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/provider/product_provider.dart';
import 'package:mac_store_app/views/screens/nav_screens/widgets/product_item_widget.dart';

class HorizontalProductList extends ConsumerStatefulWidget {
  const HorizontalProductList({super.key});

  @override
  ConsumerState<HorizontalProductList> createState() => _HorizontalProductListState();
}

class _HorizontalProductListState extends ConsumerState<HorizontalProductList> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProducts();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    final controller = ProductController();
    try {
      final products = await controller.loadPopularProducts();
      ref.read(productProvider.notifier).setProducts(products);
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    return SizedBox(
      height: 270,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: products
                    .map((product) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ProductItemWidget(product: product),
                        ))
                    .toList(),
              ),
            ),
    );
  }
}
