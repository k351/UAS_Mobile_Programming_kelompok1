import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';
import 'package:uas_flutter/settings/models/address_model.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/constants.dart';

class MyAddressesPage extends StatefulWidget {
  const MyAddressesPage({Key? key}) : super(key: key);
  static String routeName = '/myaddress';

  @override
  State<MyAddressesPage> createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  late Future<List<AddressModel>> _fetchAddressesFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _fetchAddressesFuture = Provider.of<AddressProvider>(context, listen: false)
        .fetchAddressesByUserId(userId ?? "");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig.init(context);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.clrAppBar,
        title: const Text("My Addresses", 
        style: TextStyle(
          fontFamily: AppConstants.fontInterMedium,
            fontWeight: FontWeight.bold,
        ),),
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<AddressModel>>(
        future: _fetchAddressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final addresses = snapshot.data ?? [];
          if (addresses.isEmpty) {
            return const Center(child: Text("No addresses found."));
          }
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(8),
                  horizontal: getProportionateScreenWidth(16),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(getProportionateScreenHeight(10)),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.all(getProportionateScreenHeight(16)),
                  title: Text(
                    address.addressLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenHeight(18),
                    ),
                  ),
                  subtitle: Text(
                    "${address.recipientName}\n${address.fullAddress}, ${address.postalCode}",
                    style:
                        TextStyle(fontSize: getProportionateScreenHeight(14)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await addressProvider.deleteAddress(address.id);
                      setState(() {
                        _fetchAddressesFuture = addressProvider
                            .fetchAddressesByUserId(userId ?? "");
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: getProportionateScreenHeight(24), // Menambahkan ruang di bawah tombol
        ),
        child: Container(
          color: Colors.transparent, // Pastikan background-nya transparan
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final recipientNameController = TextEditingController();
                  final fullAddressController = TextEditingController();
                  final postalCodeController = TextEditingController();
                  final addressLabelController = TextEditingController();

                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(getProportionateScreenHeight(16)),
                    ),
                    title: Text(
                      "Add Address",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(18),
                        fontWeight: FontWeight.bold,
                        color: AppConstants.clrBlackFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(8),
                          vertical: getProportionateScreenHeight(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTextField(
                              controller: recipientNameController,
                              label: "Recipient Name",
                            ),
                            SizedBox(height: getProportionateScreenHeight(12)),
                            _buildTextField(
                              controller: fullAddressController,
                              label: "Full Address",
                            ),
                            SizedBox(height: getProportionateScreenHeight(12)),
                            _buildTextField(
                              controller: postalCodeController,
                              label: "Postal Code",
                              isNumber: true,
                            ),
                            SizedBox(height: getProportionateScreenHeight(12)),
                            _buildTextField(
                              controller: addressLabelController,
                              label: "Address Label",
                            ),
                          ],
                        ),
                      ),
                    ),
                    actionsPadding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(16),
                      vertical: getProportionateScreenHeight(8),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.greyColor7,
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(14),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenHeight(10)),
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: getProportionateScreenHeight(14),
                                  color: AppConstants.clrBlackFont,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: getProportionateScreenWidth(16)),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final newAddress = AddressModel(
                                  id: "",
                                  userId: userId ?? "",
                                  recipientName: recipientNameController.text,
                                  fullAddress: fullAddressController.text,
                                  postalCode: postalCodeController.text,
                                  addressLabel: addressLabelController.text,
                                );
                                await addressProvider.addAddress(newAddress);
                                setState(() {
                                  _fetchAddressesFuture = addressProvider
                                      .fetchAddressesByUserId(userId ?? "");
                                });
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.mainColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(14),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      getProportionateScreenHeight(10)),
                                ),
                              ),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: getProportionateScreenHeight(14),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.mainColor,
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(16),
                horizontal: getProportionateScreenWidth(16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(getProportionateScreenHeight(12)),
              ),
              elevation: 0,
              foregroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: getProportionateScreenHeight(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text("Add Address"),
          ),
        ),
      ),
    );
  }
}
