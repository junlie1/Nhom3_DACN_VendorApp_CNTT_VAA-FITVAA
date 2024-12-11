import 'package:flutter/material.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/controllers/vendor_auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  VendorAuthController _vendorAuthController = VendorAuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _vendorAuthController.signOutVendor(context: context);
          },
          child: Text("Đăng xuất"),
        ),
      ),
    );
  }
}
