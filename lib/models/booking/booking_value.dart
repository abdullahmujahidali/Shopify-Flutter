import 'staff_booking_model.dart';

class BookingValue {
  List<StaffBookingModel>? staffs;
  String? selectDate;
  List<String>? listSlotSelect;
  bool isLoadingSlot;
  String? idProduct;

  BookingValue({
    required this.idProduct,
    this.staffs,
    this.selectDate,
    this.listSlotSelect,
    this.isLoadingSlot = false,
  });

  BookingValue copyWith({
    List<StaffBookingModel>? staffs,
    String? selectDate,
    List<String>? listSlotSelect,
    bool? isLoadingSlot,
    String? idProduct,
  }) {
    return BookingValue(
      idProduct: idProduct ?? this.idProduct,
      staffs: staffs ?? this.staffs,
      selectDate: selectDate ?? this.selectDate,
      listSlotSelect: listSlotSelect ?? this.listSlotSelect,
      isLoadingSlot: isLoadingSlot ?? this.isLoadingSlot,
    );
  }
}
