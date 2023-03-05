import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';

class VideoLayout extends StatelessWidget {
  final config;

  ///  Using url or embed to display the video
  ///  "url": "https://instagram.com/p/CTFQP8kq-8W/embed",
  //   "embed": "<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/sYnHhnS5WnQ\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>",
  //   "layout": "video"

  const VideoLayout({this.config, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (config['embed'] != null) {
      return HtmlWidget(
        config['embed'].toString(),
        factoryBuilder: VideoWidgetFactory.new,
      );
    }

    return HtmlWidget(
      '<iframe src="${config['url']}"></iframe>',
      factoryBuilder: VideoWidgetFactory.new,
    );
  }
}

class VideoWidgetFactory extends WidgetFactory with WebViewFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
}
