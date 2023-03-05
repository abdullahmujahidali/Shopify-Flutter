import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show AutoHideKeyboard;
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart'
    show BackDropArguments, Category, CategoryModel;
import '../../routes/flux_navigate.dart';
import '../common/app_bar_mixin.dart';
import '../index.dart' show SearchBox;

class CategorySearch extends StatefulWidget {
  const CategorySearch();

  @override
  State<StatefulWidget> createState() => _CategorySearchState();
}

class _CategorySearchState<T> extends State<CategorySearch> with AppBarMixin {
  final _searchFieldNode = FocusNode();
  final _searchFieldController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  List<Category> categories = [];
  String? _keyword;

  @override
  void initState() {
    super.initState();
    screenScrollController = _scrollController;
  }

  @override
  void dispose() {
    _searchFieldNode.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  void _onSearchTextChange(String value) {
    setState(() {
      _keyword = value;
    });
    if (value.isEmpty) {
      setState(() {
        categories = [];
      });
      return;
    }

    if (_searchFieldNode.hasFocus || value.isNotEmpty) {
      final categoryModel = Provider.of<CategoryModel>(context, listen: false);
      categories = categoryModel.categories!
          .where((e) => e.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    var theme = Theme.of(context);
    theme = Theme.of(context).copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryTextTheme: theme.textTheme,
    );
    final searchFieldLabel = MaterialLocalizations.of(context).searchFieldLabel;
    var routeName = isIos ? '' : searchFieldLabel;

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: renderScaffold(
        routeName: RouteList.categorySearch,
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        secondAppBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: theme.colorScheme.background,
          iconTheme: theme.primaryIconTheme,
          // textTheme: theme.primaryTextTheme,
          // brightness: theme.primaryColorBrightness,
          centerTitle: false,
          leadingWidth: 24,
          titleSpacing: 0,
          title: SearchBox(
            showQRCode: false,
            showSearchIcon: false,
            showCancelButton: false,
            autoFocus: true,
            controller: _searchFieldController,
            focusNode: _searchFieldNode,
            onChanged: _onSearchTextChange,
          ),
        ),
        child: AutoHideKeyboard(
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 300),
                  child: buildResult(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResult() {
    if ((_keyword?.isNotEmpty ?? false) && categories.isEmpty) {
      return Center(
        child: Text(S.of(context).notFound),
      );
    }
    return ListView.separated(
      controller: _scrollController,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        var item = categories[index];
        return _SearchCategoryItem(category: item);
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black.withOpacity(0.05),
      ),
    );
  }

  void close() {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Navigator.of(context).pop();
  }
}

class _SearchCategoryItem extends StatelessWidget {
  final Category category;

  const _SearchCategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FluxNavigate.pushNamed(
        RouteList.backdrop,
        arguments: BackDropArguments(
          cateId: category.id,
          cateName: category.name,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(category.image!), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(category.name!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
