import 'package:html_unescape/html_unescape.dart';

class HtmlUtils {
  static final HtmlUnescape _unescape = HtmlUnescape();

  static String stripHtml(String input) {
    final text = input
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\\s+'), ' ')
        .trim();
    return _unescape.convert(text);
  }
}
