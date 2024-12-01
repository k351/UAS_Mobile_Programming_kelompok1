import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/Checkout/coupon_page.dart';
import 'package:uas_flutter/Checkout/payment_method.dart';
import 'package:uas_flutter/Checkout/widgets/custom_divider.dart';
import 'package:uas_flutter/Checkout/mapview.dart';
import 'package:uas_flutter/Checkout/productitem.dart';
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';
import 'package:uas_flutter/Checkout/toolbar.dart';
import 'package:uas_flutter/Checkout/widgets/address_card.dart';
import 'package:uas_flutter/Checkout/widgets/paymentmethod_section.dart';
import 'package:uas_flutter/Checkout/widgets/protectionitemwidget.dart';
import 'package:uas_flutter/Home/Providers/saldoprovider.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/Home/services/firebase_topup.dart';
import 'package:uas_flutter/constants.dart';
import 'package:intl/intl.dart';
import 'package:uas_flutter/history/models/transaction.dart';
import 'package:uas_flutter/history/models/transaction_list.dart';
import 'package:uas_flutter/history/providers/transaction_provider.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:uas_flutter/settings/my_address_page.dart';
import 'package:uas_flutter/utils/snackbar.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = "/checkout";
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

Future<void> makePayment(
    BuildContext context,
    double totalBelanja,
    List<Map<String, dynamic>> cartItems,
    String selectedAddress,
    num discountAmount,
    num protectionFee) async {
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
      address: selectedAddress,
      discountAmount: discountAmount,
      protectionFee: protectionFee,
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

    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final idsToRemove = cartItems.map((item) => item['id'] as String).toList();
    cartProvider.removeItems(idsToRemove);
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
    final checkoutProvider =
        Provider.of<CheckoutProvider>(context, listen: false);

    if (userId != null) {
      addressProvider.fetchAddressesByUserId(userId);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkoutProvider.resetCheckout();
    });
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
                  ? InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, MyAddressesPage.routeName);
                      },
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on, // Icon related to address
                              size: 30,
                              color: AppConstants
                                  .greyColor3, // Use your specific color constant
                            ),
                            SizedBox(width: 10),
                            const Text(
                              "Alamat user kosong",
                              style: TextStyle(
                                fontFamily: AppConstants
                                    .fontInterMedium, // Use the desired font family
                                fontWeight: FontWeight.bold,
                                color: AppConstants
                                    .greyColor3, // Adjust to the correct color
                                fontSize:
                                    20, // Adjust the size as per your requirement
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) {
                            return SafeArea(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 28),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Pilih Alamat Pengiriman',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.clrBlue,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.location_on_outlined,
                                            color: AppConstants.clrBlue,
                                          ),
                                          onPressed: () {
                                            // When the location icon is pressed, open the map
                                            final selectedAddress =
                                                checkoutProvider
                                                    .selectedAddress;
                                            if (selectedAddress?.isNotEmpty ??
                                                false) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => MapView(
                                                      address: selectedAddress),
                                                ),
                                              );
                                            } else {
                                              // Optionally show a warning if no address is selected
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please select an address first')),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            addressProvider.addresses.length,
                                        itemBuilder: (context, index) {
                                          final address =
                                              addressProvider.addresses[index];
                                          return AddressCard(
                                            address: address,
                                            onTap: () {
                                              checkoutProvider
                                                  .setSelectedAddress(
                                                      address.fullAddress);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors
                              .white, // White background for the container
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Alamat Pengiriman Kamu",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
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
                                                  color: AppConstants.clrBlue,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                // Address label and recipient name
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
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color:
                                  Colors.grey, // Grey arrow icon on the right
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            const CustomDivider(),

            // Item Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section with Cart Icon and Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppConstants.clrBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: AppConstants.clrBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'CartiShop',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Product List Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: checkedItems.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade200,
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (context, index) {
                            return ProductItem(
                              item: checkedItems[index],
                            );
                          },
                        ),
                        // Total Items Summary
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Items',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${checkedItems.length} Item',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Protection Option
                  ProtectionItemWidget(
                    isChecked: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                      checkoutProvider.toggleProtection(isChecked);
                    },
                  )
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 1),
            // Payment Method Section
            PaymentMethodSection(
              showAllMethods: showAllMethods,
              paymentMethods: paymentMethods,
              selectedPaymentMethod: selectedPaymentMethod,
              onMethodSelected: (value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
            ),

            const CustomDivider(),

            // Promo Section
            SizedBox(
              height: 60,
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
                        Icon(
                          Icons.discount_outlined,
                          color: Colors.deepPurple.shade300,
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
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Hemat sampai Rp 100.000',
                                style: TextStyle(
                                    fontSize: 14, color: AppConstants.clrBlue),
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
                  onPressed: addressProvider.addresses.isEmpty
                      ? () {
                          // Tampilkan Snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Isi dulu alamat sebelum melanjutkan.'),
                            ),
                          );
                        }
                      : () {
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
                          } else if (checkoutProvider.selectedAddress == null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Pilih Alamat Anda'),
                                  content: const Text(
                                      'Silakan pilih alamat pengiriman anda sebelum melanjutkan.'),
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
                            final address = addressProvider.addresses
                                .firstWhere((address) =>
                                    address.fullAddress ==
                                    checkoutProvider.selectedAddress);

                            String result =
                                '${address.fullAddress}, ${address.postalCode}';

                            final protectionFee =
                                checkoutProvider.isProtectionChecked
                                    ? checkoutProvider.protectionFee
                                    : 0;
                            // Proceed with the payment
                            makePayment(
                              context,
                              totalBelanja,
                              checkedItems,
                              result,
                              checkoutProvider.discountValue,
                              protectionFee,
                            );
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
