import '../../../common/config/models/index.dart';
import 'app_setting.dart';
import 'background_config.dart';

/// HorizonLayout : [{'layout':'logo','showMenu':true,'showLogo':true,'showSearch':true,'name':'','color':'','menuIcon':{'name':'','fontFamily':''}},{'layout':'header_text','fontSize':25.0,'title':'Most popular, \ntrending fashion ','padding':30.0,'height':0.2,'showSearch':true,'isSafeArea':true},{'backgroundInput':false,'fontSize':13,'padding':19,'text':'Header','radius':30,'textOpacity':1,'marginRight':9,'marginBottom':0,'boxShadow':{'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0},'layout':'header_search','marginLeft':5,'showShadow':true,'borderInput':false,'marginTop':6,'shadow':10,'height':85},{'type':'icon','hideTitle':false,'originalColor':false,'noBackground':false,'wrap':false,'size':1.0,'columns':3,'radius':50.0,'border':1.0,'shadow':15.0,'boxShadow':{'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0},'layout':'category','marginLeft':10.0,'marginRight':10.0,'marginTop':10.0,'marginBottom':10.0,'data':[],'items':[{'originalColor':false,'title':false,'keepDefaultTitle':false,'colors':['#3CC2BF','#3CC2BF'],'image':'https://user-images.githubusercontent.com/1459805/62820029-2e679f00-bb88-11e9-80de-fdf115cfd942.png','tag':'58','category':'58'}]},{'layout':'bannerImage','design':'default','fit':'cover','marginLeft':5,'intervalTime':3,'items':[{'category':28,'image':'https://user-images.githubusercontent.com/1459805/59846818-12672e80-938b-11e9-8184-5f7bfe66f1a2.png','padding':15},{'padding':15,'image':'https://user-images.githubusercontent.com/1459805/60091575-1f12ca80-976f-11e9-962c-bdccff60d143.png','category':29},{'image':'https://user-images.githubusercontent.com/1459805/60091808-a19b8a00-976f-11e9-9cc7-576ca05c2442.png','padding':15,'product':30}],'marginBottom':5,'autoPlay':false,'isSlider':true,'height':0.2,'marginRight':5,'marginTop':5,'radius':2},{'isSlider':false,'marginBottom':0,'marginLeft':10,'height':0.22,'layout':'bannerImage','marginTop':0,'items':[{'image':'https://user-images.githubusercontent.com/1459805/59846820-12672e80-938b-11e9-8fa6-b331b7db331d.png','padding':5,'url':'https://inspireui.com'}],'marginRight':10,'fit':'cover'},{'isSlider':false,'items':[{'category':29,'padding':5,'image':'https://user-images.githubusercontent.com/1459805/59846823-12ffc500-938b-11e9-8d93-65ead3d6b1dd.png'},{'padding':5,'category':26,'image':'https://user-images.githubusercontent.com/1459805/59846824-12ffc500-938b-11e9-8d5a-fc42cb1b7658.png'}],'fit':'cover','marginRight':10,'height':0.35,'marginLeft':10,'marginTop':10,'marginBottom':0,'layout':'bannerImage'},{'category':'57','name':'Woman Collections','layout':'threeColumn','isSnapping':true},{'category':'58','layout':'listTile','name':'Title'},{'layout':'blog','name':'Blog'}]
/// Setting : {'MainColor':'#3FC1BE','ProductListLayout':'list','StickyHeader':true,'ProductDetail':'simpleType','FontFamily':'Raleway','TabBarConfig':{'isSafeArea':true,'color':'','radiusTopLeft':0.0,'radiusTopRight':0.0,'radiusBottomLeft':0.0,'radiusBottomRight':0.0,'paddingLeft':0.0,'paddingRight':0.0,'paddingBottom':0.0,'paddingTop':0.0,'marginTop':0.0,'marginBottom':0.0,'marginLeft':0.0,'marginRight':0.0,'boxShadow':{'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0},'TabBarIndicator':{'indicatorSize':'label','indicatorColor':'','unselectedLabelColor':'','height':0.0,'tabPosition':0.0,'topRightRadius':0.0,'topLeftRadius':0.0,'bottomRightRadius':0.0,'bottomLeftRadius':0.0,'color':0.0,'horizontalPadding':0.0,'verticalPadding':0.0,'strokeWidth':0.0,'radius':0.0,'distanceFromCenter':0.0},'TabBarCenter':{'position':0,'radius':0.0,'color':'','marginTop':0.0,'marginBottom':0.0,'marginLeft':0.0,'marginRight':0.0,'boxShadow':{'blurRadius':10.0,'colorOpacity':0.1,'spreadRadius':10.0,'x':0,'y':0}}}}
/// TabBar : [{'layout':'home','icon':'home','pos':100,'fontFamily':'CupertinoIcons','key':'p1q235ba14'},{'pos':200,'layout':'category','icon':'rectangle_grid_1x2','fontFamily':'CupertinoIcons','categoryLayout':'card','key':'hwu0rkrizt'},{'key':'2reihs4qzc','icon':'search','layout':'search','fontFamily':'CupertinoIcons','pos':300,'size':24},{'pos':400,'icon':'bag','layout':'cart','categoryLayout':'cart','key':'a2xts0oou6','fontFamily':'CupertinoIcons'},{'layout':'profile','fontFamily':'CupertinoIcons','pos':500,'key':'69jw5yx12d','icon':'person'}]
/// Drawer : {'logo':'assets/images/logo.png','items':[{'type':'home','show':true},{'type':'blog','show':true},{'type':'login','show':true},{'show':true,'type':'category'}]}
/// Background : {'color':'#eee','image':'https://google.com','height':0.18,'layout':'background'}

class AppConfig {
  late AppSetting settings;
  BackgroundConfig? background;
  List<TabBarMenuConfig> tabBar = [];
  DrawerMenuConfig? drawer;
  AppBarConfig? appBar;
  dynamic jsonData;
  List<String>? searchSuggestion = [];

  AppConfig({
    required this.settings,
    required this.tabBar,
    this.drawer,
    this.background,
    this.searchSuggestion,
  });

  AppConfig.fromJson(dynamic json) {
    if (json['Setting'] != null) {
      settings = AppSetting.fromJson(json['Setting']);
    }

    if (json['AppBar'] != null && json['AppBar'] is Map) {
      appBar = AppBarConfig.fromJson(json['AppBar']);
    }

    tabBar = [];
    if (json['TabBar'] != null) {
      json['TabBar'].forEach((v) {
        tabBar.add(TabBarMenuConfig.fromJson(v));
      });
    }

    drawer = json['Drawer'] != null
        ? DrawerMenuConfig.fromJson(json['Drawer'])
        : null;

    background = json['Background'] != null
        ? BackgroundConfig.fromJson(json['Background'])
        : null;

    if (json['searchSuggestion'] != null) {
      searchSuggestion = [];
      json['searchSuggestion'].forEach((v) {
        searchSuggestion!.add(v);
      });
    }
    // ignore: prefer_initializing_formals
    jsonData = json;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['TabBar'] = tabBar.map((v) => v.toJson()).toList();
    if (drawer != null) {
      map['Drawer'] = drawer?.toJson();
    }
    if (background != null) {
      map['Background'] = background?.toJson();
    }
    return map;
  }
}

/// logo : 'assets/images/logo.png'
/// items : [{'type':'home','show':true},{'type':'blog','show':true},{'type':'login','show':true},{'show':true,'type':'category'}]

class DrawerMenuConfig {
  String? key;
  String? logo;
  String? textColor;
  String? iconColor;
  DrawerLogoConfig logoConfig = DrawerLogoConfig();
  ZoomConfig? zoomConfig;
  List<DrawerItemsConfig>? items;
  Map<String, GeneralSettingItem>? subDrawerItem;
  String? backgroundColor;
  String? backgroundImage;
  String? colorFilter;
  num filter = 0.0;
  bool safeArea = false;
  bool enable = true;

  DrawerMenuConfig({
    this.logo,
    this.key,
    this.textColor,
    this.iconColor,
    this.zoomConfig,
    required this.logoConfig,
    this.items,
    this.subDrawerItem,
    this.backgroundColor,
    this.backgroundImage,
    this.colorFilter,
    this.filter = 0.0,
    this.safeArea = false,
    this.enable = true,
  });

  DrawerMenuConfig.fromJson(dynamic json) {
    key = json['key'];
    logo = json['logo'];
    textColor = json['textColor'];
    iconColor = json['iconColor'];
    backgroundColor = json['backgroundColor'];
    backgroundImage = json['backgroundImage'];
    colorFilter = json['colorFilter'];
    filter = json['filter'] ?? 0.0;
    safeArea = json['safeArea'] ?? false;
    enable = json['enable'] ?? true;

    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(DrawerItemsConfig.fromJson(v));
      });
    }
    if (json['subDrawerItem'] != null && json['subDrawerItem'] is Map) {
      var subs = <String, GeneralSettingItem>{};
      var data = Map.from(json['subDrawerItem']);
      for (var item in data.keys.toList()) {
        subs[item] = GeneralSettingItem.fromJson(data[item]);
      }
      subDrawerItem = subs;
    }
    if (json['logoConfig'] != null) {
      logoConfig = DrawerLogoConfig.fromJson(json['logoConfig']);
    }
    if (json['zoomConfig'] != null) {
      zoomConfig = ZoomConfig.fromJson(json['zoomConfig']);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['logo'] = logo;
    map['textColor'] = textColor;
    map['iconColor'] = iconColor;
    map['backgroundColor'] = backgroundColor;
    map['backgroundImage'] = backgroundImage;
    map['colorFilter'] = colorFilter;
    map['filter'] = filter;
    map['safeArea'] = safeArea;
    map['logoConfig'] = logoConfig.toJson();
    map['zoomConfig'] = zoomConfig?.toJson();
    map['enable'] = enable == true;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (subDrawerItem != null) {
      var subs = <String, dynamic>{};
      for (var item in subDrawerItem!.keys.toList()) {
        subs[item] = subDrawerItem?[item]?.toJson();
      }
      map['subDrawerItem'] = subs;
    }
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

class ZoomConfig {
  String style = 'default';
  bool enableShadow = false;
  num angle = 0.0; //<= 0.0 and >= -30.0
  num slideWidth = 0.65; //value * screenWidth
  num slideMargin = 0.0; //margin with slide and main screen
  num mainScreenScale = 0.3;
  num borderRadius = 16.0;
  String? backgroundImage;

  ZoomConfig({
    this.style = 'scaleRight',
    this.enableShadow = false,
    this.angle = 0.0,
    this.slideWidth = 0.65,
    this.slideMargin = 0.0,
    this.mainScreenScale = 0.3,
    this.borderRadius = 16.0,
    this.backgroundImage,
  });

  ZoomConfig.fromJson(dynamic json) {
    style = json['style'] ?? 'scaleRight';
    enableShadow = json['enableShadow'] ?? false;
    angle = json['angle'] ?? 0.0;
    slideWidth = json['slideWidth'] ?? 0.65;
    slideMargin = json['slideMargin'] ?? 0.0;
    mainScreenScale = json['mainScreenScale'] ?? 0.3;
    borderRadius = json['borderRadius'] ?? 16.0;
    backgroundImage = json['backgroundImage'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['style'] = style;
    map['enableShadow'] = enableShadow;
    map['angle'] = angle;
    map['slideWidth'] = slideWidth;
    map['slideMargin'] = slideMargin;
    map['mainScreenScale'] = mainScreenScale;
    map['borderRadius'] = borderRadius;
    map['backgroundImage'] = backgroundImage;
    return map;
  }
}

class DrawerLogoConfig {
  num? width;
  num height = 38;
  num marginLeft = 5;
  num marginRight = 0;
  num marginTop = 60;
  num marginBottom = 10;
  String? backgroundColor;
  bool useMaxWidth = false;
  String boxFit = 'cover';

  DrawerLogoConfig({
    this.width,
    this.height = 38,
    this.marginLeft = 5,
    this.marginRight = 0,
    this.marginTop = 60,
    this.marginBottom = 10,
    this.backgroundColor,
    this.useMaxWidth = false,
    this.boxFit = 'cover',
  });

  DrawerLogoConfig.fromJson(dynamic json) {
    width = json['width'];
    height = json['height'] ?? 38;
    marginLeft = json['marginLeft'] ?? 5;
    marginRight = json['marginRight'] ?? 0;
    marginTop = json['marginTop'] ?? 60;
    marginBottom = json['marginBottom'] ?? 10;
    backgroundColor = json['backgroundColor'];
    useMaxWidth = json['useMaxWidth'] ?? false;
    boxFit = json['boxFit'] ?? 'cover';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (width != null) {
      map['width'] = width;
    }
    map['height'] = height;
    map['marginLeft'] = marginLeft;
    map['marginRight'] = marginRight;
    map['marginTop'] = marginTop;
    map['marginBottom'] = marginBottom;
    map['boxFit'] = boxFit;
    if (backgroundColor != null) {
      map['backgroundColor'] = backgroundColor;
    }
    if (useMaxWidth) {
      map['useMaxWidth'] = useMaxWidth;
    }
    return map;
  }
}

/// type : 'home'
/// show : true

class DrawerItemsConfig {
  String? type;
  bool? show;

  DrawerItemsConfig({this.type, this.show});

  DrawerItemsConfig.fromJson(dynamic json) {
    type = json['type'];
    show = json['show'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['type'] = type;
    map['show'] = show;
    return map;
  }
}

/// layout : 'home'
/// icon : 'home'
/// pos : 100
/// fontFamily : 'CupertinoIcons'
/// key : 'p1q235ba14'

class TabBarMenuConfig {
  String? layout;
  String? label;
  int? pos;
  String? key;
  String icon = 'home';
  String fontFamily = 'Tahoma';
  String categoryLayout = 'card';
  List<Map>? remapCategories;

  dynamic jsonData;
  dynamic categories;
  dynamic images;
  bool parallax = false;

  /// tab menu item is not visible from the list
  bool visible = true;

  /// group the config to tab menu on home screen
  bool groupLayout = false;
  String menuLabel = '';

  bool isDefaultTab = false;

  TabBarMenuConfig({
    this.layout,
    this.icon = 'home',
    this.label,
    this.pos,
    this.fontFamily = 'Tahoma',
    this.jsonData,
    this.categories,
    this.images,
    this.categoryLayout = 'card',
    this.visible = true,
    this.groupLayout = false,
    this.menuLabel = '',
    this.isDefaultTab = false,
    this.key,
  });

  TabBarMenuConfig.fromJson(dynamic json) {
    layout = json['layout'];
    icon = json['icon'];
    label = json['label'];
    pos = json['pos'];
    fontFamily = json['fontFamily'] ?? 'Tahoma';
    key = json['key'];
    categories = json['categories'];
    images = json['images'];
    categoryLayout = json['categoryLayout'] ?? 'card';

    final jsonRemap = json['remapCategories'];
    if (jsonRemap != null) {
      remapCategories = List<Map>.from(jsonRemap);
    }
    // ignore: prefer_initializing_formals
    jsonData = json;

    /// enable parallax on Category Card Image
    parallax = json['parallax'] ?? false;

    visible = json['visible'] ?? true;
    groupLayout = json['groupLayout'] ?? false;
    menuLabel = json['menuLabel'] ?? '';

    isDefaultTab = json['defaultTab'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['layout'] = layout;
    map['icon'] = icon;
    map['pos'] = pos;
    map['fontFamily'] = fontFamily;
    map['parallax'] = parallax;
    map['visible'] = visible;
    map['groupLayout'] = groupLayout;
    map['menuLabel'] = menuLabel;
    map['defaultTab'] = isDefaultTab;
    map['key'] = key;
    return map;
  }
}

class AppBarConfig {
  String? key;
  String? backgroundColor;
  List<AppBarItemConfig>? items;
  List<AppBarItemConfig>? bottomItems;
  List<dynamic>? showOnScreens;
  bool enable = true;
  bool alwaysShowAppBar = false;
  bool snap = true;
  bool pinned = true;
  bool floating = true;
  num elevation = 0;

  AppBarConfig({
    this.key,
    this.items,
    this.bottomItems,
    this.showOnScreens,
    this.enable = true,
    this.alwaysShowAppBar = false,
    this.snap = true,
    this.pinned = true,
    this.floating = true,
    this.elevation = 0,
  });

  bool shouldShowOn(String screenName) {
    if (enable) {
      if (alwaysShowAppBar) return true;
      return showOnScreens?.contains(screenName) ?? false;
    }
    return false;
  }

  AppBarConfig replaceItems(dynamic json) {
    final itemsData = json['items'];
    final bottomItemsData = json['expandedItems'];

    final items = [];
    final bottomItems = [];
    if (itemsData is List) {
      for (var item in itemsData) {
        items.add(AppBarItemConfig.fromJson(item));
      }
    }
    if (bottomItemsData is List) {
      for (var item in bottomItemsData) {
        bottomItems.add(AppBarItemConfig.fromJson(item));
      }
    }

    if (items.isEmpty && bottomItems.isEmpty) {
      return this;
    }

    return AppBarConfig(
      key: key,
      items: List<AppBarItemConfig>.from(items),
      bottomItems: List<AppBarItemConfig>.from(bottomItems),
      showOnScreens: showOnScreens,
    );
  }

  AppBarConfig.fromJson(dynamic json) {
    key = json['key'];
    showOnScreens = json['showOnScreens'] ?? [];
    backgroundColor = json['backgroundColor'];
    enable = json['enable'] ?? true;
    snap = json['snap'] ?? true;
    pinned = json['pinned'] ?? true;
    floating = json['floating'] ?? true;
    elevation = json['elevation'] ?? 0;
    alwaysShowAppBar = json['alwaysShowAppBar'] ?? false;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(AppBarItemConfig.fromJson(v));
      });
    }
    if (json['expandedItems'] != null) {
      bottomItems = [];
      json['expandedItems'].forEach((v) {
        bottomItems?.add(AppBarItemConfig.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['showOnScreens'] = showOnScreens;
    map['backgroundColor'] = backgroundColor;
    map['enable'] = enable;
    map['snap'] = snap;
    map['pinned'] = pinned;
    map['floating'] = floating;
    map['elevation'] = elevation;
    map['alwaysShowAppBar'] = alwaysShowAppBar;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    if (bottomItems != null) {
      map['expandedItems'] = bottomItems?.map((v) {
        v.onlyShowWhenAtTop = false;
        return v.toJson();
      }).toList();
    }
    map.removeWhere((key, value) => value == null);
    return map;
  }
}

class AppBarItemConfig {
  String? type;
  String? action;
  int? pos;
  String? title;
  num fontSize = 16.0;
  num textOpacity = 0.5;
  String? fontFamily;
  String? fontWeight;
  String? alignment;
  String? textColor;
  String? icon;
  num size = 44.0;
  num iconSize = 24.0;
  num radius = 24.0;
  String? iconColor;
  String? backgroundColor;
  num marginLeft = 4.0;
  num marginRight = 4.0;
  num marginTop = 4.0;
  num marginBottom = 4.0;
  num paddingLeft = 4.0;
  num paddingRight = 4.0;
  num paddingTop = 4.0;
  num paddingBottom = 4.0;
  bool hideTitle = false;
  String? image;
  String? imageColor; //use for png
  String? imageBoxFit;
  num? width;
  num? height;
  String? key;
  String? actionLink;
  bool onlyShowWhenAtTop = false;
  bool isCustomSpace = false;

  AppBarItemConfig({
    this.type,
    this.action,
    this.pos,
    this.title,
    this.textOpacity = 0.5,
    this.alignment = 'center',
    this.fontSize = 16.0,
    this.fontFamily = 'CupertinoIcons',
    this.fontWeight = '400',
    this.textColor,
    this.icon = 'person',
    this.size = 44.0,
    this.iconSize = 24.0,
    this.radius = 24.0,
    this.iconColor,
    this.backgroundColor,
    this.marginLeft = 4.0,
    this.marginRight = 4.0,
    this.marginTop = 4.0,
    this.marginBottom = 4.0,
    this.paddingLeft = 4.0,
    this.paddingRight = 4.0,
    this.paddingTop = 4.0,
    this.paddingBottom = 4.0,
    this.hideTitle = false,
    this.image,
    this.imageColor,
    this.imageBoxFit,
    this.width,
    this.height,
    this.key,
    this.actionLink,
    this.onlyShowWhenAtTop = false,
    this.isCustomSpace = false,
  });

  AppBarItemConfig.fromJson(dynamic json) {
    type = json['type'] ?? 'icon';
    action = json['action'];
    pos = json['pos'] ?? 100;
    title = json['title'];
    textOpacity = json['textOpacity'] ?? 0.5;
    alignment = json['alignment'] ?? 'center';
    fontSize = json['fontSize'] ?? 16.0;
    fontFamily = json['fontFamily'] ?? 'CupertinoIcons';
    fontWeight = json['fontWeight'] ?? '400';
    textColor = json['textColor'];
    icon = json['icon'] ?? 'person';
    iconSize = json['iconSize'] ?? 24.0;
    size = json['size'] ?? 44.0;
    radius = json['radius'] ?? 0;
    iconColor = json['iconColor'];
    backgroundColor = json['backgroundColor'];
    marginLeft = json['marginLeft'] ?? 0;
    marginRight = json['marginRight'] ?? 0;
    marginTop = json['marginTop'] ?? 0;
    marginBottom = json['marginBottom'] ?? 0;
    paddingLeft = json['paddingLeft'] ?? 0;
    paddingRight = json['paddingRight'] ?? 0;
    paddingTop = json['paddingTop'] ?? 0;
    paddingBottom = json['paddingBottom'] ?? 0;
    hideTitle = json['hideTitle'] ?? false;
    image = json['image'];
    imageColor = json['imageColor'];
    imageBoxFit = json['imageBoxFit'];
    width = json['width'];
    height = json['height'];
    key = json['key'];
    actionLink = json['actionLink'];
    onlyShowWhenAtTop = json['onlyShowWhenAtTop'] ?? false;
    isCustomSpace = json['isCustomSpace'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (type != null) data['type'] = type;
    if (action != null) data['action'] = action;
    if (pos != null) data['pos'] = pos;
    if (title != null) data['title'] = title;
    data['textOpacity'] = textOpacity;
    if (alignment != null) data['alignment'] = alignment;
    data['fontSize'] = fontSize;
    if (fontFamily != null) data['fontFamily'] = fontFamily;
    if (fontWeight != null) data['fontWeight'] = fontWeight;
    if (textColor != null) data['textColor'] = textColor;
    if (icon != null) data['icon'] = icon;
    data['iconSize'] = iconSize;
    data['size'] = size;
    data['radius'] = radius;
    if (iconColor != null) data['iconColor'] = iconColor;
    if (backgroundColor != null) data['backgroundColor'] = backgroundColor;
    data['marginLeft'] = marginLeft;
    data['marginRight'] = marginRight;
    data['marginTop'] = marginTop;
    data['marginBottom'] = marginBottom;
    data['paddingLeft'] = paddingLeft;
    data['paddingRight'] = paddingRight;
    data['paddingTop'] = paddingTop;
    data['paddingBottom'] = paddingBottom;
    if (hideTitle) data['hideTitle'] = hideTitle;
    if (image != null) data['image'] = image;
    if (imageColor != null) data['imageColor'] = imageColor;
    if (imageBoxFit != null) data['imageBoxFit'] = imageBoxFit;
    if (width != null) data['width'] = width;
    if (height != null) data['height'] = height;
    if (key != null) data['key'] = key;
    if (actionLink != null) data['actionLink'] = actionLink;
    if (onlyShowWhenAtTop) data['onlyShowWhenAtTop'] = onlyShowWhenAtTop;
    if (isCustomSpace) data['isCustomSpace'] = isCustomSpace;
    return data;
  }
}
