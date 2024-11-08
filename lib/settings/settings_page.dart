import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  static String routeName = '/settingspage';

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool isGeolocationEnabled = false;
  bool isSafeModeEnabled = false;
  bool isHDImageQualityEnabled = false;
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NavigationUtils.navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppConstants.mainColor,
            expandedHeight: getProportionateScreenHeight(90),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Account',
                style: TextStyle(
                  color: AppConstants.clrBackground,
                  fontSize: getProportionateScreenHeight(20),
                  fontFamily: AppConstants.fontInterBold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Container(
                    color: AppConstants.mainColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(16),
                      vertical: getProportionateScreenHeight(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: getProportionateScreenWidth(30),
                          backgroundColor: AppConstants.clrBackground,
                          child: Icon(
                            Icons.person,
                            size: getProportionateScreenHeight(30),
                            color: AppConstants.mainColor,
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(16)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kelompok 1',
                                style: TextStyle(
                                  color: AppConstants.clrBackground,
                                  fontSize: getProportionateScreenHeight(18),
                                  fontFamily: AppConstants.fontInterBold,
                                ),
                              ),
                              Text(
                                'Kelompok1@example.com',
                                style: TextStyle(
                                  color: AppConstants.greyColor4,
                                  fontFamily: AppConstants.fontInterRegular,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: AppConstants.clrBackground),
                          onPressed: () {
                            // Navigasi ke halaman edit profil
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(16.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          fontFamily: AppConstants.fontInterSemiBold,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      _buildSettingsItem(Icons.location_on, 'My Addresses',
                          'Set shopping delivery address'),
                      _buildSettingsItem(Icons.shopping_cart, 'My Cart',
                          'Add, remove products and move to checkout'),
                      _buildSettingsItem(Icons.shopping_bag, 'My Orders',
                          'In-progress and Completed Orders'),
                      _buildSettingsItem(Icons.account_balance, 'Bank Account',
                          'Withdraw balance to registered bank account'),
                      _buildSettingsItem(Icons.card_giftcard, 'My Coupons',
                          'List of all the discounted coupons'),
                      _buildSettingsItem(Icons.notifications, 'Notifications',
                          'Set any kind of notification message'),
                      _buildSettingsItem(Icons.privacy_tip, 'Account Privacy',
                          'Manage data usage and connected accounts'),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Text(
                        'App Settings',
                        style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          fontFamily: AppConstants.fontInterSemiBold,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      _buildSettingsItem(Icons.cloud, 'Load Data',
                          'Upload Data to your Cloud Firebase'),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      _buildSwitchItem(
                        Icons.location_on,
                        'Geolocation',
                        'Set recommendation based on location',
                        isGeolocationEnabled,
                        (value) {
                          setState(() {
                            isGeolocationEnabled = value;
                          });
                        },
                      ),
                      _buildSwitchItem(
                        Icons.shield,
                        'Safe Mode',
                        'Search result is safe for all ages',
                        isSafeModeEnabled,
                        (value) {
                          setState(() {
                            isSafeModeEnabled = value;
                          });
                        },
                      ),
                      _buildSwitchItem(
                        Icons.dark_mode,
                        'Dark Mode',
                        'Switch between light and dark themes for a more comfortable viewing experience in low light',
                        isHDImageQualityEnabled,
                        (value) {
                          setState(() {
                            isHDImageQualityEnabled = value;
                          });
                        },
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Center(
                        child: OutlinedButton(
                          onPressed: () {
                            _showLogoutDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(40),
                              vertical: getProportionateScreenHeight(12),
                            ),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: AppConstants.fontInterMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.mainColor),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppConstants.fontInterMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: AppConstants.fontInterRegular),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Logic navigasi
      },
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, String subtitle,
      bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.mainColor),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: AppConstants.fontInterMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontFamily: AppConstants.fontInterRegular),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppConstants.mainColor,
      ),
      onTap: () {
        onChanged(!value);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.clrBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text(
                "Logout Confirmation",
                style: TextStyle(
                  fontFamily: AppConstants.fontInterSemiBold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: AppConstants.fontInterRegular,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(24),
                  vertical: getProportionateScreenHeight(12),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: AppConstants.fontInterMedium,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  // Redirect to login screen after logout
                  Navigator.pushReplacementNamed(context,
                      '/loginScreen'); // Update '/login' with the actual route to your login screen
                } catch (e) {
                  print("Error during logout: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(24),
                  vertical: getProportionateScreenHeight(12),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontFamily: AppConstants.fontInterMedium,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
