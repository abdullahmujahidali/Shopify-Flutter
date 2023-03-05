import 'dart:core';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../models/app_model.dart';
import '../../../../../models/category/category_model.dart';
import '../../../../../models/user_model.dart';
import '../../../../../services/dependency_injection.dart';
import '../../../../../widgets/common/login_animation.dart';
import '../../../services/wordpress_service.dart';

class NewPostScreen extends StatefulWidget {
  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen>
    with TickerProviderStateMixin {
  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final categoriesTextController = TextEditingController();
  final statusTextController = TextEditingController();
  final _service = injector<WordPressService>();
  String? content;
  String? title;
  int? category;
  String? status;
  File? _image;
  bool isLoading = false;
  late AnimationController _submitButtonController;

  @override
  void dispose() {
    titleTextController.dispose();
    contentTextController.dispose();
    categoriesTextController.dispose();
    statusTextController.dispose();
    _submitButtonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _submitButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  Future getImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _submitButtonController.forward();
      // ignore: empty_catches
    } on TickerCanceled {}
  }

  Future _stopAnimation() async {
    try {
      await _submitButtonController.reverse();
      setState(() {
        isLoading = false;
      });
      // ignore: empty_catches
    } on TickerCanceled {}
  }

  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    final snackBar = SnackBar(
      content: Text('Warning: $message'),
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // ignore: always_declare_return_types
  _showSnackBar(String title, context) {
    var snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var categories =
        Provider.of<CategoryModel>(context, listen: false).categories;
    final locale = Provider.of<AppModel>(context, listen: false).langCode;
    final isRightToLeftDirectionDetected = locale == 'ar' ? true : false;
    var user = Provider.of<UserModel>(context, listen: false).user;

    // ignore: always_declare_return_types
    submitPost(context) {
      if (title == null ||
          content == null ||
          category == null ||
          _image == null) {
        _showSnackBar(S.of(context).pleaseInput, context);
      } else {
        _playAnimation();
        _service.createBlog(
            file: _image!,
            cookie:
                Provider.of<UserModel>(context, listen: false).user?.cookie ??
                    '',
            data: {
              'title': titleTextController.text,
              'content': contentTextController.text,
              'author': user!.id,
              'date': DateTime.now().toIso8601String(),
              'status': 'draft',
              'categories': category,
            }).whenComplete(() {
          _showSnackBar(S.of(context).postSuccessfully, context);
          _stopAnimation().whenComplete(() {
            Navigator.pop(context);
          });
        }).catchError((err) {
          _stopAnimation();
          _failMessage('${S.of(context).postFail} $err', context);
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).addANewPost,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Text(
                  S.of(context).postTitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      textDirection: isRightToLeftDirectionDetected
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      autofocus: true,
                      cursorColor: Theme.of(context).focusColor,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.0,
                            height: 1.4,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      controller: titleTextController,
                      onChanged: (text) {
                        setState(() {
                          title = text;
                        });
                      }),
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).postContent,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  child: TextField(
                    maxLines: 50,
                    minLines: 6,
                    textAlign: TextAlign.justify,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    textDirection: isRightToLeftDirectionDetected
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    autofocus: true,
                    cursorColor: Theme.of(context).focusColor,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14.0,
                          height: 1.4,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    controller: contentTextController,
                    onChanged: (text) {
                      setState(() {
                        content = text;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).category,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                if (categories != null && categories.isNotEmpty)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: DropdownButton<String>(
                      value: category?.toString(),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      onChanged: (text) {
                        setState(() {
                          category = int.parse(text!);
                        });
                      },
                      underline: const SizedBox(),
                      items: List.generate(categories.length, (index) {
                        return DropdownMenuItem(
                          value: categories[index].id,
                          child: Text(categories[index].name.toString()),
                        );
                      }),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).postImageFeature,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: _image == null
                      ? Container(
                          constraints: const BoxConstraints(
                            minHeight: 80,
                            maxHeight: 100,
                          ),
                          height: 50.0,
                          child: RawMaterialButton(
                            onPressed: getImage,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            elevation: 0.1,
                            fillColor: Theme.of(context).primaryColorLight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add_a_photo,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Image.file(
                          _image!,
                          width: MediaQuery.of(context).size.width - 40,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Builder(
                    builder: (context) => StaggerAnimation(
                      buttonController: _submitButtonController,
                      titleButton: S.of(context).submit,
                      onTap: () {
                        if (!isLoading) {
                          submitPost(context);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
