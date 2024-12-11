
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_do_an_chuyen_nganh_nhom3/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);

  //set the list of Orders
  void setOrders(List<Order> orders) {
    state = orders;
  }

  /*Trạng thái order real time*/

  void updateOrderStatusRealtime(String orderId, {bool? processing,bool? shipping, bool? delivered}) {
    //Update trạng thái của provider với danh sách order mới
    state = [
      //Lặp qua các đơn hàng hiện có
      for(final order in state)
        //Kiểm tra xem ID của đơn hàng hiện tại có khớp với ID mà chúng ta muốn cập nhật hay không
        //so sánh ID của đơn hànghiện tại với một ID cụ thể thực hiện cập nhật
        //để tìm đơn hàng cụ thể cần chỉnh sửa.
        if(order.id == orderId)
          //Có thì tạo 1 object Order mới
          Order(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            city: order.city,
            locality: order.locality,
            phoneNumber: order.phoneNumber,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            processing: processing?? order.processing,
            shipping: shipping?? order.shipping,
            delivered: delivered?? order.delivered
          )
      //Nếu không trùng giữ nguyên
      else
        order
    ];
  }

}
final orderProvider = StateNotifierProvider<OrderProvider,List<Order>>(
        (ref) {
      return OrderProvider();
    }
);
