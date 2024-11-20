import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Checkout/custom_divider.dart';
import 'package:uas_flutter/Checkout/productitem.dart';
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';
import 'package:uas_flutter/Checkout/toolbar.dart';
import 'package:uas_flutter/constants.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = "/checkout";
  const CheckoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    Cartprovider cartprovider = context.watch<Cartprovider>();
    CheckoutProvider checkoutProvider = context.watch<CheckoutProvider>();
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
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppConstants.clrBackground,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat pengiriman kamu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Rumah • Alvin Kurniawan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Jalan Jembatan 2 Gang Anggur no.18 (Di seberang kecamatan Tambora)',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppConstants.greyColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
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
            Container(
              color: AppConstants.clrBackground,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.discount_outlined,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yuk, pakai promonya! ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Hemat sampai Rp30.000',
                          style: TextStyle(fontSize: 10, color: Colors.green),
                        ),
                      ],
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Biaya Proteksi (1 Polis)'),
                      Text('Rp4.500',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Belanja'),
                      Text(
                          'Rp ${NumberFormat("#,##0", "id_ID").format(totalBelanja)}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                    // Handle payment action here
                  },
                  child: const Text(
                    'Pilih Pembayaran',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
