import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/vender_provider.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/authenication/login_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/authenication/register_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/main_vendor_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

/*Check vendor có login hay chưa*/
  Future<void> _checkTokenVendor(WidgetRef ref) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    /*Lấy dữ liệu bên vendorProvider*/
    String? token = preferences.getString('auth_token');
    String? vendorJson = preferences.getString('vendor');

    if(token != null && vendorJson != null) {
      ref.read(vendorProvider.notifier).setVendor(vendorJson);
    }
    else {
      ref.read(vendorProvider.notifier).signOutVender();
    }
  }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vendor nhóm 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: Locale('vi', 'VN'), // Thiết lập ngôn ngữ mặc định là tiếng Việt
      supportedLocales: [
        Locale('en', 'US'), // Tiếng Anh
        Locale('vi', 'VN'), // Tiếng Việt
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: FutureBuilder(
          future: _checkTokenVendor(ref),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            else {
              final vendor = ref.watch(vendorProvider);
              return vendor != null ? MainVendorScreen() : LoginScreen();
            }
          }
      ),
    );
  }
}

