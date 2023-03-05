import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as core;
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/index.dart';
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../../widgets/html/index.dart';
import 'blog_heart_button.dart';
import 'blog_share_button.dart';
import 'text_adjustment_button.dart';

mixin DetailedBlogMixin {
  Widget renderBlogFunctionButtons(Blog blog, BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _renderTextAdjustmentButton(),
          _renderShareButton(blog),
          _renderHeartButton(blog, context),
        ],
      );

  Widget renderRelatedBlog(dynamic blogId) =>
      Services().widget.renderRelatedBlog(
            categoryId: blogId,
            type: kAdvanceConfig.detailedBlogLayout,
          );

  Widget renderCommentLayout(dynamic blogId) =>
      kBlogDetail['showComment'] ?? false
          ? Services()
              .widget
              .renderCommentLayout(blogId, kAdvanceConfig.detailedBlogLayout)
          : const SizedBox();

  Widget renderCommentInput(dynamic blogId) => kBlogDetail['showComment']
      ? Services().widget.renderCommentField(blogId)
      : const SizedBox();

  Widget renderInstagram(instagramLink, BuildContext context) {
    if (isAndroid) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: webview.WebView(
          initialUrl: instagramLink,
          javascriptMode: webview.JavascriptMode.unrestricted,
          debuggingEnabled: true,
          allowsInlineMediaPlayback: true,
          // '<iframe src="$instagramLink" width="100%" height="100%"></iframe>',
          // factoryBuilder: () => InstagramWidgetFactory(),
        ),
      );
    }

    /// ios: using default webview from html render
    return core.HtmlWidget(
      '<iframe src="$instagramLink"></iframe>',
      factoryBuilder: InstagramWidgetFactory.new,
    );
  }

  Widget renderBlogContentWithTextEnhancement(Blog blog) =>
      Consumer<TextStyleModel>(builder: (context, textStyleModel, child) {
        var htmlWidget = HtmlWidget(
          blog.content,
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: textStyleModel.contentTextSize,
              height: 1.4,
              color: kAdvanceConfig.detailedBlogLayout ==
                      kBlogLayout.fullSizeImageType
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary),
          customWidgetBuilder: (element) {
            if (element.attributes['data-instgrm-permalink'] != null) {
              return renderInstagram(
                  Videos.getInstagramLink(
                      element.attributes['data-instgrm-permalink']),
                  context);
            }
            return null;
          },
          // factoryBuilder: () => InstagramWidgetFactory(),
        );

        // support http://instagram.com/p/CTFQP8kq-8W
        // final instagramLink = Videos.getInstagramLink(blog.content);
        // if (instagramLink.isNotEmpty) {
        //   return Column(
        //     children: [
        //       htmlWidget,
        //       renderInstagram(instagramLink, context),
        //     ],
        //   );
        // }
        return htmlWidget;
      });

  Widget _renderHeartButton(Blog blog, BuildContext context) =>
      (kBlogDetail['showHeart'] && ServerConfig().isWordPress)
          ? Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: BlogHeartButton(
                blog: blog,
                size: 18,
                isTransparent: true,
              ),
            )
          : const SizedBox();

  Widget _renderShareButton(Blog blog) => kBlogDetail['showSharing'] ?? true
      ? ShareButton(blog: blog)
      : const SizedBox();

  Widget _renderTextAdjustmentButton() =>
      kBlogDetail['showTextAdjustment'] ?? true
          ? const TextAdjustmentButton(18.0)
          : const SizedBox();

  Widget renderAudioWidget(Blog blogData, BuildContext context) {
    if (blogData.audioUrls.isNotEmpty && kBlogDetail['enableAudioSupport']) {
      return Services().getAudioBlogCard(
        blogData,
        playItem: (FluxMediaItem mediaItem) =>
            Services().playMediaItem(context, mediaItem),
        addItem: (FluxMediaItem mediaItem) =>
            Services().addMediaItemToPlaylist(context, mediaItem),
        addAll: (Blog blog) => Services().addBlogAudioToPlaylist(context, blog),
      );
    }
    return const SizedBox();
  }
}

class InstagramWidgetFactory extends core.WidgetFactory with WebViewFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
}
