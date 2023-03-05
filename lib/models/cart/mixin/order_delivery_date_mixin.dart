import '../../entities/order_delivery_date.dart';

import 'cart_mixin.dart';

mixin OrderDeliveryMixin on CartMixin {
  OrderDeliveryDate? selectedDate;
  Map<String, OrderDeliveryDate> selectedDateByStoreId = {};

  void setOrderDeliveryDate(OrderDeliveryDate ordd) {
    selectedDate = ordd;
  }

  void setOrderDeliveryDateByStoreId(OrderDeliveryDate ordd, String id) {
    selectedDateByStoreId[id] = ordd;
  }
}
