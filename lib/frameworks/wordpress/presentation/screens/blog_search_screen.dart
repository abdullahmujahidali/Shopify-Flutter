import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/blog_search_model.dart';
import '../../../../screens/common/app_bar_mixin.dart';
import '../widgets/blog_list.dart';
import '../widgets/blog_recent_search.dart';

class BlogSearchScreen extends StatefulWidget {
  const BlogSearchScreen({Key? key}) : super(key: key);

  @override
  State<BlogSearchScreen> createState() => _StateSearchScreen();
}

class _StateSearchScreen extends State<BlogSearchScreen> with AppBarMixin {
  bool isVisibleSearch = false;
  String searchText = '';
  var textController = TextEditingController();
  Timer? _timer;
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      isVisibleSearch = _focus.hasFocus;
    });
  }

  Widget _renderSearchLayout() {
    return ListenableProvider.value(
      value: Provider.of<BlogSearchModel>(context, listen: false),
      child: Consumer<BlogSearchModel>(builder: (context, model, child) {
        if (searchText.isEmpty) {
          return BlogRecentSearch(
            onTap: (text) {
              setState(() {
                searchText = text;
              });
              textController.text = text;
              FocusScope.of(context)
                  .requestFocus(FocusNode()); //dismiss keyboard
              Provider.of<BlogSearchModel>(context, listen: false)
                  .searchBlogs(name: text);
            },
          );
        }

        if (model.loading) {
          return kLoadingWidget(context);
        }

        if (model.errMsg.isNotEmpty) {
          return Center(
              child:
                  Text(model.errMsg, style: const TextStyle(color: kErrorRed)));
        }

        if (model.blogs.isEmpty) {
          return Center(child: Text(S.of(context).noProduct));
        }

        return Column(
          children: <Widget>[
            Container(
              height: 45,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.background),
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
                child: BlogList(name: searchText, blogs: model.blogs),
              ),
            )
          ],
        );
      }),
    );
  }

  AppBar? renderAppBar() {
    if (Navigator.canPop(context)) {
      return AppBar(
        elevation: 0.1,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          S.of(context).search,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        leading: Navigator.of(context).canPop()
            ? Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
              )
            : const SizedBox(),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: RouteList.search,
      secondAppBar: renderAppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            if (!Navigator.canPop(context)) ...[
              AnimatedContainer(
                height: isVisibleSearch ? 0 : 40,
                padding: const EdgeInsets.only(left: 15, top: 10),
                duration: const Duration(milliseconds: 250),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(S.of(context).search,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
            Row(children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.search,
                        color: Colors.black45,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: textController,
                          focusNode: _focus,
                          onChanged: (text) {
                            if (_timer != null) {
                              _timer?.cancel();
                            }
                            _timer =
                                Timer(const Duration(milliseconds: 500), () {
                              if (mounted) {
                                setState(() {
                                  searchText = text;
                                });
                              }
                              Provider.of<BlogSearchModel>(context,
                                      listen: false)
                                  .searchBlogs(name: text);
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.secondary,
                            border: InputBorder.none,
                            hintText: S.of(context).searchForItems,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        width: (searchText.isEmpty) ? 0 : 50,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              searchText = '';
                              isVisibleSearch = false;
                            });
                            textController.text = '';
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Center(
                            child: Text(S.of(context).cancel,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
            Expanded(child: _renderSearchLayout()),
          ],
        ),
      ),
    );
  }
}
