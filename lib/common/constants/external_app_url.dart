part of '../constants.dart';

/// When opening a URL that includes these sites, it will open the external app instead of the webview.
const kExternalAppURLs = [
  'wa.me', // Whatsapp
  'm.me', // Messenger
  'ig.me', // Instagram
  'instagram.com', // Instagram
  'twitter.com', // Twitter
  'facebook.com', // Facebook
  'youtube.com', // Youbute
  'youtu.be', // Youbute
  't.me', // Telegram
  'play.google.com', // Google play
  'apps.apple.com', // App store
];

/// When opening a URL that start with these schemas, it will open the non-browser external app instead of the webview or browser.
/// Also please check all queries in the files [AndroidManifest.xml] and [Info.plist] if you use `canLaunchUrl` function
const kExternalNonBrowserAppURLs = [
  'tel:', // Phone call
  'sms:', // Send SMS
  'smsto:', // Send SMS
  'mailto:', // Send mail
  'skype:', // Skype
  'intent://', // Need to repace with scheme in the url
  'whatsapp://', // Whatsapp
  'instagram://', // Instagram
  'instagram-stories://', // Instagram story
  'twitter://', // Twitter
  'fb://', // Facebook
  'tg://', // Telegram
  'comgooglemaps://', // Google Maps
  'comgooglemapsurl://', // Google Maps URL
];
