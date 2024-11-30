import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/Checkout/coupon_page.dart';
import 'package:uas_flutter/Checkout/custom_divider.dart';
import 'package:uas_flutter/Checkout/productitem.dart';
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';
import 'package:uas_flutter/Checkout/toolbar.dart';
import 'package:uas_flutter/Home/Providers/saldoprovider.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/Home/services/firebase_topup.dart';
import 'package:uas_flutter/constants.dart';
import 'package:intl/intl.dart';
import 'package:uas_flutter/history/models/transaction.dart';
import 'package:uas_flutter/history/models/transaction_list.dart';
import 'package:uas_flutter/history/providers/transaction_provider.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:uas_flutter/utils/snackbar.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';
import 'package:uas_flutter/settings/models/address_model.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = "/checkout";
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

Future<void> makePayment(BuildContext context, double totalBelanja,
    List<Map<String, dynamic>> cartItems) async {
  try {
    // Fetch user's balance
    double saldoUser = await FirebaseTopup.getSaldoFromFirestore();

    // Check if balance is sufficient
    if (saldoUser < totalBelanja) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient balance'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add transaction to Firebase
    final transactionProvider = context.read<TransactionProvider>();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle the case where userId is null, for example by showing an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User is not authenticated.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final transaction = Transactions(
      userId: userId,
      date: DateTime.now().toString(),
      amount: totalBelanja,
      quantity: cartItems.length,
      transactionList: cartItems.map((item) {
        return TransactionList(
          productId: item['productId'],
          title: item['title'],
          image: item['image'],
          price: item['price'],
          quantity: item['cartQuantity'],
        );
      }).toList(),
    );

    await transactionProvider.addTransaction(transaction);

    // Deduct balance and update Firestore and UI

    await FirebaseTopup.updateSaldoInFirestore(saldoUser - totalBelanja);
    context.read<SaldoProvider>().updateSaldo(saldoUser - totalBelanja);

    // Attempt to update stock quantities
    await decreaseQuantitiesAfterCheckout(cartItems);

    // Show success message
    SnackbarUtils.showSnackbar(
      context,
      'Payment successful',
      backgroundColor: AppConstants.clrBlue,
    );
  } catch (e) {
    // Show error message if anything fails
    SnackbarUtils.showSnackbar(
      context,
      'An error occured, please try again',
      backgroundColor: AppConstants.clrRed,
    );
    print(e);
  }
}

Future<void> decreaseQuantitiesAfterCheckout(
    List<Map<String, dynamic>> cartItems) async {
  try {
    // Loop through each cart item and update stock
    for (var item in cartItems) {
      try {
        // Decrease the product quantity
        await ProductDatabaseService()
            .decreaseProductQuantity(item['productId'], item['cartQuantity']);

        // Remove the item from the cart
        await CartDatabaseService().removeCartItem(item['id']);
      } catch (e) {
        // Throw an error if one item fails
        throw Exception('Failed to update product ${item['productId']}: $e');
      }
    }

    print("All quantities updated successfully.");
  } catch (e) {
    // Re-throw the error to propagate it to the calling function
    print("Error during quantity update: $e");
    rethrow;
  }
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    final addressProvider = context.read<AddressProvider>();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      addressProvider.fetchAddressesByUserId(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    Cartprovider cartprovider = context.watch<Cartprovider>();
    final checkoutProvider = context.watch<CheckoutProvider>();
    final addressProvider = context.watch<AddressProvider>();
    List<Map<String, dynamic>> checkedItems = cartprovider.checkedItems;

    num subTotal = cartprovider.total;
    num totalBarang = checkedItems.length;

    // Calculate total using the CheckoutProvider's method
    double totalBelanja = checkoutProvider.calculateTotal(subTotal.toDouble());

    return Scaffold(
      appBar: const Toolbar(title: 'Pengiriman'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: addressProvider.addresses.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pilih Alamat Pengiriman",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Tampilkan alamat yang dipilih atau informasi default
                        GestureDetector(
                          onTap: () {
                            // Jika ada alamat yang dipilih, buka pilihan alamat
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return ListView.builder(
                                  itemCount: addressProvider.addresses.length,
                                  itemBuilder: (context, index) {
                                    final address =
                                        addressProvider.addresses[index];
                                    return ListTile(
                                      title: Text(address.fullAddress),
                                      subtitle: Text(
                                        "${address.recipientName}, ${address.addressLabel}",
                                      ),
                                      onTap: () {
                                        // Set alamat yang dipilih
                                        checkoutProvider.setSelectedAddress(
                                            address.fullAddress);
                                        Navigator.pop(
                                            context); // Tutup bottom sheet
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppConstants.clrBackground,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Alamat pengiriman kamu',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Menampilkan alamat yang dipilih jika ada
                                      checkoutProvider.selectedAddress == null
                                          ? const Text(
                                              "Pilih alamat pengiriman",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: AppConstants.greyColor,
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    // Address Label yang besar dan bold
                                                    Text(
                                                      addressProvider.addresses
                                                          .firstWhere((address) =>
                                                              address
                                                                  .fullAddress ==
                                                              checkoutProvider
                                                                  .selectedAddress)
                                                          .addressLabel,
                                                      style: const TextStyle(
                                                        fontSize:
                                                            16, // Lebih besar
                                                        fontWeight: FontWeight
                                                            .bold, // Bold
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 6),
                                                // Recipient Name yang bold dan sedikit lebih kecil
                                                Text(
                                                  addressProvider.addresses
                                                      .firstWhere((address) =>
                                                          address.fullAddress ==
                                                          checkoutProvider
                                                              .selectedAddress)
                                                      .recipientName,
                                                  style: const TextStyle(
                                                    fontSize:
                                                        15, // Lebih kecil dari addressLabel
                                                    fontWeight:
                                                        FontWeight.bold, // Bold
                                                    color:
                                                        AppConstants.clrBlack,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                // Alamat lengkap yang bold dan sedikit lebih kecil
                                                Text(
                                                  addressProvider.addresses
                                                      .firstWhere((address) =>
                                                          address.fullAddress ==
                                                          checkoutProvider
                                                              .selectedAddress)
                                                      .fullAddress,
                                                  style: const TextStyle(
                                                    fontSize:
                                                        14, // Lebih kecil dari recipientName
                                                    fontWeight:
                                                        FontWeight.bold, // Bold
                                                    color:
                                                        AppConstants.clrBlack,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const CustomDivider(),
            // Item Section
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.green,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Dibei Shop',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: checkedItems.length,
                      itemBuilder: (context, index) {
                        return ProductItem(
                          item: checkedItems[index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Colors.grey, // or any other color you prefer
                          thickness: 1, // Adjust thickness if necessary
                        );
                      },
                    ),
                  ),

                  // Updated Row layout
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.shield_moon_outlined,
                                    color: AppConstants.greyColor,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Proteksi Kerusakan +',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: AppConstants.greyColor,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    '(Rp4.500)',
                                    style: TextStyle(
                                      color: AppConstants.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                          checkoutProvider.toggleProtection(isChecked);
                        },
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Color(0xFF40B22F);
                            }
                            return Colors.white;
                          },
                        ),
                        checkColor: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: AppConstants.clrGreen,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Pilih Opsi Pengiriman',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_document,
                    color: AppConstants.greyColor,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Pesan untuk penjual',
                    style: TextStyle(color: AppConstants.greyColor),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const CustomDivider(),

            // Promo Section
            SizedBox(
              height: 55,
              child: Container(
                color: AppConstants.clrBackground,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return const CouponPage();
                      },
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.discount_outlined,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 6),
                        if (checkoutProvider.isCouponApplied)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kupon promo berhasil dipakai!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'Yay, kamu hemat ',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Rp${NumberFormat("#,##0", "id_ID").format(checkoutProvider.discountValue)}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                    const TextSpan(
                                      text: ' 🎉',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yuk, pakai kode promonya!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Hemat sampai Rp30.000',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.green),
                              ),
                            ],
                          ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const CustomDivider(),
            // Summary Section
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cek ringkasan belanjamu, yuk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Harga ($totalBarang Barang)'),
                      Text(
                        'Rp ${NumberFormat("#,##0", "id_ID").format(subTotal)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Biaya Proteksi'),
                      Text(isChecked ? 'Rp4.500' : '-',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Belanja'),
                      Text(
                          'Rp ${NumberFormat("#,##0", "id_ID").format(totalBelanja)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Payment Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    makePayment(context, totalBelanja, checkedItems);
                    Navigator.pushNamed(context, Myhomepage.routeName);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: AppConstants.clrBackground,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Bayar Sekarang',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Terms Text
            const Center(
              child: Text(
                'Dengan melanjutkan pembayaran, kamu menyetujui S&K Asuransi Pengiriman & Proteksi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
