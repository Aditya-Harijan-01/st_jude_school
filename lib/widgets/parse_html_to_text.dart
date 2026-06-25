import 'package:html/parser.dart' as htmlparser;

String parseHtmlToText(String? htmlString) {
  final document = htmlparser.parse(htmlString);
  return document.body?.text ?? '';
}