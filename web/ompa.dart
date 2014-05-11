library ompa_html;

import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

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
part 'src/task_service_rest.dart';

String serverUri = 'http://api.ompa.olem.org/';

class OmpaModule extends Module{
  OmpaModule(){
    bind(AuthController);
    bind(AuthService);
    bind(NoteController);
    bind(NoteService, toImplementation: NoteServiceRest);
    bind(OmpaController);
    bind(RouteInitializerFn, toValue: ompaRouteInitializer);
    bind(NgRoutingUsePushState,
        toFactory: (_) => new NgRoutingUsePushState.value(false));
    bind(Server);
    bind(SuccessController);
    bind(SuccessService, toImplementation: SuccessServiceRest);
    bind(TaskController);
    bind(TaskService, toImplementation: TaskServiceRest);
  }
}

main(){
  if(window.location.host == '127.0.0.1:3030'){
    serverUri = 'http://127.0.0.1:8080/';
  }
  applicationFactory()
    .addModule(new OmpaModule())
    .run();
}
