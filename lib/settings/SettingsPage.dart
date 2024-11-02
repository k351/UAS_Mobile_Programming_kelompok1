import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isGeolocationEnabled = false;
  bool isSafeModeEnabled = false;
  bool isHDImageQualityEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: const Text(
                          'Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Kelompok 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Kelompok1@example.com',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        //buat profil, nanti lanjut lagi
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      'Account Settings',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingsItem(Icons.location_on, 'My Addresses',
                        'Set shopping delivery address',),
                    _buildSettingsItem(Icons.shopping_cart, 'My Cart',
                        'Add, remove products and move to checkout'),
                    _buildSettingsItem(Icons.favorite, 'Wishlist',
                         'Things That I Want to Buy'),
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

                    const SizedBox(height: 20),

                    const Text(
                      'App Settings',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingsItem(Icons.cloud, 'Load Data',
                        'Upload Data to your Cloud Firebase'),

                    const SizedBox(height: 10),
                    _buildSwitchItem(
                        Icons.location_on,
                        'Geolocation',
                        'Set recommendation based on location',
                        isGeolocationEnabled, (value) {
                      setState(() {
                        isGeolocationEnabled = value;
                      });
                    }),
                    _buildSwitchItem(
                        Icons.shield,
                        'Safe Mode',
                        'Search result is safe for all ages',
                        isSafeModeEnabled, (value) {
                      setState(() {
                        isSafeModeEnabled = value;
                      });
                    }),
                    _buildSwitchItem(
                        Icons.dark_mode,
                        'Dark Mode',
                        'Switch between light and dark themes for a more comfortable viewing experience in low light',
                        isHDImageQualityEnabled, (value) {
                      setState(() {
                        isHDImageQualityEnabled = value;
                      });
                    }),

                    const SizedBox(height: 20),

                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // buat navigasi, tujuannya nanti masukin di sized box
      },
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, String subtitle,
      bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
          ),
          elevation: 5, 
          title: Row(
            children: [
              const Icon(Icons.logout,
                  color: Colors.red, size: 24),
              const SizedBox(width: 10),
              const Text("Confirm Logout"),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // kalau mau bisa log out logicnya disini
              },
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
