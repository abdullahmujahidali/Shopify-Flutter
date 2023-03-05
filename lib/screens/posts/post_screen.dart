import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show Blog;
import '../../services/index.dart';
import '../../widgets/html/index.dart';
import '../common/app_bar_mixin.dart';

class PostScreen extends StatefulWidget {
  final int? pageId;
  final String? pageTitle;
  final bool isLocatedInTabbar;

  const PostScreen({
    this.pageId,
    this.pageTitle,
    this.isLocatedInTabbar = false,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with AppBarMixin {
  final Services _service = Services();
  Future<Blog?>? _getPage;
  final _memoizer = AsyncMemoizer<Blog?>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    screenScrollController = _scrollController;
    // only create the future once
    Future.delayed(Duration.zero, () {
      setState(() {
        _getPage = getPageById(widget.pageId);
      });
    });
    super.initState();
  }

  Future<Blog?> getPageById(context) => _memoizer.runOnce(
        () => _service.api.getPageById(
          widget.pageId,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: RouteList.postScreen,
      backgroundColor: Theme.of(context).colorScheme.background,
      secondAppBar: AppBar(
        title: Text(
          widget.pageTitle.toString(),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: widget.isLocatedInTabbar
            ? const SizedBox()
            : Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
      ),
      child: FutureBuilder<Blog?>(
        future: _getPage,
        builder: (BuildContext context, AsyncSnapshot<Blog?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Scaffold(
                body: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            case ConnectionState.done:
            default:
              if (snapshot.hasError || snapshot.data == null) {
                return Material(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          S.of(context).noPost,
                        ),
                        widget.isLocatedInTabbar
                            ? const SizedBox()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(S.of(context).goBackHomePage),
                              ),
                      ],
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 0.0,
                ),
                child: PostView(
                  item: snapshot.data,
                  scrollController: _scrollController,
                ),
              );
          }
        },
      ),
    );
  }
}

class PostView extends StatelessWidget {
  final Blog? item;
  final ScrollController? scrollController;

  const PostView({
    this.item,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      child: HtmlWidget(
        item!.content,
        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              height: 1.4,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
