part of '../constants.dart';

Widget kCustomFooter(context) => CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(S.of(context).pullToLoadMore);
        } else if (mode == LoadStatus.loading) {
          body = kLoadingWidget(context);
        } else if (mode == LoadStatus.failed) {
          body = Text(S.of(context).loadFail);
        } else if (mode == LoadStatus.canLoading) {
          body = Text(S.of(context).releaseToLoadMore);
        } else {
          body = Text(S.of(context).noData);
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
