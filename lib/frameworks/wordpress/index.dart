import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../models/blog_search_model.dart';
import '../../models/entities/index.dart';
import '../../models/index.dart'
    show Country, CountryState, ListCountry, User, UserModel;
import '../../modules/dynamic_layout/config/blog_config.dart';
import '../../screens/categories/layouts/side_menu_with_group.dart';
import '../../screens/index.dart' hide SideMenuCategories, SubCategories;
import '../../services/index.dart';
import '../frameworks.dart';
import 'presentation/screens/blog_search_screen.dart';
import 'presentation/screens/blog_wish_list_screen.dart';
import 'presentation/screens/home_blog_search_screen.dart';
import 'presentation/screens/post_management/post_management.dart';
import 'presentation/widgets/blog_list_layout.dart';
import 'presentation/widgets/category_layout/cardlist/index.dart';
import 'presentation/widgets/category_layout/side_menu.dart';
import 'presentation/widgets/category_layout/sub.dart';
import 'presentation/widgets/comments/comment_text_field.dart';
import 'presentation/widgets/comments/comments.dart';
import 'presentation/widgets/horizontal_list_items.dart';
import 'presentation/widgets/horizontal_slider_list.dart';
import 'presentation/widgets/related_blog_list.dart';
import 'presentation/widgets/slider_item.dart';
import 'presentation/widgets/vertical/vertical.dart';

class WordPressWidget extends BaseFrameworks {
  @override
  void updateUserInfo(
      {User? loggedInUser,
      context,
      required onError,
      onSuccess,
      required currentPassword,
      required userDisplayName,
      userEmail,
      userNiceName,
      userUrl,
      userPassword,
      userFirstname,
      userLastname}) {
    var params = {
      'user_id': loggedInUser!.id,
      'display_name': userDisplayName,
      'user_email': userEmail,
      'user_nicename': userNiceName,
      'user_url': userUrl,
    };
    if (!loggedInUser.isSocial! && userPassword!.isNotEmpty) {
      params['user_pass'] = userPassword;
    }
    if (!loggedInUser.isSocial! && currentPassword.isNotEmpty) {
      params['current_pass'] = currentPassword;
    }
    Services().api.updateUserInfo(params, loggedInUser.cookie)!.then((value) {
      var param = value!['data'] ?? value;
      param['password'] = userPassword;
      onSuccess!(User.fromJson(param));
    }).catchError((e) {
      onError(e.toString());
    });
  }

  void getListCountries() {
    /// Get List Countries
    Services().api.getCountries()?.then(
      (countries) async {
        SettingsBox().countries = countries;
      },
    );
  }

  @override
  Future<void> onLoadedAppConfig(String? lang, Function callback) async {
    /// Get the config from Caching
    if (kAdvanceConfig.isCaching) {
      final configCache = await Services().api.getHomeCache(lang);
      if (configCache != null) {
        callback(configCache);
      }
    }

    /// get list countries
    getListCountries();
  }

  @override
  Future<List<Country>?> loadCountries() async {
    List<Country>? countries = <Country>[];
    if (kDefaultCountry.isNotEmpty) {
      for (var item in kDefaultCountry) {
        countries.add(Country.fromConfig(
            item['iosCode'], item['name'], item['icon'], []));
      }
    } else {
      try {
        countries = ListCountry.fromWooJson(SettingsBox().countries).list;
      } catch (err) {
        printLog(err);
      }
    }
    return countries;
  }

  @override
  Future<List<CountryState>> loadStates(Country country) async {
    final items = await Tools.loadStatesByCountry(country.id!);
    var states = <CountryState>[];
    if (items.isNotEmpty) {
      for (var item in items) {
        states.add(CountryState.fromConfig(item));
      }
    } else {
      try {
        final items = await Services().api.getStatesByCountryId(country.id);
        if (items != null && items.isNotEmpty) {
          for (var item in items) {
            states.add(CountryState.fromWooJson(item));
          }
        }
      } catch (e) {
        printLog(e.toString());
      }
    }
    return states;
  }

  @override
  Future<void> resetPassword(BuildContext context, String username) async {
    try {
      final val = await (Provider.of<UserModel>(context, listen: false)
          .submitForgotPassword(
              forgotPwLink: '',
              data: {'user_login': username}) as Future<String>);
      if (val.isEmpty) {
        Tools.showSnackBar(
            ScaffoldMessenger.of(context), S.of(context).checkConfirmLink);
        Future.delayed(
            const Duration(seconds: 1), () => Navigator.of(context).pop());
      } else {
        Tools.showSnackBar(ScaffoldMessenger.of(context), val);
      }
      return;
    } catch (e) {
      printLog('Unknown Error: $e');
    }
  }

  @override
  Widget renderLargeCardHorizontalListItems(Map<String, dynamic>? config) {
    return LargeCardHorizontalListItems(
      config,
      key: config?['key'] != null ? Key(config!['key']) : null,
    );
  }

  @override
  Widget renderSliderList(Map<String, dynamic>? config) {
    return HorizontalSliderList(
      config,
      key: config?['key'] != null ? Key(config!['key']) : null,
    );
  }

  @override
  Widget renderSliderItem(Map<String, dynamic>? config) {
    return SliderItem(
      config,
      key: config?['key'] != null ? Key(config!['key']) : null,
    );
  }

  @override
  Widget renderHorizontalListItem(Map<String, dynamic>? config,
      {cleanCache = false}) {
    return BlogListLayout(
      config: BlogConfig.fromJson(config ?? {}),
      key: config?['key'] != null ? Key(config!['key']) : null,
    );
  }

  @override
  Widget renderVerticalLayout(
      Map<String, dynamic> config, bool enableScrollView) {
    return VerticalLayout(config: config);
  }

  @override
  Widget renderPostManagementScreen() {
    return PostManagementScreen();
  }

  @override
  Widget renderSearchScreen() {
    return ChangeNotifierProvider<BlogSearchModel>(
      create: (context) => BlogSearchModel(),
      builder: (context, _) {
        return const BlogSearchScreen(key: Key('search'));
      },
    );
  }

  @override
  Widget renderWishListScreen() {
    return const BlogWishListScreen();
  }

  @override
  Widget renderHomeSearchScreen() {
    return ChangeNotifierProvider(
      create: (_) => BlogSearchModel(),
      child: const HomeBlogSearchScreen(),
    );
  }

  @override
  Widget renderCommentLayout(dynamic postId, kBlogLayout type) {
    return CommentLayout(
      postId: postId,
      type: type,
    );
  }

  @override
  Widget renderCommentField(dynamic postId) {
    return CommentInput(blogId: postId);
  }

  @override
  Widget renderRelatedBlog({categoryId, required kBlogLayout type}) {
    return RelatedBlogList(
      categoryId: categoryId,
      type: type,
    );
  }

  /// render category layout
  @override
  Widget renderCategoryLayout({
    required String layout,
    bool enableParallax = false,
    double? parallaxImageRatio,
    ScrollController? scrollController,
  }) {
    switch (layout) {
      case CardCategories.type:
        return CardCategories(
          enableParallax: enableParallax,
          parallaxImageRatio: parallaxImageRatio,
          scrollController: scrollController,
        );
      case ColumnCategories.type:
        return ColumnCategories(
          scrollController: scrollController,
        );
      case SubCategories.type:
        return SubCategories(
          scrollController: scrollController,
        );
      case SideMenuCategories.type:
        return const SideMenuCategories();
      case SideMenuSubCategories.type:
        return const SideMenuSubCategories();
      case GridCategory.type:
        return GridCategory(
          scrollController: scrollController,
        );
      case SideMenuGroupCategories.type:
        return const SideMenuGroupCategories();
      case HorizonMenu.type:
      default:
        return HorizonMenu(
          scrollController: scrollController,
        );
    }
  }

  @override
  Widget reOrderButton(Order order) {
    return const SizedBox();
  }
}
