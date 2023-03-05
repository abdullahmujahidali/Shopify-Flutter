import 'package:flutter/material.dart';
import '../services/services.dart';

class CommentModel with ChangeNotifier {
  late List<Comment>? comments;
  Map<int, Comment> commentList = {};

  bool isLoading = true;
  late String message;
  final _service = Services();

  void getCommentsByPostId({postId}) async {
    try {
      comments = await _service.api.getCommentsByPostId(postId: postId);
      isLoading = false;
      if (comments == null) {
        throw Exception('Error when get comments');
      }

      for (var cmt in comments!) {
        commentList[cmt.id!] = cmt;
      }

      notifyListeners();
    } catch (err) {
      isLoading = false;
      message = err.toString();
      notifyListeners();
    }
  }
}

class Comment {
  int? id;
  int? postId;
  String? authorName;
  String? authorAvatarUrl;
  String? date;
  String? content;

  Comment.fromJson(Map parsedJson) {
    id = parsedJson['id'];
    postId = parsedJson['post'];
    authorName = parsedJson['author_name'];
    authorAvatarUrl = parsedJson['author_avatar_urls']['96'];
    date = parsedJson['date'];
    content = parsedJson['content']['rendered'];
  }

  Map<String, dynamic> toJson(Comment comment) {
    return {
      'id': comment.id,
      'post': comment.postId,
      'author_name': comment.authorName,
      'date': comment.date,
      'content': comment.content,
      'author_avatar_urls': comment.authorAvatarUrl,
    };
  }

  @override
  String toString() => 'Comment to String { id: $id  content: $content}';
}
