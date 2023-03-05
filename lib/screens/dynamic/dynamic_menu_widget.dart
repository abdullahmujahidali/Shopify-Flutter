import 'package:flutter/material.dart';
import '../../modules/dynamic_layout/config/app_config.dart';

class DynamicMenuWidget extends StatelessWidget {
  final List<TabBarMenuConfig> data;

  const DynamicMenuWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(
          left: 4,
          right: 4,
          bottom: 10,
        ),
        child: TabBar(
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          splashBorderRadius: BorderRadius.circular(6),
          indicatorColor: Theme.of(context).primaryColor,
          labelPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15,
          ),
          tabs: List.generate(
            data.length,
            (index) => Tab(
              child: Text(
                data[index].menuLabel == '' ? 'Shop' : data[index].menuLabel,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
