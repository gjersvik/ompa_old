library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartrs/dartrs.dart';
import 'package:mongo_dart/mongo_dart.dart';

main(){
  var db = new Db('mongodb://ompa:BAw6eyEtEBUteDeq@ds063158.mongolab.com:63158/ompa');
  
  Future.wait([RestfulServer.bind(),db.open()]).then((stuff){
    RestfulServer server = stuff[0];
    var collec = db.collection('note');
    var old = server.preProcessor;
    server.preProcessor = (HttpRequest request){
      request.response.headers
        ..add('Access-Control-Allow-Origin','http://127.0.0.1:3030')
        ..add('Access-Control-Allow-Methods', 'GET,PUT,DELETE');
      old(request);
    };
    
    server.onGet('note/{name}', (request, Map<String,String> params) {
      var id = params['name'].replaceAll('_',' ');
      return collec.findOne({'_id': id})
          .then((data){
            request.response..statusCode = 200
                ..write(data['text']);
          }).catchError((e){
            request.response..statusCode = 500
                ..write(e);
          });
    });

    server.onPut('note/{name}', (HttpRequest request, params, body) {
      var id = params['name'].replaceAll('_',' ');
      return collec.update({'_id': id}, {'_id': id, 'text': body}, upsert: true)
          .then((_){
            request.response.statusCode = 201;
          }).catchError((e){
            request.response..statusCode = 500
                ..write(e);
          });
    });
    
    server.onDelete('note/{name}', (HttpRequest request, params) {
      request.response.statusCode = 204;
    });
    
    server.onGet('note', (HttpRequest request, params){
      return collec.find().stream.map((Map m){
          return JSON.encode({
            'name': m['_id'],
            'text': m['text'],
          });
        }).join(',').then((data){
          request.response..statusCode = 200
              ..write('[$data]');
        }).catchError((e){
          request.response..statusCode = 500
              ..write(e);
        });
    });
    
    server.onOptions('', (request, params) {
      request.response.statusCode = 204;
    });
  });
}