import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';
import 'package:uas_flutter/settings/models/address_model.dart';
import 'package:uas_flutter/utils/size_config.dart';
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


  void _showEditAddressDialog(AddressModel address) {
    final recipientNameController =
        TextEditingController(text: address.recipientName);
    final fullAddressController =
        TextEditingController(text: address.fullAddress);
    final postalCodeController =
        TextEditingController(text: address.postalCode);
    final addressLabelController =
        TextEditingController(text: address.addressLabel);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(16)),
        ),
        title: Text(
          "Edit Address",
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
                    final updatedAddress = AddressModel(
                      id: address.id,
                      userId: address.userId,
                      recipientName: recipientNameController.text,
                      fullAddress: fullAddressController.text,
                      postalCode: postalCodeController.text,
                      addressLabel: addressLabelController.text,
                    );
                    await Provider.of<AddressProvider>(context, listen: false)
                        .updateAddress(updatedAddress);
                    setState(() {
                      _fetchAddressesFuture =
                          Provider.of<AddressProvider>(context, listen: false)
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
                    "Save",
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
      ),
    );
  }


  void _showAddAddressDialog() {
    final recipientNameController = TextEditingController();
    final fullAddressController = TextEditingController();
    final postalCodeController = TextEditingController();
    final addressLabelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenHeight(16)),
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
                    await Provider.of<AddressProvider>(context, listen: false)
                        .addAddress(newAddress);
                    setState(() {
                      _fetchAddressesFuture =
                          Provider.of<AddressProvider>(context, listen: false)
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
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.clrAppBar,
        title: const Text(
          "My Addresses",
          style: TextStyle(
            fontFamily: AppConstants.fontInterMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                child: Padding(
                  padding: EdgeInsets.all(
                      getProportionateScreenHeight(16)), // Padding utama
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              address.addressLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenHeight(16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await Provider.of<AddressProvider>(context,
                                        listen: false)
                                    .deleteAddress(address.id);
                                setState(() {
                                  _fetchAddressesFuture =
                                      Provider.of<AddressProvider>(context,
                                              listen: false)
                                          .fetchAddressesByUserId(userId ?? "");
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // Konten Utama
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(8)),
                        child: Text(
                          address.recipientName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenHeight(14),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(12)),
                        child: Text(
                          "${address.fullAddress}, ${address.postalCode}",
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(12),
                          ),
                        ),
                      ),

                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.pin_drop,
                                color: AppConstants.mainColor,
                                size: 16,
                              ),
                              SizedBox(width: getProportionateScreenWidth(4)),
                              Text(
                                "Sudah Pinpoint",
                                style: TextStyle(
                                  fontSize: getProportionateScreenHeight(12),
                                  color: AppConstants.mainColor,
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () => _showEditAddressDialog(address),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(12),
                                vertical: getProportionateScreenHeight(8),
                              ),
                              side: BorderSide(
                                color: AppConstants.mainColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    getProportionateScreenHeight(6)),
                              ),
                            ),
                            child: Text(
                              "Ubah Alamat",
                              style: TextStyle(
                                fontSize: getProportionateScreenHeight(12),
                                color: AppConstants.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(16)),
        child: ElevatedButton(
          onPressed: _showAddAddressDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.clrBlackFont,
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(getProportionateScreenHeight(12)),
            ),
          ),
          child: const Text(
            "Add Address",
            style: TextStyle(color: AppConstants.clrBlue),
          ),
        ),
      ),
    );
  }
}
