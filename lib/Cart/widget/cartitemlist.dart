import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/widget/cartitem.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';

//widget berisi list item di cart
class Cartitemlist extends StatefulWidget {
  const Cartitemlist({
    super.key,
  });

  @override
  State<Cartitemlist> createState() => _CartitemlistState();
}

class _CartitemlistState extends State<Cartitemlist> {
  final CartDatabaseService cartDatabaseService =
      CartDatabaseService(); //inisiasi cartdatabase service untuk mengelola database

  late Future<void>
      _cartItemsFuture; // Variabel untuk menyimpan future dari pengambilan data cart

  @override
  void initState() {
    super.initState();
    _cartItemsFuture =
        _fetchCartItems(); // Memulai pengambilan data cart saat widget dimulai
  }

  //Fungsi memanggil data item dari database
  Future<void> _fetchCartItems() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      List<Map<String, dynamic>> items =
          await cartDatabaseService.initializeCartItems(userId);
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);
      cartProvider.setCartItems(items);
      cartProvider.calculateTotal();
    }
  }

  //Fungsi menghapus item dari cart
  Future<void> removeItem(String cartItemId) async {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    cartProvider.removeItem(cartItemId);
    await cartDatabaseService.removeCartItem(cartItemId);
  }

  @override
  Widget build(BuildContext context) {
    //Future builder keranjang yang akan melakukan build setelah data selesai diterima
    return FutureBuilder(
      future: _cartItemsFuture,
      builder: (context, snapshot) {
        //selama menunggu cart terkoneksi maka akan menampilkan loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } //penampilan error apabila terjadi masalah pada future builder
        else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } //penampilan apabila future builder selesai menerima data tanpa error
        else {
          //penggunaan consumer untuk build state
          return Consumer<Cartprovider>(
            builder: (context, cartProvider, child) {
              //inisiasi cartitems yang merupakan item-item di cart
              final cartItems = cartProvider.cartItems;
              //Pengecekan apabila item-item kosong maka akan menampilkan "Your cart is empty"
              if (cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.remove_shopping_cart,
                        size: 100,
                        color: AppConstants.clrBackground,
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      const Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontFamily: AppConstants.fontInterMedium,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.greyColor3,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              //Apabila tidak kosong maka akan menampilkan list builder widget cart item
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Cartitem(
                    data: cartItems[index],
                    onDelete: () {
                      removeItem(cartItems[index]['id']);
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
