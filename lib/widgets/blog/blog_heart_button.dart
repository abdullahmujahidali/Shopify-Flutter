import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/blog_wish_list_model.dart';
import '../../models/entities/blog.dart';

class BlogHeartButton extends StatefulWidget {
  final Blog blog;
  final double size;
  final type;
  final isTransparent;

  const BlogHeartButton({
    required this.blog,
    this.size = 16,
    this.type = kHeartButtonType.squareType,
    this.isTransparent = false,
  });

  @override
  State<BlogHeartButton> createState() => _BlogHeartButtonState();
}

class _BlogHeartButtonState extends State<BlogHeartButton> {
  @override
  Widget build(BuildContext context) {
    final isSquareType = widget.type == kHeartButtonType.squareType;
    return ListenableProvider.value(
      value: Provider.of<BlogWishListModel>(context, listen: true),
      child: Consumer<BlogWishListModel>(
        builder: (context, model, child) {
          var wishlist = model.getWishList();
          final isExist = wishlist.any((item) => item.id == widget.blog.id);
          if (!isExist) {
            return isSquareType
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: widget.isTransparent
                        ? 20 * (widget.size / 19)
                        : 20 * (widget.size / 15),
                    width: widget.isTransparent
                        ? 20 * (widget.size / 19)
                        : 20 * (widget.size / 15),
                    decoration: BoxDecoration(
                      color: widget.isTransparent
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.center,
                      onPressed: () {
                        Provider.of<BlogWishListModel>(context, listen: false)
                            .addToWishlist(widget.blog);
                      },
                      icon: Icon(
                        CupertinoIcons.heart,
                        color: Theme.of(context).colorScheme.secondary,
                        size: widget.size,
                      ),
                    ),
                  )
                : AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: widget.isTransparent
                        ? widget.size + 17
                        : widget.size + 10,
                    width: widget.isTransparent
                        ? widget.size + 17
                        : widget.size + 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                      borderRadius: widget.isTransparent
                          ? const BorderRadius.all(
                              Radius.circular(25),
                            )
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(15)),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.center,
                      onPressed: () {
                        Provider.of<BlogWishListModel>(context, listen: false)
                            .addToWishlist(widget.blog);
                      },
                      icon: Icon(
                        CupertinoIcons.heart_fill,
                        color: Theme.of(context).colorScheme.secondary,
                        size: widget.size,
                      ),
                    ),
                  );
          }

          return isSquareType
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: widget.isTransparent
                      ? 30 * (widget.size / 19)
                      : 30 * (widget.size / 15),
                  width: widget.isTransparent
                      ? 30 * (widget.size / 19)
                      : 30 * (widget.size / 15),
                  decoration: BoxDecoration(
                    color: widget.isTransparent
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.center,
                      onPressed: () {
                        Provider.of<BlogWishListModel>(context, listen: false)
                            .removeToWishlist(widget.blog);
                      },
                      icon: Icon(
                        CupertinoIcons.heart_fill,
                        color: kRedColorHeart.withOpacity(0.7),
                        size: widget.size,
                      )),
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height:
                      widget.isTransparent ? widget.size + 17 : widget.size + 5,
                  width:
                      widget.isTransparent ? widget.size + 17 : widget.size + 5,
                  decoration: BoxDecoration(
                    color: widget.isTransparent
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    alignment: widget.isTransparent
                        ? Alignment.center
                        : Alignment.topRight,
                    onPressed: () {
                      Provider.of<BlogWishListModel>(context, listen: false)
                          .removeToWishlist(widget.blog);
                    },
                    icon: Icon(
                      CupertinoIcons.heart_fill,
                      color: kRedColorHeart.withOpacity(0.7),
                      size: widget.isTransparent
                          ? widget.size * 1.3
                          : widget.size,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
