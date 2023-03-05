import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    show InAppWebView, InAppWebViewController, URLRequest;

import '../../../common/constants.dart';
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/index.dart' hide WebView;
import '../../tiktok/index.dart';
import '../config/tiktok_videos_config.dart';
import 'tiktok_videos_view.dart';

class TikTokVideos extends StatefulWidget {
  final TikTokVideosConfig config;

  const TikTokVideos({required this.config, Key? key}) : super(key: key);

  @override
  State<TikTokVideos> createState() => _StateTikTokVideos();
}

class _StateTikTokVideos extends State<TikTokVideos> {
  final TikTokService _service = TikTokService();

  final List<TikTokVideoInfo> videos = [];

  InAppWebViewController? _controller;

  TikTokVideosConfig get config => widget.config;

  bool _isLoading = true;

  bool _failed = false;

  int _requestedCount = 0;

  void loadInit() async {
    await _service.init(
      config.username,
      config.uid,
      config.secUid,
      config.avatarUrl,
    );
    final url = _service.getRequestUrl();
    if (url.isEmpty) {
      _failed = true;
      await _controller?.loadUrl(
        urlRequest: URLRequest(
          url: _service.getUserRequestUrl().toUri(),
        ),
      );
    } else {
      await postInit();
    }
  }

  Future<void> postInit() async {
    final url = _service.getRequestUrl();
    if (url.isEmpty) {
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    await _controller?.loadUrl(
      urlRequest: URLRequest(
        url: url.toUri(),
      ),
    );
  }

  @override
  void didUpdateWidget(TikTokVideos oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (config != oldWidget.config) {
      loadInit();
    }
  }

  Future<void> loadVideos(String data) async {
    videos.clear();
    videos.addAll(await _service.parseVideoInfo(response: data));
    _isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.0,
          child: SizedBox(
            // 0-sized webview never loads on Android.
            height: 1,
            width: 1,
            child: InAppWebView(
              onWebViewCreated: (_) {
                if (_controller == null) {
                  _controller = _;
                  loadInit();
                  return;
                }
                _controller = _;
              },
              onLoadStop: (_, __) async {
                if (_failed) {
                  if (_requestedCount >= 20) {
                    final data = await _controller?.getBodyText();
                    if (data?.isEmpty ?? true) {
                      return;
                    }
                    _failed = false;
                    await _service.reInit('$data');
                    await postInit();
                  } else {
                    await _controller?.loadUrl(
                      urlRequest: URLRequest(
                        url: _service.getUserRequestUrl().toUri(),
                      ),
                    );
                    _requestedCount++;
                  }
                  return;
                }

                final data = await _controller?.getBodyText();
                if (data?.isEmpty ?? true) {
                  return;
                }
                await loadVideos(data ?? '');
              },
            ),
          ),
        ),
        if (_isLoading || (!_isLoading && videos.isNotEmpty))
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: widget.config.itemHeight.toDouble(),
              margin: EdgeInsets.only(
                left: widget.config.marginLeft.toDouble(),
                right: widget.config.marginRight.toDouble(),
                top: widget.config.marginTop.toDouble(),
                bottom: widget.config.marginBottom.toDouble(),
              ),
              child: Row(
                children: List.generate(
                  _isLoading ? config.limit : videos.length,
                  (index) => TikTokVideoItem(
                    item: _isLoading ? TikTokVideoInfo() : videos[index],
                    config: config,
                    onTap: _isLoading
                        ? null
                        : () => FluxNavigate.push(
                              MaterialPageRoute(
                                builder: (context) => TikTokVideosView(
                                  config: config,
                                  items: videos,
                                  position: index,
                                ),
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class TikTokVideoItem extends StatelessWidget {
  final TikTokVideoInfo item;
  final Function()? onTap;
  final TikTokVideosConfig config;

  const TikTokVideoItem({
    required this.item,
    this.onTap,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = config.itemHeight.toDouble();
    final imageWidth = config.itemWidth.toDouble();
    return Padding(
      padding: EdgeInsets.only(right: config.itemSpacing.toDouble()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(config.itemBorderRadius.toDouble()),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              if (item.videoThumbnail.isNotEmpty)
                FluxImage(
                  imageUrl: item.videoThumbnail,
                  height: imageHeight,
                  width: imageWidth,
                  fit: BoxFit.fitHeight,
                ),
              Container(
                height: imageHeight,
                width: imageWidth,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
              if (item.authorAvatar.isNotEmpty && !config.hideAvatar)
                Container(
                  margin: const EdgeInsets.only(left: 2, top: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: FluxImage(
                        imageUrl: item.authorAvatar,
                      ),
                    ),
                  ),
                ),
              if (item.desc != null &&
                  '${item.desc}'.isNotEmpty &&
                  !config.hideCaption)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: imageWidth,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      item.desc ?? '',
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

extension on InAppWebViewController {
  Future<String?> getBodyText() async {
    String? html;

    html = await evaluateJavascript(source: 'window.document.body.innerText;');
    if (html != null && html.isNotEmpty) return html;
    return '';
  }
}
