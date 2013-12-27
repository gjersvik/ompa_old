library ompa_html;

import 'dart:async';
import 'dart:html';

part 'src/note.dart';
part 'src/notes.dart';
part 'src/server.dart';

void main() {
  var server = new Server('http://127.0.0.1:8080/');
  
  var notes = new Notes();
  document.body.append(notes.elem);
  
  notes.add(new Note('Test Note', server));
  notes.add(new Note('SuperNote', server));
}
