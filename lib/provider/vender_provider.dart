import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/vendor.dart';

class VenderProvider extends StateNotifier<Vendor?> {
  VenderProvider() : super (
    Vendor(
        id: '',
        fullName: '',
        email: '',
        state: '',
        city: '',
        locality: '',
        role: '',
        password: ''
    )
  );

  /*Method getter*/
  Vendor? get vendor => state;

  /*Method setter*/
  void setVendor(String vendorJson) {
    state = Vendor.fromJson(vendorJson);
  }

  /*Đăng xuất vendor*/
  void signOutVender() {
    state = null;
  }
}
final vendorProvider = StateNotifierProvider<VenderProvider, Vendor?>((ref) => VenderProvider());