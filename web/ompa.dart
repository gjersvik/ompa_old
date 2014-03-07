library ompa_html;

// Temporary fix the 3mb js size.
//@MirrorsUsed(override: '*')
//import 'dart:mirrors';

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:ompa/ompa.dart';

part 'src/auth_controller.dart';
part 'src/auth_service.dart';
part 'src/route.dart';
part 'src/note_controller.dart';
part 'src/note_service_rest.dart';
part 'src/ompa_controller.dart';
part 'src/server.dart';
part 'src/success_controller.dart';
part 'src/success_service_rest.dart';
part 'src/task_controller.dart';

String serverUri = 'http://api.ompa.olem.org:8080/';

class OmpaModule extends Module{
  OmpaModule(){
    type(AuthController);
    type(AuthService);
    type(NoteController);
    type(NoteService, implementedBy: NoteServiceRest);
    type(OmpaController);
    value(RouteInitializerFn, ompaRouteInitializer);
    factory(NgRoutingUsePushState,
            (_) => new NgRoutingUsePushState.value(false));
    type(Server);
    type(SuccessController);
    type(SuccessService, implementedBy: SuccessServiceRest);
    type(TaskController);
  }
}

main(){
  if(window.location.host == '127.0.0.1:3030'){
    serverUri = 'http://127.0.0.1:8080/';
  }
  ngBootstrap(module: new OmpaModule());
}
