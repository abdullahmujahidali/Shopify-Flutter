import 'package:flutter/material.dart';

import '../../../models/entities/index.dart';
import '../../../widgets/common/flux_image.dart';

class CategoryColumnItem extends StatelessWidget {
  final Category category;

  const CategoryColumnItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        LayoutBuilder(builder: (context, constraints) {
          return FluxImage(
            imageUrl: category.image!,
            fit: BoxFit.cover,
            width: constraints.maxWidth,
          );
        }),
        Container(
          color: const Color.fromRGBO(0, 0, 0, 0.4),
          child: Center(
            child: Text(
              category.name!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
