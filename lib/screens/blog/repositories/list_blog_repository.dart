import '../../../models/entities/blog.dart';
import '../../../models/entities/paging_response.dart';
import '../../../services/paging/paging_repository.dart';

class ListBlogRepository extends PagingRepository<Blog> {
  @override
  Future<PagingResponse<Blog>>? Function(dynamic) get requestApi =>
      service.api.getBlogs;
}
