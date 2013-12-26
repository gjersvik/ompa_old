library ompa_html;

import 'dart:html';

part 'src/note.dart';

void main() {
  document.body.append(new Note('SuperNote').elem);
}
