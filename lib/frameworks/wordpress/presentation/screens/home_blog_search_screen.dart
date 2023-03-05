import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show AutoHideKeyboard;
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/blog_search_model.dart';
import '../../../../models/index.dart';
import '../../../../screens/index.dart';
import '../widgets/blog_list.dart';
import '../widgets/blog_recent_search.dart';

class HomeBlogSearchScreen extends StatefulWidget {
  const HomeBlogSearchScreen();

  @override
  State<StatefulWidget> createState() => _HomeBlogSearchScreenState();
}

class _HomeBlogSearchScreenState<T> extends State<HomeBlogSearchScreen> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  final _searchFieldNode = FocusNode();
  final _searchFieldController = TextEditingController();

  bool isVisibleSearch = false;
  bool _showResult = false;
  List<String>? _suggestSearch;

  BlogSearchModel get _searchModel =>
      Provider.of<BlogSearchModel>(context, listen: false);

  String get _searchKeyword => _searchFieldController.text;

//
  List<String> get suggestSearch =>
      _suggestSearch
          ?.where((s) => s.toLowerCase().contains(_searchKeyword.toLowerCase()))
          .toList() ??
      <String>[];

  @override
  void initState() {
    super.initState();
    _searchFieldNode.addListener(_onSearchFieldFocusChanged);
  }

  void _onSearchFieldFocusChanged() {
    if (_searchKeyword.isEmpty && !_searchFieldNode.hasFocus) {
      _showResult = false;
    } else {
      _showResult = !_searchFieldNode.hasFocus;
    }
  }

  @override
  void dispose() {
    _searchFieldNode.removeListener(_onSearchFieldFocusChanged);
    _searchFieldNode.dispose();
    _searchFieldController.dispose();
//    _searchModel.dispose();
    super.dispose();
  }

  void _onSearchTextChange(String value) {
    if (value.isEmpty) {
      _showResult = false;
      setState(() {});
      return;
    }

    if (_searchFieldNode.hasFocus) {
      if (suggestSearch.isEmpty) {
        setState(() {
          _showResult = true;
          _searchModel.searchBlogs(name: value);
        });
      } else {
        setState(() {
          _showResult = false;
        });
      }
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
    final suggestSearch =
        Provider.of<AppModel>(context).appConfig!.searchSuggestion ?? [''];

    var routeName = isIos ? '' : searchFieldLabel;

    _suggestSearch =
        Provider.of<AppModel>(context).appConfig!.searchSuggestion ?? [''];

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.background,
          iconTheme: theme.primaryIconTheme,
          // textTheme: theme.primaryTextTheme,
          titleSpacing: 0,
          leading: null,
          automaticallyImplyLeading: false,
          title: SearchBox(
            showSearchIcon: false,
            showCancelButton: false,
            autoFocus: true,
            controller: _searchFieldController,
            focusNode: _searchFieldNode,
            onChanged: _onSearchTextChange,
            onSubmitted: _onSubmit,
          ),
          actions: _buildActions(),
        ),
        body: AutoHideKeyboard(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            reverseDuration: const Duration(milliseconds: 300),
            child: _showResult
                ? buildResult()
                : Align(
                    alignment: Alignment.topCenter,
                    child: Consumer<BlogSearchModel>(
                      builder: (context, model, child) {
                        if (model.loading) {
                          return kLoadingWidget(context);
                        }

                        var child = _buildRecentSearch();

                        if (_searchFieldNode.hasFocus &&
                            suggestSearch.isNotEmpty) {
                          child = _buildSuggestions();
                        }

                        return child;
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearch() {
    return BlogRecentSearch(
      onTap: (text) {
        _searchFieldController.text = text;
        setState(() {
          _showResult = true;
        });
        FocusScope.of(context).requestFocus(FocusNode()); //dismiss keyboard
        Provider.of<BlogSearchModel>(context, listen: false)
            .searchBlogs(name: text);
      },
    );
  }

  Widget _buildSuggestions() {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Theme.of(context).primaryColorLight,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        itemCount: suggestSearch.length,
        itemBuilder: (_, index) {
          final keyword = suggestSearch[index];
          return GestureDetector(
            onTap: () => _onSubmit(keyword),
            child: ListTile(
              title: Text(keyword),
            ),
          );
        },
      ),
    );
  }

  Widget buildResult() {
    return Consumer<BlogSearchModel>(builder: (context, model, child) {
      if (model.loading) {
        return kLoadingWidget(context);
      }

      if (model.blogs.isEmpty) {
        return Center(child: Text(S.of(context).noProduct));
      }
      return Column(
        children: <Widget>[
          Container(
            height: 45,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.background),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Text(
                S.of(context).weFoundBlogs,
              )
            ]),
          ),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.background),
              child: BlogList(
                name: _searchFieldController.text,
                blogs: model.blogs,
              ),
            ),
          )
        ],
      );
    });
  }

  List<Widget> _buildActions() {
    return <Widget>[
      _searchFieldController.text.isEmpty
          ? IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.search),
              onPressed: () {},
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchFieldController.clear();
                _searchFieldNode.requestFocus();
              },
            ),
    ];
  }

  void _onSubmit(String name) {
    _searchFieldController.text = name;
    setState(() {
      _showResult = true;
      _searchModel.searchBlogs(name: name);
    });

    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void close() {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Navigator.of(context).pop();
  }
}
