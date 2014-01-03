library ompa_html;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:crypto/crypto.dart';

part 'src/auth.dart';
part 'src/panel.dart';
part 'src/panels.dart';
part 'src/note.dart';
part 'src/notes.dart';
part 'src/server.dart';

void main() {
  auth(document.body).then((key){
    var server;
    if(window.location.host == '127.0.0.1:3030'){
      server = new Server('http://127.0.0.1:8080/',key);
    }else{
      server = new Server('http://api.ompa.olem.org:8080/',key);
    }
    
    var panels = new Panels();
    var notes = new Notes(server, panels);
    document.body.append(panels.elem);
  });
}
