library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';
import 'package:http_utils/http_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ompa/ompa.dart';

part 'src/github.dart';
part 'src/handler.dart';
part 'src/note_server.dart';
part 'src/note_service_mongo.dart';
part 'src/server.dart';
part 'src/success_server.dart';

Future<Map> getConfig(Db db){
  if(Platform.isLinux){
    return db.collection('config').findOne({'_id':'pro'});
  }else{
    return db.collection('config').findOne({'_id':'dev'});
  }
}

class OmpaModule extends Module{
  OmpaModule(){
    type(Server);
  }
}

main(List<String> args){
  Module module = new OmpaModule();
  
  Db db = new Db(args[0]);
  db.open().then((_){
    module.value(Db, db);
    return getConfig(db);
  }).then((Map conf){
    module.value(Map, conf);
    var inject = new DynamicInjector(modules:[module]);
    
    Server server = inject.get(Server);
    
    var noteService = new NoteServiceMongo(db.collection('note'));
    var noteServer = new NoteServer(noteService);
    var success = new SuccessServer(db.collection('success'));
    server.addHandler(noteServer);
    server.addHandler(success);
    
    if(conf.containsKey('github')){
      var github = new GitHub(conf['github']['user'], conf['github']['auth'], conf['github']['eventID']);
      github.onSuccess.listen(success.save);
      github.onLastId.listen((String lastId){
        conf['github']['eventID'] = lastId;
        db.collection('config').save(conf);
      });
    }
    
    return server.start();
  }).then((_){
    print('Ready');
  });
}