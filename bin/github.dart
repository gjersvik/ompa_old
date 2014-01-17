import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:ompa/ompa.dart';

class GitHub {
  Stream<Success> onSuccess;
  
  var client = new HttpClient();
  var uri = Uri.parse('https://8f55e6b86df1a2f3a00a8cc046c3489438d7645f@api.github.com/users/gjersvik/events');
  var etag = null;
  Duration poll =  new Duration(seconds: 60);
  var lastEventId = '';
  
  StreamController<Success> _success;
  GitHub(){
    client.userAgent = 'gjersvik';
    _success = new StreamController();
    onSuccess = _success.stream;
  }
  
  poolEvents(){
    return client.getUrl(uri).then((HttpClientRequest request) {
      if(etag != ''){
        request.headers.add('If-None-Match', etag);
      }
      return request.close();
    }).then((HttpClientResponse res) {
      print('${res.statusCode} ${res.reasonPhrase }');
      if(res.statusCode == 200){
        etag = res.headers.value('etag');
        poll = new Duration(seconds: int.parse(res.headers.value('x-poll-interval')));
        return UTF8.decodeStream(res).then(parseEvent);
      }
    }).whenComplete((){
      new Timer(poll, poolEvents);
    });
  }
  
  parseEvent(String data){
    List json = JSON.decode(data);
    print(json);
    Iterable newEvent = json.takeWhile((e) => e['id'] != lastEventId);
    Iterable pushEvent = newEvent.skipWhile((e) => e['type'] != 'PushEvent');
    Iterable commits = pushEvent.expand((Map event){ 
      var i =  event['payload']['commits'];
      if(i is Iterable){ 
        return i; 
      };
      return [];
    });
    
    commits.forEach((commit){
      var s = new Success();
      s.desc = commit['message'];
      _success.add(s);
    });
    lastEventId = json.first['id'];
  }
}

main(){
  var github = new GitHub();
  github.onSuccess.listen(print);
  github.poolEvents();
}