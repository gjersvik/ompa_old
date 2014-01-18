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
  var _lastId = '';
  
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
    Iterable events = filterOld(json);
    Iterable commits = toCommit(events);
    
    commits.forEach((commit){
      var s = new Success();
      s.desc = commit;
      _success.add(s);
    });
  }
  
  Iterable<Map> filterOld(Iterable<Map> events){
    var lastId = _lastId;
    _lastId = events.first['id'];
    return events.takeWhile((e) => e['id'] != lastId);
  }
  
  Iterable<String> toCommit(Iterable<Map> events){
    return events.skipWhile((e) => e['type'] != 'PushEvent')
        .expand((pushEvent){
          var i =  pushEvent['payload']['commits'];
          if(i is Iterable){ 
            return i; 
          };
          return [];
        }).map((e)=> e['url']);
  }
}

main(){
  var github = new GitHub();
  github.onSuccess.listen(print);
  github.poolEvents();
}