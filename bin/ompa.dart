library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';
import 'package:http_utils/http_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ompa/ompa.dart';

part 'src/crud_mongo.dart';
part 'src/github.dart';
part 'src/handler.dart';
part 'src/mongo_utils.dart';
part 'src/note_server.dart';
part 'src/note_service_mongo.dart';
part 'src/server.dart';
part 'src/success_server.dart';
part 'src/success_service_mongo.dart';
part 'src/task_server.dart';
part 'src/task_service_mongo.dart';

Future<Map> getConfig(Db db){
  var config = {
    //base64(sha256('12345678' + AUTH.salt))
    'httpkey': '/cEW+Br+78JmamC4tbkqXUf2LqNBAZvw3SV6dI63x/0=',
    'origin': 'http://127.0.0.1:3030'
  };
  return db.collection('config').findOne({'_id':'pro'})
    .then((data){
      if(data != null){
        config.addAll(data);
      }
      return config;
    });
}

Future<Db> startDb(url){
  if(url == null){
    url = 'mongodb://127.0.0.1/ompa';
  }
  
  Db db = new Db(url);
  return db.open().then((_) => db);
}

class OmpaModule extends Module{
  OmpaModule(){
    type(GitHub);
    type(Server);
    type(NoteServer);
    type(NoteService, implementedBy: NoteServiceMongo);
    type(SuccessServer);
    type(SuccessService, implementedBy: SuccessServiceMongo);
    type(TaskServer);
    type(TaskService, implementedBy: TaskServiceMongo);
  }
}

main(List<String> args){
  Module module = new OmpaModule();
  
  var dburi = null;
  if(args.isNotEmpty){
    dburi = args[0];
  }
  startDb(dburi).then((Db db){
    module.value(Db, db);
    return getConfig(db);
  }).then((Map conf){
    module.value(Map, conf);
    var inject = new DynamicInjector(modules:[module]);
    
    Server server = inject.get(Server);
    server.addHandler(inject.get(NoteServer));
    server.addHandler(inject.get(SuccessServer));
    server.addHandler(inject.get(TaskServer));
    
    inject.get(GitHub);
    
    return server.start();
  }).then((_){
    print('Ready');
  });
}