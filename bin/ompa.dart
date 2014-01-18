library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dartrs/dartrs.dart';
import 'package:http_utils/http_utils.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:ompa/ompa.dart';

part 'src/auth.dart';
part 'src/github.dart';
part 'src/note.dart';
part 'src/rest.dart';
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
  Auth auth;
  getDb(args[0])
    .then((Db d)=> db = d)
    .then(getConfig)
    .then((Map c){
      conf = c;
      auth = new Auth(conf['httpkey']);
      rest = new Rest(conf);
      return rest.ready;
    })
    .then((_){
      var note = new Note(rest.server , db.collection('note'),auth);
      var success = new SuccessServer(rest.server,db.collection('success-github'),auth);
      if(conf.containsKey('github')){
        var github = new GitHub(conf['github']['user'], conf['github']['auth']);
        github.onSuccess.listen(success.save);
        github.onLastId.listen((String lastId){
          conf['github']['eventID'] = lastId;
          db.collection('config').save(conf);
        });
      }
    });
}