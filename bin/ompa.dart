library ompa;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartrs/dartrs.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'src/note.dart';

main(List<String> args){
  var db = new Db(args[0]);
  
  Future.wait([RestfulServer.bind(),db.open()]).then((stuff){
    RestfulServer server = stuff[0];
    var old = server.preProcessor;
    server.preProcessor = (HttpRequest request){
      request.response.headers
        ..add('Access-Control-Allow-Origin','http://127.0.0.1:3030')
        ..add('Access-Control-Allow-Methods', 'GET,PUT,DELETE')
        ..add('Access-Control-Allow-Credentials', 'true')
        ..add('Access-Control-Allow-Headers', 'Authorization');
      old(request);
    };
    
    server.onOptions('', (request, params) {
      request.response.statusCode = 204;
    });
    
    var note = new Note(server , db.collection('note'));
  });
}