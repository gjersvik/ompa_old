library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dartrs/dartrs.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'src/note.dart';
part 'src/rest.dart';

Future<Db> getDb(String uri){
  var db = new Db(uri);
  return db.open().then((_) => db);
}

Future<Map> getConfig(Db db) => db.collection('config').findOne();

main(List<String> args){
  Db db = null;
  Map conf = {};
  Rest rest = null;
  List<int> key = [];
  getDb(args[0])
    .then((Db d)=> db = d)
    .then(getConfig)
    .then((Map c){
      conf = c;
      key = CryptoUtils.base64StringToBytes(conf['httpkey']);
      rest = new Rest(conf);
      return rest.ready;
    })
    .then((_){
      var note = new Note(rest.server , db.collection('note'),key);
    });
}