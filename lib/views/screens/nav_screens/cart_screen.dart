import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/views/screens/detail/screens/checkout_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = _cartProvider.calculateTotalAmount();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/cartb.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset('assets/icons/not.png', width: 25, height: 25),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            cartData.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  'My Cart',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your shopping cart is empty\nYou can add products to your cart from the button below',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      letterSpacing: 1.7,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) =>  MainScreen()));
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                Container(
                  height: 49,
                  color: const Color(0xFFD7DDFF),
                  child: Row(
                    children: [
                      const SizedBox(width: 44),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'You Have ${cartData.length} items',
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                ...cartData.values.map((cartItem) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 200,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              cartItem.image[0],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    cartItem.productName,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    cartItem.category,
                                    style: GoogleFonts.roboto(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "\$${cartItem.productPrice.toStringAsFixed(2)}",
                                    style: GoogleFonts.lato(
                                      color: Colors.pink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 120,
                                        decoration: const BoxDecoration(color: Color(0xFF102DE1)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _cartProvider.decrementCartItem(cartItem.productId);
                                              },
                                              icon: const Icon(CupertinoIcons.minus, color: Colors.white),
                                            ),
                                            Text(
                                              cartItem.quantity.toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _cartProvider.incrementCartItem(cartItem.productId);
                                              },
                                              icon: const Icon(CupertinoIcons.plus, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _cartProvider.removeCartItem(cartItem.productId);
                                    },
                                    icon: const Icon(CupertinoIcons.delete),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
      bottomNavigationBar: Container(
        width: 416,
        height: 89,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFC4C4C4)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: const Alignment(-0.63, -0.26),
              child: Text(
                'Subtotal',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFA1A1A1),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.19, -0.31),
              child: Text(
                "\$${totalAmount.toStringAsFixed(2)}",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF6464),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.83, -1),
              child: InkWell(
                onTap: totalAmount == 0.0
                    ? null
                    : () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                      },
                child: Container(
                  width: 166,
                  height: 71,
                  decoration: BoxDecoration(
                    color: totalAmount == 0.0 ? Colors.grey : const Color(0xFF1532E7),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Checkout',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
