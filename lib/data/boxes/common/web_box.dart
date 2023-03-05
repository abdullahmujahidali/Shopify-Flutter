part of '../../boxes.dart';

class WebBox implements Box {
  static final Map<dynamic, dynamic> _data = {};

  /// Not usable.
  @override
  Future<int> add(value) {
    return Future.value(0);
  }

  /// Not usable.
  @override
  Future<Iterable<int>> addAll(Iterable values) {
    return Future.value(const [0]);
  }

  @override
  Future<int> clear() {
    _data.clear();
    return Future.value(0);
  }

  /// Not usable.
  @override
  Future<void> close() {
    return Future.value();
  }

  /// Not usable.
  @override
  Future<void> compact() {
    return Future.value();
  }

  @override
  bool containsKey(key) {
    return _data.containsKey(key);
  }

  @override
  Future<void> delete(key) {
    _data.remove(key);
    return Future.value();
  }

  @override
  Future<void> deleteAll(Iterable keys) {
    keys.forEach(_data.remove);
    return Future.value();
  }

  @override
  Future<void> deleteAt(int index) {
    final key = keyAt(index);
    if (key != null) {
      _data.remove(key);
    }
    return Future.value();
  }

  /// Not usable.
  @override
  Future<void> deleteFromDisk() {
    return Future.value();
  }

  /// Not usable.
  @override
  Future<void> flush() {
    return Future.value();
  }

  @override
  dynamic get(key, {defaultValue}) {
    return _data[key] ?? defaultValue;
  }

  @override
  dynamic getAt(int index) {
    return _data.values.elementAt(index);
  }

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  /// Not usable.
  @override
  bool get isOpen => true;

  @override
  dynamic keyAt(int index) {
    return _data.keys.elementAt(index);
  }

  @override
  Iterable get keys => _data.keys;

  @override
  bool get lazy => false;

  @override
  int get length => _data.length;

  @override
  String get name => 'web';

  @override
  String? get path => null;

  @override
  Future<void> put(key, value) {
    _data[key] = value;
    return Future.value();
  }

  @override
  Future<void> putAll(Map entries) {
    _data.addAll(entries);
    return Future.value();
  }

  @override
  Future<void> putAt(int index, value) {
    final key = keyAt(index);
    if (key != null) {
      _data[key] = value;
    }
    return Future.value();
  }

  @override
  Map toMap() {
    return Map.from(_data);
  }

  @override
  Iterable get values => _data.values;

  /// Not usable.
  @override
  Iterable valuesBetween({startKey, endKey}) {
    return const [];
  }

  /// Not usable.
  @override
  Stream<BoxEvent> watch({key}) {
    return const Stream.empty();
  }
}
