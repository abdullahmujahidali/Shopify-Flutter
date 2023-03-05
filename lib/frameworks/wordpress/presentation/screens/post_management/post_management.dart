import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/constants.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../models/entities/blog.dart';
import '../../../../../models/user_model.dart';
import '../../../../../screens/base_screen.dart';
import '../../../../../services/dependency_injection.dart';
import '../../../services/wordpress_service.dart';
import 'new_post.dart';
import 'post_view.dart';

class PostManagementScreen extends StatefulWidget {
  @override
  BaseScreen<PostManagementScreen> createState() =>
      _PostManagementScreenState();
}

class _PostManagementScreenState extends BaseScreen<PostManagementScreen> {
  final _service = injector<WordPressService>();
  late Future<List<Blog>?> _getBlogsByUserId;
  final _memoizer = AsyncMemoizer<List<Blog>?>();
  bool isAbleToPostManagement = false;

  @override
  void afterFirstLayout(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false).user;
    for (var legitRole in addPostAccessibleRoles) {
      if (user!.role == legitRole) {
        setState(() {
          isAbleToPostManagement = true;
        });
      }
    }
    super.afterFirstLayout(context);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserModel>(context, listen: false).user;
    Future<List<Blog>?> getBlogsByUserId(context) => _memoizer.runOnce(
          () => _service.getBlogsByUserId(user!.id!),
        );

    // only create the future once
    Future.delayed(Duration.zero, () {
      setState(() {
        _getBlogsByUserId = getBlogsByUserId(context);
      });
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          S.of(context).postManagement,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: isAbleToPostManagement
            ? FutureBuilder<List<Blog>?>(
                future: _getBlogsByUserId,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Blog>?> snapshot) {
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
                            alignment: Alignment.center,
                            color: Theme.of(context).colorScheme.background,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 100,
                                ),
                                Image.network(
                                  'https://i.pinimg.com/736x/cf/e2/b3/cfe2b376e7c397e935288ebadee60370.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                ),
                                const Text(
                                  'Error on getting post!',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextButton(
                                  // color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  },
                                  child: Text(
                                    'Go back to home page',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.network(
                                  'https://i.pinimg.com/736x/cf/e2/b3/cfe2b376e7c397e935288ebadee60370.jpg',
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                ),
                                Text(
                                  'You have no posts',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 20.0,
                                        height: 1.4,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Material(
                        color: Theme.of(context).colorScheme.background,
                        elevation: 0,
                        child: Scrollbar(
                          controller: ScrollController(),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => PostView(
                              blogs: snapshot.data,
                              index: index,
                            ),
                          ),
                        ),
                      );
                  }
                },
              )
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        'https://i.pinimg.com/736x/cf/e2/b3/cfe2b376e7c397e935288ebadee60370.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                      ),
                      Text(
                        "You don't have permission to create Post",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 20.0,
                              height: 1.4,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: isAbleToPostManagement
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewPostScreen(),
                ));
              },
              icon: Icon(
                Icons.note_add,
                color: Theme.of(context).primaryColorLight,
              ),
              label: Text(
                S.of(context).addNewPost,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              elevation: 5.0,
              backgroundColor: Theme.of(context).primaryColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
              heroTag: 'addNewBlog',
            )
          : const SizedBox(),
    );
  }
}
