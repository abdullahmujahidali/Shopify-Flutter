import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';

/// layout : 'logo'
/// showMenu : true
/// showLogo : true
/// showSearch : true
/// name : ''
/// color : ''
/// menuIcon : {'name':'','fontFamily':''}

class LogoConfig {
  String? layout;
  String? name;
  String? image;
  bool? showMenu;
  bool showLogo = false;
  bool showSearch = false;
  bool showCart = false;
  bool showNotification = false;
  double opacity = 1.0;
  double iconOpacity = 0.0;
  double iconRadius = 6.0;
  double iconSize = 24.0;
  HexColor? color;
  HexColor? iconColor;
  HexColor? iconBackground;
  MenuIcon? menuIcon;
  MenuIcon? cartIcon;
  MenuIcon? searchIcon;
  MenuIcon? notificationIcon;

  LogoConfig({
    this.layout,
    this.showMenu,
    this.image,
    this.showLogo = false,
    this.showSearch = false,
    this.showCart = false,
    this.showNotification = false,
    this.opacity = 1,
    this.iconOpacity = 0.0,
    this.iconRadius = 6.0,
    this.iconSize = 24.0,
    this.name,
    this.color,
    this.iconColor,
    this.iconBackground,
    this.cartIcon,
    this.searchIcon,
    this.menuIcon,
    this.notificationIcon,
  });

  LogoConfig.fromJson(dynamic json) {
    layout = json['layout'];
    name = json['name'];
    image = json['image'];
    showMenu = json['showMenu'];
    showLogo = json['showLogo'] ?? false;

    showSearch = json['showSearch'] ?? false;
    showCart = json['showCart'] ?? false;
    showNotification = json['showNotification'] ?? false;

    opacity = Helper.formatDouble(json['opacity']) ?? 1.0;
    iconOpacity = Helper.formatDouble(json['iconOpacity']) ?? 0.0;
    iconRadius = Helper.formatDouble(json['iconRadius']) ?? 6.0;
    iconSize = Helper.formatDouble(json['iconSize']) ?? 24.0;

    if (json['color'] != null) {
      color = HexColor(json['color']);
    }
    if (json['iconColor'] != null) {
      iconColor = HexColor(json['iconColor']);
    }
    if (json['iconBackground'] != null) {
      iconBackground = HexColor(json['iconBackground']);
    }

    searchIcon = json['searchIcon'] != null
        ? MenuIcon.fromJson(json['searchIcon'])
        : null;
    menuIcon =
        json['menuIcon'] != null ? MenuIcon.fromJson(json['menuIcon']) : null;
    cartIcon =
        json['cartIcon'] != null ? MenuIcon.fromJson(json['cartIcon']) : null;
    notificationIcon = json['notificationIcon'] != null
        ? MenuIcon.fromJson(json['notificationIcon'])
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['showMenu'] = showMenu;
    map['showLogo'] = showLogo;
    map['showSearch'] = showSearch;
    map['showCart'] = showCart;
    map['showNotification'] = showNotification;
    map['name'] = name;
    map['color'] = color;
    if (menuIcon != null) {
      map['menuIcon'] = menuIcon?.toJson();
    }
    if (cartIcon != null) {
      map['cartIcon'] = cartIcon?.toJson();
    }
    if (notificationIcon != null) {
      map['notificationIcon'] = notificationIcon?.toJson();
    }
    return map;
  }
}

/// name : ''
/// fontFamily : ''

class MenuIcon {
  String? name;
  String? fontFamily;

  MenuIcon({this.name, this.fontFamily});

  MenuIcon.fromJson(dynamic json) {
    name = json['name'];
    fontFamily = json['fontFamily'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['fontFamily'] = fontFamily;
    return map;
  }
}
