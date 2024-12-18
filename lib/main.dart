import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';
import 'package:uas_flutter/Home/Providers/saldoprovider.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/auth/providers/user_provider.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/history/providers/transaction_provider.dart';
import 'package:uas_flutter/routes.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';
import 'package:uas_flutter/settings/provider/edit_profile_provider.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCDvVNptqr7DRt2DYrba7hqalTO3sMyiyM",
        appId: "1:37912886138:android:01164df43a2656dc73b4c3",
        messagingSenderId: "37912886138",
        projectId: "uasmoprog-93d47"),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => Cartprovider()),
        ChangeNotifierProvider(create: (context) => EditProfileProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => CheckoutProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => SaldoProvider()),
        ChangeNotifierProvider(create: (context) => AddressProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppConstants.clrBackground,
          fontFamily: "Inter",
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: AppConstants.clrBlack),
            bodyLarge: TextStyle(color: AppConstants.clrBlack),
            bodyMedium: TextStyle(color: AppConstants.clrBlack),
          ),
          primarySwatch: Colors.blue,
        ),
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? Myhomepage.routeName
            : LoginScreen.routeName,
        routes: routes,
      ),
    );
  }
}
