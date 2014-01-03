library ompa_html;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:crypto/crypto.dart';

part 'src/auth.dart';
part 'src/auth_panel.dart';
part 'src/panel.dart';
part 'src/panels.dart';
part 'src/note.dart';
part 'src/note_controller.dart';
part 'src/server.dart';

void main() {
  Panels panels = new Panels();
  document.body.append(panels.elem);
  auth(panels).then((key){
    var server;
    if(window.location.host == '127.0.0.1:3030'){
      server = new Server('http://127.0.0.1:8080/',key);
    }else{
      server = new Server('http://api.ompa.olem.org:8080/',key);
    }
    
    var note = new NoteController(server, panels);
  });
}
