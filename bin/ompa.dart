library ompa;

import 'dart:io';
import 'dart:async';

import 'package:dartrs/dartrs.dart';
import 'package:mongo_dart/mongo_dart.dart';

main(){
  var db = new Db('mongodb://ompa:BAw6eyEtEBUteDeq@ds063158.mongolab.com:63158/ompa');
  
  Future.wait([RestfulServer.bind(),db.open()]).then((stuff){
    var server = stuff[0];
    var collec = db.collection('note');
    
    server.onGet('note/{name}', (request, params) {
      request.response.write("Name ${params['name']}");
    });

    server.onPut('note/{name}', (HttpRequest request, params, body) {
      var id = Uri.decodeComponent(params['name']);
      return collec.update({'_id': id}, {'_id': id, 'text': body}, upsert: true)
          .then((_){
            request.response.statusCode = 201;
          }).catchError((e){
            request.response..statusCode = 500
                ..write(e);
          });
    });
    
    server.onDelete('note/{name}', (request, params) {
      request.response.write("Name ${params['name']}");
    });
  });
}