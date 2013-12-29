library ompa_html;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:crypto/crypto.dart';

part 'src/auth.dart';
part 'src/note.dart';
part 'src/notes.dart';
part 'src/server.dart';

void main() {
  auth(document.body).then((key){
    var server = new Server('http://127.0.0.1:8080/',key);
    
    var notes = new Notes(server);
    document.body.append(notes.elem);
  });
}
