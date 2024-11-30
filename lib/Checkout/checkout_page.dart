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
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/utils/snackbar.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = "/checkout";
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

class PaymentMethod {
  final String methodName;
  final IconData icon;

  PaymentMethod(this.methodName, this.icon);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran berhasil!'),
        backgroundColor: AppConstants.clrBlue,
      ),
    );
  } catch (e) {
    // Show error message if anything fails
    SnackbarUtils.showSnackbar(
      context,
      'An error occured, please try again',
      backgroundColor: AppConstants.clrRed,
    );
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
  String? selectedPaymentMethod;
  bool showAllMethods = false;

  List<PaymentMethod> paymentMethods = [
    PaymentMethod("Cartipay", Icons.account_balance_wallet),
    PaymentMethod("Kartu Kredit/Debit", Icons.credit_card),
    PaymentMethod("Virtual Account", Icons.account_balance),
    PaymentMethod("OVO", Icons.phone_android),
    PaymentMethod("GoPay", Icons.qr_code_scanner),
  ];

  @override
  void initState() {
    super.initState();
    final addressProvider = context.read<AddressProvider>();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      addressProvider.fetchAddressesByUserId(userId);
    }
  }

  void _showCouponBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return const CouponPage();
      },
    );
  }

  void _showMorePaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Metode Pembayaran Lainnya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentMethods.length - 2,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey),
                itemBuilder: (context, index) {
                  PaymentMethod method = paymentMethods[index + 2];
                  return ListTile(
                    leading: Icon(method.icon, color: AppConstants.clrBlue),
                    title: Text(method.methodName),
                    trailing: Radio<String>(
                      value: method.methodName,
                      groupValue: selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = method.methodName;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
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
                  : GestureDetector(
                      onTap: () {
                        // Tampilkan pilihan alamat saat bagian ini diklik
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
                          color: Colors.white, // Latar belakang putih
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Judul "Alamat pengiriman kamu"
                                  const Text(
                                    "Alamat pengiriman kamu",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Tampilkan alamat jika dipilih
                                  checkoutProvider.selectedAddress == null
                                      ? const Text(
                                          "Pilih alamat pengiriman",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors
                                                      .green, // Ikon hijau
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                // Label alamat besar dan bold
                                                Text(
                                                  addressProvider.addresses
                                                      .firstWhere((address) =>
                                                          address.fullAddress ==
                                                          checkoutProvider
                                                              .selectedAddress)
                                                      .addressLabel,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  " - ${addressProvider.addresses.firstWhere((address) => address.fullAddress == checkoutProvider.selectedAddress).recipientName}",
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              addressProvider.addresses
                                                  .firstWhere((address) =>
                                                      address.fullAddress ==
                                                      checkoutProvider
                                                          .selectedAddress)
                                                  .fullAddress,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.grey, // Ikon panah abu-abu di kanan
                            ),
                          ],
                        ),
                      ),
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
                        color: AppConstants.clrBlue,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'CartiShop',
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
                          color: Colors.grey,
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
                        color: const Color.fromARGB(255, 125, 176, 253),
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
                                        fontSize: 15,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            // Pilih Metode Pembayaran Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: showAllMethods ? paymentMethods.length : 2,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey),
                    itemBuilder: (context, index) {
                      PaymentMethod method = paymentMethods[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 24, // Adjust the radius as needed
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            method.icon,
                            color: AppConstants.clrBlue,
                            size: 28,
                          ),
                        ),
                        title: Text(method.methodName),
                        trailing: Radio<String>(
                          value: method.methodName,
                          groupValue: selectedPaymentMethod,
                          onChanged: (String? value) {
                            setState(() {
                              selectedPaymentMethod = value;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = method.methodName;
                          });
                        },
                      );
                    },
                  ),
                  // Tombol "Lihat Lebih Banyak" atau "Tutup" tergantung state showAllMethods
                  if (!showAllMethods) // Hanya tampilkan tombol "Lihat Lebih Banyak"
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            showAllMethods = true; // Tampilkan semua metode
                          });
                        },
                        child: const Text(
                          'Lihat Lebih Banyak',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.clrBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  if (showAllMethods) // Tampilkan tombol "Tutup" jika sudah menampilkan semua metode
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            showAllMethods =
                                false; // Sembunyikan metode tambahan
                          });
                        },
                        child: const Text(
                          'Tutup',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.clrBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

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
                                  color: AppConstants.clrBlue,
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
                                          color: AppConstants.clrBlue),
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
                                    fontSize: 10, color: AppConstants.clrBlue),
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
                  // Total Harga
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
                  // Total Diskon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Diskon'),
                      Text(
                        checkoutProvider.isCouponApplied
                            ? 'Rp ${NumberFormat("#,##0", "id_ID").format(checkoutProvider.discountValue)}'
                            : '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Total Biaya Proteksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Biaya Proteksi'),
                      Text(isChecked ? 'Rp4.500' : '-',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  // Total Belanja
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Belanja'),
                      Text(
                        'Rp ${NumberFormat("#,##0", "id_ID").format(totalBelanja)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                    backgroundColor: AppConstants.clrBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (selectedPaymentMethod == null) {
                      // Show a warning to the user
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Pilih Metode Pembayaran'),
                            content: const Text(
                                'Silakan pilih metode pembayaran sebelum melanjutkan.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Proceed with the payment
                      makePayment(context, totalBelanja, checkedItems);
                      Navigator.pushNamed(context, Myhomepage.routeName);
                    }
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
