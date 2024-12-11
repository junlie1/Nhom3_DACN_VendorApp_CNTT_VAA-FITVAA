import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/nav_screens/earnings_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/nav_screens/edit_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/nav_screens/order_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/nav_screens/profile_screen.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/nav_screens/upload_screen.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;
  List<Widget> _pages = [
    EarningsScreen(),
    UploadScreen(),
    EditScreen(),
    OrderScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.purple,
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.money_dollar,),label: "Earnings"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.upload_circle,),label: "Upload Product"),
          BottomNavigationBarItem(icon: Icon(Icons.edit),label: "Edit Product"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.shopping_cart,),label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile"),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}