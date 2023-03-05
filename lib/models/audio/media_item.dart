class FluxMediaItem {
  /// A unique id.
  final String id;

  /// The title of this media item.
  final String title;

  /// The album this media item belongs to.
  final String? album;

  /// The artist of this media item.
  final String? artist;

  /// The genre of this media item.
  final String? genre;

  /// The duration of this media item.
  final Duration? duration;

  /// The artwork for this media item as a uri.
  final Uri? artUri;

  /// Whether this is playable (i.e. not a folder).
  final bool? playable;

  /// Override the default title for display purposes.
  final String? displayTitle;

  /// Override the default subtitle for display purposes.
  final String? displaySubtitle;

  /// Override the default description for display purposes.
  final String? displayDescription;

  /// A map of additional metadata for the media item.
  ///
  /// The values must be of type `int`, `String`, `bool` or `double`.
  final Map<String, dynamic>? extras;

  final String? urlSource;

  /// Creates a [FluxMediaItem].
  ///
  /// The [id] must be unique for each instance.
  const FluxMediaItem({
    required this.id,
    required this.title,
    this.urlSource,
    this.album,
    this.artist,
    this.genre,
    this.duration,
    this.artUri,
    this.playable = true,
    this.displayTitle,
    this.displaySubtitle,
    this.displayDescription,
    this.extras,
  });

  /// Creates a copy of this [FluxMediaItem] with with the given fields replaced by
  /// new values.
  MediaItemCopyWith get copyWith => _MediaItemCopyWith(this);

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is FluxMediaItem &&
      other.id == id;
}

/// The `copyWith` function type for [FluxMediaItem].
// ignore: one_member_abstracts
abstract class MediaItemCopyWith {
  /// Calls this function.
  FluxMediaItem call({
    String id,
    String title,
    String? album,
    String? artist,
    String? genre,
    Duration? duration,
    Uri? artUri,
    bool? playable,
    String? displayTitle,
    String? displaySubtitle,
    String? displayDescription,
    String? urlSource,
    Map<String, dynamic>? extras,
  });
}

/// The implementation of [FluxMediaItem]'s `copyWith` function allowing
/// parameters to be explicitly set to null.
class _MediaItemCopyWith extends MediaItemCopyWith {
  static const _fakeNull = Object();

  /// The [FluxMediaItem] object this function applies to.
  final FluxMediaItem value;

  _MediaItemCopyWith(this.value);

  @override
  FluxMediaItem call({
    Object? id = _fakeNull,
    Object? title = _fakeNull,
    Object? album = _fakeNull,
    Object? artist = _fakeNull,
    Object? genre = _fakeNull,
    Object? duration = _fakeNull,
    Object? artUri = _fakeNull,
    Object? playable = _fakeNull,
    Object? displayTitle = _fakeNull,
    Object? displaySubtitle = _fakeNull,
    Object? displayDescription = _fakeNull,
    Object? urlSource = _fakeNull,
    Object? extras = _fakeNull,
  }) =>
      FluxMediaItem(
        id: id == _fakeNull ? value.id : id as String,
        title: title == _fakeNull ? value.title : title as String,
        album: album == _fakeNull ? value.album : album as String?,
        artist: artist == _fakeNull ? value.artist : artist as String?,
        genre: genre == _fakeNull ? value.genre : genre as String?,
        duration:
            duration == _fakeNull ? value.duration : duration as Duration?,
        artUri: artUri == _fakeNull ? value.artUri : artUri as Uri?,
        playable: playable == _fakeNull ? value.playable : playable as bool?,
        displayTitle: displayTitle == _fakeNull
            ? value.displayTitle
            : displayTitle as String?,
        displaySubtitle: displaySubtitle == _fakeNull
            ? value.displaySubtitle
            : displaySubtitle as String?,
        displayDescription: displayDescription == _fakeNull
            ? value.displayDescription
            : displayDescription as String?,
        urlSource:
            urlSource == _fakeNull ? value.urlSource : urlSource as String,
        extras: extras == _fakeNull
            ? value.extras
            : extras as Map<String, dynamic>?,
      );
}
