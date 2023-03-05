class VendorConfig {
  final bool vendorRegister;
  final bool disableVendorShipping;
  final bool showAllVendorMarkers;
  final bool disableNativeStoreManagement;
  final String dokan;
  final String wcfm;
  final bool disableMultiVendorCheckout;
  final bool disablePendingProduct;
  final String newProductStatus;
  final String? defaultStoreImage;
  final bool enableAutoApplicationApproval;
  final String? bannerFit;
  final bool expandStoreLocationByDefault;
  final bool disableDeliveryManagement;

  VendorConfig({
    this.vendorRegister = false,
    this.disableVendorShipping = true,
    this.showAllVendorMarkers = true,
    this.disableNativeStoreManagement = true,
    this.dokan = '',
    this.wcfm = '',
    this.disableMultiVendorCheckout = false,
    this.disablePendingProduct = false,
    this.newProductStatus = 'draft',
    this.defaultStoreImage,
    this.enableAutoApplicationApproval = false,
    this.bannerFit,
    this.expandStoreLocationByDefault = true,
    this.disableDeliveryManagement = true,
  });

  factory VendorConfig.fromJson(Map json) {
    return VendorConfig(
      vendorRegister: json['VendorRegister'] == true,
      disableVendorShipping: json['DisableVendorShipping'] != false,
      showAllVendorMarkers: json['ShowAllVendorMarkers'] != false,
      disableNativeStoreManagement:
          json['DisableNativeStoreManagement'] != false,
      dokan: '${json['dokan']}',
      wcfm: '${json['wcfm']}',
      disableMultiVendorCheckout: json['DisableMultiVendorCheckout'] == true,
      disablePendingProduct: json['DisablePendingProduct'] == true,
      newProductStatus: '${json['NewProductStatus'] ?? 'draft'}',
      defaultStoreImage: json['DefaultStoreImage'],
      enableAutoApplicationApproval:
          json['EnableAutoApplicationApproval'] == true,
      bannerFit: json['BannerFit'],
      expandStoreLocationByDefault:
          json['ExpandStoreLocationByDefault'] != false,
      disableDeliveryManagement: json['DisableDeliveryManagement'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['VendorRegister'] = vendorRegister;
    data['DisableVendorShipping'] = disableVendorShipping;
    data['ShowAllVendorMarkers'] = showAllVendorMarkers;
    data['DisableNativeStoreManagement'] = disableNativeStoreManagement;
    data['dokan'] = dokan;
    data['wcfm'] = wcfm;
    data['DisableMultiVendorCheckout'] = disableMultiVendorCheckout;
    data['DisablePendingProduct'] = disablePendingProduct;
    data['NewProductStatus'] = newProductStatus;
    data['DefaultStoreImage'] = defaultStoreImage;
    data['EnableAutoApplicationApproval'] = enableAutoApplicationApproval;
    data['BannerFit'] = bannerFit;
    data['ExpandStoreLocationByDefault'] = expandStoreLocationByDefault;
    data['DisableDeliveryManagement'] = disableDeliveryManagement;
    return data;
  }

  VendorConfig copyWith({
    bool? vendorRegister,
    bool? disableVendorShipping,
    bool? showAllVendorMarkers,
    bool? disableNativeStoreManagement,
    String? dokan,
    String? wcfm,
    bool? disableMultiVendorCheckout,
    bool? disablePendingProduct,
    String? newProductStatus,
    String? defaultStoreImage,
    bool? enableAutoApplicationApproval,
    String? bannerFit,
    bool? expandStoreLocationByDefault,
    bool? disableDeliveryManagement,
  }) {
    return VendorConfig(
      vendorRegister: vendorRegister ?? this.vendorRegister,
      disableVendorShipping:
          disableVendorShipping ?? this.disableVendorShipping,
      showAllVendorMarkers: showAllVendorMarkers ?? this.showAllVendorMarkers,
      disableNativeStoreManagement:
          disableNativeStoreManagement ?? this.disableNativeStoreManagement,
      dokan: dokan ?? this.dokan,
      wcfm: wcfm ?? this.wcfm,
      disableMultiVendorCheckout:
          disableMultiVendorCheckout ?? this.disableMultiVendorCheckout,
      disablePendingProduct:
          disablePendingProduct ?? this.disablePendingProduct,
      newProductStatus: newProductStatus ?? this.newProductStatus,
      defaultStoreImage: defaultStoreImage ?? this.defaultStoreImage,
      enableAutoApplicationApproval:
          enableAutoApplicationApproval ?? this.enableAutoApplicationApproval,
      bannerFit: bannerFit ?? this.bannerFit,
      expandStoreLocationByDefault:
          expandStoreLocationByDefault ?? this.expandStoreLocationByDefault,
      disableDeliveryManagement:
          disableDeliveryManagement ?? this.disableDeliveryManagement,
    );
  }
}
