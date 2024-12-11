import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/order.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/order_provider.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/provider/vender_provider.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/views/screens/details/order_detail_screen.dart';

import '../../../controllers/order_controller.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  Future<void> _fetchOrders() async {
    final vendor = ref.read(vendorProvider);
    if(vendor != null) {
      final OrderController _orderController = OrderController();
      try {
        final orders = await _orderController.loadOrders(vendorId: vendor.id);
        ref.read(orderProvider.notifier).setOrders(orders);
      }
      catch(e) {
        print("Lỗi frontend $e");
      }
    }
  }

  Future<void> _deleteOrder(String orderId, bool shipping) async {
    final OrderController _orderController = OrderController();
    try {
      await _orderController.deleteOrder(id: orderId, shipping: shipping, context: context);
      /*Gọi lại để cập nhật order sau mỗi khi xóa*/
      _fetchOrders();
    }
    catch(e) {

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
    final orders = ref.watch(orderProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Order"),
      ),
      body: orders.isEmpty
          ? Text("Bạn chưa order sản phẩm nào cả")
          : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context,index) {
            final Order order = orders[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OrderDetailScreen(order: order);
                  }));
                },
//Khung chứa item
                child: Container(
                  width: 336,
                  height: 155,
                  decoration: const BoxDecoration(),
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Container(
                            //Giao diện cho khung
                            width: 336,
                            height: 155,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.lightBlueAccent
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            //Phần bên trong khung
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 13,
                                  top: 10,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBCC5FF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      /*Ảnh order*/
                                      children: [
                                        Positioned(
                                          left: 11.5,
                                          top: 6,
                                          child: Image.network(
                                            order.image,
                                            width: 58,
                                            height: 67,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                /*Tên, category, price*/
                                Positioned(
                                  left: 102,
                                  top: 13,
                                  child: SizedBox(
                                    width: 220,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  /*Tên*/
                                                  child: Text(
                                                    order.productName,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Align(
                                                  alignment:Alignment.centerLeft,
                                                  /*Category*/
                                                  child: Text(
                                                    order.category,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                /*Giá*/
                                                Text(
                                                  "\$${order.productPrice.toStringAsFixed(2)} x ${order.quantity}",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /*Processing*/
                                Positioned(
                                  left: 11,
                                  top: 113,
                                  child: Container(
                                    width: 100,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: order.delivered == true
                                          ? Colors.green
                                          :order.shipping == true
                                          ? Colors.lightBlueAccent
                                          : order.processing == true
                                          ? Colors.purple
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 9,
                                          top: 2,
                                          child: Text(
                                            order.delivered == true
                                                ? "Delivered"
                                                : order.shipping == true
                                                ? "Shipping"
                                                : order.processing == true
                                                ? "Processing"
                                                : "Cancelled",
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.3,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 115,
                                  left: 298,
                                  child: InkWell(
                                    onTap: () {
                                      _deleteOrder(order.id, order.shipping);
                                    },
                                    child: Image.asset(
                                      'assets/icons/delete.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}
