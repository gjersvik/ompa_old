library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartrs/dartrs.dart';
import 'package:http_utils/http_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ompa/ompa.dart';

part 'src/github.dart';
part 'src/handler.dart';
part 'src/note_server.dart';
part 'src/note_service_mongo.dart';
part 'src/rest.dart';
part 'src/server.dart';
part 'src/success_server.dart';

Future<Db> getDb(String uri){
  var db = new Db(uri);
  return db.open().then((_) => db);
}

Future<Map> getConfig(Db db){
  if(Platform.isLinux){
    return db.collection('config').findOne({'_id':'pro'});
  }else{
    return db.collection('config').findOne({'_id':'dev'});
  }
}

main(List<String> args){
  Db db = null;
  Map conf = {};
  Rest rest = null;
  ServerAuth auth;
  getDb(args[0])
    .then((Db d)=> db = d)
    .then(getConfig)
    .then((Map c){
      conf = c;
      auth = new ServerAuth(conf['httpkey']);
      rest = new Rest(conf);
      return rest.ready;
    })
    .then((_){
      var noteService = new NoteServiceMongo(db.collection('note'));
      var noteServer = new NoteServer(rest.server, auth, noteService);
      var success = new SuccessServer(rest.server,db.collection('success'),auth);
      if(conf.containsKey('github')){
        var github = new GitHub(conf['github']['user'], conf['github']['auth'], conf['github']['eventID']);
        github.onSuccess.listen(success.save);
        github.onLastId.listen((String lastId){
          conf['github']['eventID'] = lastId;
          db.collection('config').save(conf);
        });
      }
    });
}