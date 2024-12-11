import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/controllers/order_controller.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/order_provider.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/total_earnings_provider.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/vender_provider.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  Future<void> _fetchOrders() async {
    final vendor = ref.read(vendorProvider);
    if(vendor != null) {
      final OrderController _orderController = OrderController();
      try {
        final orders = await _orderController.loadOrders(vendorId: vendor.id);
        ref.read(totalEarningsProvider.notifier).calculateEarnings(orders);
      }
      catch(e) {
        print("Lỗi frontend $e");
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchOrders();
  }
  @override
  Widget build(BuildContext context) {
    final vendor = ref.read(vendorProvider);
    final totalEarnings = ref.read(totalEarningsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.greenAccent,
              child: Text(
                vendor!.fullName[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(width: 10,),
            Text(
              "Quản lý thu nhập của ${vendor!.fullName}",
              style: TextStyle(
                color: Colors.purple[300]
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tổng tiền thu được",style: TextStyle(fontSize: 18),),
              Text("\$ ${totalEarnings['totalEarnings']}",style: TextStyle(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold)),
              Text("Tổng order",style: TextStyle(fontSize: 18),),
              Text("${totalEarnings['totalOrders']}",style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
