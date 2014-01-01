library success;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';


Future<Db> getDb(String uri){
  var db = new Db(uri);
  return db.open().then((_) => db);
}

main(List<String> args){
  getDb(args[0])
    .then((Db db){
      db.collection('successes').insert({'_id': new DateTime.now()});
      print('Added succsess');
    });
}