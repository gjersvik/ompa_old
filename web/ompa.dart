library ompa_html;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

part 'src/note.dart';
part 'src/notes.dart';
part 'src/server.dart';

void main() {
  var server = new Server('http://127.0.0.1:8080/');
  
  var notes = new Notes(server);
  document.body.append(notes.elem);
}
