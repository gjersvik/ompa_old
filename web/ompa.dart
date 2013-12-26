library ompa_html;

import 'dart:html';

part 'src/note.dart';
part 'src/notes.dart';

void main() {
  var notes = new Notes();
  document.body.append(notes.elem);
  
  notes.add(new Note('Test Note'));
  notes.add(new Note('SuperNote'));
}
