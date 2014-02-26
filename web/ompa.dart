library ompa_html;

// Temporary fix the 3mb js size.
@MirrorsUsed(override: '*')
import 'dart:mirrors';

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:ompa/ompa.dart';

part 'src/auth_controller.dart';
part 'src/auth_service.dart';
part 'src/panel.dart';
part 'src/panels.dart';
part 'src/new_note_panel.dart';
part 'src/note_panel.dart';
part 'src/note_controller.dart';
part 'src/ompa_controller.dart';
part 'src/server.dart';
part 'src/success_controller.dart';
part 'src/success_panel.dart';
part 'src/tasks.dart';

class OmpaModule extends Module{
  OmpaModule(){
    type(AuthController);
    type(AuthService);
    type(OmpaController);
  }
}

main() => ngBootstrap(module: new OmpaModule());
