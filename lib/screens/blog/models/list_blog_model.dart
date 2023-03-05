import '../../../models/entities/blog.dart';

import '../../../models/paging_data_provider.dart';
import '../repositories/list_blog_repository.dart';

export '../../../models/entities/blog.dart';

class ListBlogModel extends PagingDataProvider<Blog> {
  ListBlogModel() : super(dataRepo: ListBlogRepository());

  List<Blog>? get blogs => data;

  Future<void> getBlogs() => getData();

  Future<void> refreshBlogs() => refresh();
}
