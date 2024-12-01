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
        labelStyle: const TextStyle(
          color: AppConstants.mainColor,
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppConstants.mainColor.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.mainColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: AppConstants.clrBlackFont,
        fontWeight: FontWeight.w500,
      ),
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Edit Address",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.mainColor,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: recipientNameController,
                label: "Recipient Name",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: fullAddressController,
                label: "Full Address",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: postalCodeController,
                label: "Postal Code",
                isNumber: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: addressLabelController,
                label: "Address Label",
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppConstants.greyColor3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.clrBlackFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Add New Address",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.mainColor,
          ),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: recipientNameController,
                label: "Recipient Name",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: fullAddressController,
                label: "Full Address",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: postalCodeController,
                label: "Postal Code",
                isNumber: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: addressLabelController,
                label: "Address Label",
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppConstants.greyColor3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.clrBlackFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "My Addresses",
          style: TextStyle(
            fontFamily: AppConstants.fontInterMedium,
            fontWeight: FontWeight.bold,
            color: AppConstants.clrBlackFont,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.clrBlackFont),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<AddressModel>>(
        future: _fetchAddressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstants.mainColor,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final addresses = snapshot.data ?? [];
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 100,
                    color: AppConstants.greyColor3.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No Saved Addresses",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: AppConstants.greyColor3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: addresses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                address.addressLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppConstants.mainColor,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade300,
                                ),
                                onPressed: () async {
                                  await Provider.of<AddressProvider>(context,
                                          listen: false)
                                      .deleteAddress(address.id);
                                  setState(() {
                                    _fetchAddressesFuture =
                                        Provider.of<AddressProvider>(context,
                                                listen: false)
                                            .fetchAddressesByUserId(
                                                userId ?? "");
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            address.recipientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${address.fullAddress}, ${address.postalCode}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.pin_drop,
                                color: AppConstants.mainColor,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Location Pinpointed",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppConstants.mainColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _showEditAddressDialog(address),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                color: AppConstants.mainColor.withOpacity(0.7),
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Edit Address",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConstants.mainColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAddressDialog,
        backgroundColor: AppConstants.mainColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Address",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
