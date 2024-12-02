import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/CartPage.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/auth/providers/user_provider.dart';
import 'package:uas_flutter/history/history_page.dart';
import 'package:uas_flutter/settings/edit_profile.dart';
import 'package:uas_flutter/settings/my_address_page.dart';
import 'package:uas_flutter/settings/notification/notification_page.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/provider/edit_profile_provider.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/Home/TopUpMetode/method_top_up.dart';
import 'package:uas_flutter/Home/services/firebase_topup.dart';
import 'package:uas_flutter/Home/Providers/saldoprovider.dart';

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

  Future<void> _navigateToMethodTopUpPage() async {
    final saldoProvider = Provider.of<SaldoProvider>(context, listen: false);
    final updatedSaldo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MethodTopUps(initialSaldo: saldoProvider.saldo),
      ),
    );

    if (updatedSaldo != null) {
      saldoProvider.updateSaldo(updatedSaldo);
      await _updateUserSaldo(updatedSaldo);
    }
  }

  Future<void> _updateUserSaldo(double newSaldo) async {
    await FirebaseTopup.updateSaldoInFirestore(newSaldo);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<EditProfileProvider>(context, listen: false)
          .loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final provider = Provider.of<EditProfileProvider>(context);

    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppConstants.mainColor,
            expandedHeight: getProportionateScreenHeight(90),
            pinned: true,
            iconTheme: const IconThemeData(
              color: Colors.white, // Change back arrow color to white
            ),
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
                if (provider.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  _buildHeader(provider),
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
                      _buildSettingsItem(
                          Icons.shopping_bag,
                          'My Orders And History',
                          'In-progress and Completed Orders'),
                      _buildSettingsItem(
                          Icons.account_balance,
                          'Payment Methods',
                          'Choose payment methods for cheking out'),
                      _buildSettingsItem(Icons.notifications, 'Notifications',
                          'Set any kind of notification message'),
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

  Widget _buildHeader(EditProfileProvider provider) {
    return ClipRRect(
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
                    provider.profile?.username ?? 'No Name',
                    style: TextStyle(
                      color: AppConstants.clrBackground,
                      fontSize: getProportionateScreenHeight(18),
                      fontFamily: AppConstants.fontInterBold,
                    ),
                  ),
                  Text(
                    provider.profile?.email ?? 'No Email',
                    style: const TextStyle(
                      color: AppConstants.clrBackground,
                      fontFamily: AppConstants.fontInterRegular,
                    ),
                  ),
                  Text(
                    provider.profile?.phone ?? 'No Number',
                    style: const TextStyle(
                      color: AppConstants.clrBackground,
                      fontFamily: AppConstants.fontInterRegular,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AppConstants.clrBackground),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePage()),
                );
              },
            ),
          ],
        ),
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
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        if (title == 'My Addresses') {
          Navigator.pushNamed(context, MyAddressesPage.routeName);
        }
        if (title == 'My Cart') {
          Navigator.pushNamed(context, Cartpage.routeName);
        }
        if (title == 'Payment Methods') {
          _navigateToMethodTopUpPage();
        }
        if (title == 'Notifications') {
          Navigator.pushNamed(context, NotificationPage.routeName);
        }
        if (title == 'My Orders And History') {
          Navigator.pushNamed(context, HistoryPage.routeName);
        }
        // Tambahkan navigasi lain jika diperlukan
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
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to log out from your account?",
            style: TextStyle(
              fontFamily: AppConstants.fontInterMedium,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: AppConstants.clrBlack,
                  fontFamily: AppConstants.fontInterMedium,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                try {
                  // Reset providers
                  Provider.of<AddressProvider>(context, listen: false)
                      .resetState();
                  Provider.of<UserProvider>(context, listen: false)
                      .resetState();

                  // Logout from Firebase
                  await FirebaseAuth.instance.signOut();

                  // Navigate to LoginScreen
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.routeName, (route) => false);
                } catch (e) {
                  print("Logout failed: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Failed to logout: ${e.toString()}")),
                  );
                }
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                    fontFamily: AppConstants.fontInterMedium,
                    color: AppConstants.clrBackground),
              ),
            ),
          ],
        );
      },
    );
  }
}
