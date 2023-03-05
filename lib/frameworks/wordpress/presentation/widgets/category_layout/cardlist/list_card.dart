import 'package:flutter/material.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../models/entities/index.dart';
import '../../../../../../routes/flux_navigate.dart';
import '../../../../../../screens/blog/views/blog_detail_screen.dart';
import '../../../../../../widgets/blog/blog_card_view.dart';

class ListCard extends StatelessWidget {
  final List<Blog> data;
  final String id;
  final double width;

  const ListCard({required this.data, required this.id, required this.width});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: width * 0.4 + 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            key: ObjectKey(id),
            itemBuilder: (context, index) {
              return BlogCard(
                item: data[index],
                width: constraints.maxWidth * 0.5,
                onTap: () => FluxNavigate.pushNamed(
                  RouteList.detailBlog,
                  arguments: BlogDetailArguments(
                    blog: data[index],
                    listBlog: data,
                  ),
                ),
              );
            },
            itemCount: data.length,
          ),
        );
      },
    );
  }
}
