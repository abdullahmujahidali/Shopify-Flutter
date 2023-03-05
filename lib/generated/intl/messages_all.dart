// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_ar.dart' deferred as messages_ar;
import 'messages_az.dart' deferred as messages_az;
import 'messages_bn.dart' deferred as messages_bn;
import 'messages_bs.dart' deferred as messages_bs;
import 'messages_cs.dart' deferred as messages_cs;
import 'messages_da.dart' deferred as messages_da;
import 'messages_de.dart' deferred as messages_de;
import 'messages_el.dart' deferred as messages_el;
import 'messages_en.dart' deferred as messages_en;
import 'messages_es.dart' deferred as messages_es;
import 'messages_fa.dart' deferred as messages_fa;
import 'messages_fi.dart' deferred as messages_fi;
import 'messages_fr.dart' deferred as messages_fr;
import 'messages_he.dart' deferred as messages_he;
import 'messages_hi.dart' deferred as messages_hi;
import 'messages_hu.dart' deferred as messages_hu;
import 'messages_id.dart' deferred as messages_id;
import 'messages_it.dart' deferred as messages_it;
import 'messages_ja.dart' deferred as messages_ja;
import 'messages_km.dart' deferred as messages_km;
import 'messages_kn.dart' deferred as messages_kn;
import 'messages_ko.dart' deferred as messages_ko;
import 'messages_ku.dart' deferred as messages_ku;
import 'messages_lo.dart' deferred as messages_lo;
import 'messages_mr.dart' deferred as messages_mr;
import 'messages_ms.dart' deferred as messages_ms;
import 'messages_my.dart' deferred as messages_my;
import 'messages_nl.dart' deferred as messages_nl;
import 'messages_pl.dart' deferred as messages_pl;
import 'messages_pt.dart' deferred as messages_pt;
import 'messages_ro.dart' deferred as messages_ro;
import 'messages_ru.dart' deferred as messages_ru;
import 'messages_sk.dart' deferred as messages_sk;
import 'messages_sq.dart' deferred as messages_sq;
import 'messages_sr.dart' deferred as messages_sr;
import 'messages_sv.dart' deferred as messages_sv;
import 'messages_sw.dart' deferred as messages_sw;
import 'messages_ta.dart' deferred as messages_ta;
import 'messages_th.dart' deferred as messages_th;
import 'messages_ti.dart' deferred as messages_ti;
import 'messages_tr.dart' deferred as messages_tr;
import 'messages_uk.dart' deferred as messages_uk;
import 'messages_ur.dart' deferred as messages_ur;
import 'messages_uz.dart' deferred as messages_uz;
import 'messages_vi.dart' deferred as messages_vi;
import 'messages_zh.dart' deferred as messages_zh;
import 'messages_zh_CN.dart' deferred as messages_zh_cn;
import 'messages_zh_TW.dart' deferred as messages_zh_tw;

typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
  'ar': messages_ar.loadLibrary,
  'az': messages_az.loadLibrary,
  'bn': messages_bn.loadLibrary,
  'bs': messages_bs.loadLibrary,
  'cs': messages_cs.loadLibrary,
  'da': messages_da.loadLibrary,
  'de': messages_de.loadLibrary,
  'el': messages_el.loadLibrary,
  'en': messages_en.loadLibrary,
  'es': messages_es.loadLibrary,
  'fa': messages_fa.loadLibrary,
  'fi': messages_fi.loadLibrary,
  'fr': messages_fr.loadLibrary,
  'he': messages_he.loadLibrary,
  'hi': messages_hi.loadLibrary,
  'hu': messages_hu.loadLibrary,
  'id': messages_id.loadLibrary,
  'it': messages_it.loadLibrary,
  'ja': messages_ja.loadLibrary,
  'km': messages_km.loadLibrary,
  'kn': messages_kn.loadLibrary,
  'ko': messages_ko.loadLibrary,
  'ku': messages_ku.loadLibrary,
  'lo': messages_lo.loadLibrary,
  'mr': messages_mr.loadLibrary,
  'ms': messages_ms.loadLibrary,
  'my': messages_my.loadLibrary,
  'nl': messages_nl.loadLibrary,
  'pl': messages_pl.loadLibrary,
  'pt': messages_pt.loadLibrary,
  'ro': messages_ro.loadLibrary,
  'ru': messages_ru.loadLibrary,
  'sk': messages_sk.loadLibrary,
  'sq': messages_sq.loadLibrary,
  'sr': messages_sr.loadLibrary,
  'sv': messages_sv.loadLibrary,
  'sw': messages_sw.loadLibrary,
  'ta': messages_ta.loadLibrary,
  'th': messages_th.loadLibrary,
  'ti': messages_ti.loadLibrary,
  'tr': messages_tr.loadLibrary,
  'uk': messages_uk.loadLibrary,
  'ur': messages_ur.loadLibrary,
  'uz': messages_uz.loadLibrary,
  'vi': messages_vi.loadLibrary,
  'zh': messages_zh.loadLibrary,
  'zh_CN': messages_zh_cn.loadLibrary,
  'zh_TW': messages_zh_tw.loadLibrary,
};

MessageLookupByLibrary? _findExact(String localeName) {
  switch (localeName) {
    case 'ar':
      return messages_ar.messages;
    case 'az':
      return messages_az.messages;
    case 'bn':
      return messages_bn.messages;
    case 'bs':
      return messages_bs.messages;
    case 'cs':
      return messages_cs.messages;
    case 'da':
      return messages_da.messages;
    case 'de':
      return messages_de.messages;
    case 'el':
      return messages_el.messages;
    case 'en':
      return messages_en.messages;
    case 'es':
      return messages_es.messages;
    case 'fa':
      return messages_fa.messages;
    case 'fi':
      return messages_fi.messages;
    case 'fr':
      return messages_fr.messages;
    case 'he':
      return messages_he.messages;
    case 'hi':
      return messages_hi.messages;
    case 'hu':
      return messages_hu.messages;
    case 'id':
      return messages_id.messages;
    case 'it':
      return messages_it.messages;
    case 'ja':
      return messages_ja.messages;
    case 'km':
      return messages_km.messages;
    case 'kn':
      return messages_kn.messages;
    case 'ko':
      return messages_ko.messages;
    case 'ku':
      return messages_ku.messages;
    case 'lo':
      return messages_lo.messages;
    case 'mr':
      return messages_mr.messages;
    case 'ms':
      return messages_ms.messages;
    case 'my':
      return messages_my.messages;
    case 'nl':
      return messages_nl.messages;
    case 'pl':
      return messages_pl.messages;
    case 'pt':
      return messages_pt.messages;
    case 'ro':
      return messages_ro.messages;
    case 'ru':
      return messages_ru.messages;
    case 'sk':
      return messages_sk.messages;
    case 'sq':
      return messages_sq.messages;
    case 'sr':
      return messages_sr.messages;
    case 'sv':
      return messages_sv.messages;
    case 'sw':
      return messages_sw.messages;
    case 'ta':
      return messages_ta.messages;
    case 'th':
      return messages_th.messages;
    case 'ti':
      return messages_ti.messages;
    case 'tr':
      return messages_tr.messages;
    case 'uk':
      return messages_uk.messages;
    case 'ur':
      return messages_ur.messages;
    case 'uz':
      return messages_uz.messages;
    case 'vi':
      return messages_vi.messages;
    case 'zh':
      return messages_zh.messages;
    case 'zh_CN':
      return messages_zh_cn.messages;
    case 'zh_TW':
      return messages_zh_tw.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName, (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? new Future.value(false) : lib());
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale =
      Intl.verifiedLocale(locale, _messagesExistFor, onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
