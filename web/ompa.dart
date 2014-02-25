library ompa_html;

// Temporary fix the 3mb js size.
@MirrorsUsed(override: '*')
import 'dart:mirrors';

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:ompa/ompa.dart';

part 'src/auth.dart';
part 'src/auth_controller.dart';
part 'src/auth_panel.dart';
part 'src/panel.dart';
part 'src/panels.dart';
part 'src/new_note_panel.dart';
part 'src/note_panel.dart';
part 'src/note_controller.dart';
part 'src/server.dart';
part 'src/success_controller.dart';
part 'src/success_panel.dart';
part 'src/tasks.dart';

void main() {
  var ompaModule = new Module();
  var authctrl = new AuthController();
  ompaModule.value(AuthController,authctrl);
  
  ngBootstrap(module: ompaModule);
  
  Panels panels = new Panels();
  document.body.append(panels.elem);
  auth(panels).then((auth){
    var server;
    if(window.location.host == '127.0.0.1:3030'){
      server = new Server('http://127.0.0.1:8080/',auth);
    }else{
      server = new Server('http://api.ompa.olem.org:8080/',auth);
    }
    var success = new SuccessController(server,panels);
    var note = new NoteController(server, panels);
    var tasks = new Tasks(document.body);
  });
}
