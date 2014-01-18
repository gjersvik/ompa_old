import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http_utils/http_utils.dart';
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
    Iterable events = filterOld(json);
    Iterable commits = toCommit(events);
    return createSuccsess(commits);
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
  
  Future createSuccsess(Iterable<String> urls){
    return Future.forEach(urls, (String url){
      var uri = Uri.parse(url);
      var success = new Success();
      success.desc = 'Commit to ${uri.pathSegments[2]}';
      var build = new URIBuilder.fromUri(uri);
      build.setUserInfo('8f55e6b86df1a2f3a00a8cc046c3489438d7645f', 'x-oauth-basic');
      return client.getUrl(build.decode())
        .then((req) => req.close())
        .then((HttpClientResponse res) {
          if(res.statusCode == 200){
            return UTF8.decodeStream(res).then(JSON.decode).then((Map commit){
              success.time = DateTime.parse(commit['commit']['author']['date']);
              _success.add(success);
            });
          }
        });
    });
  }
}

main(){
  var github = new GitHub();
  //github.onSuccess.listen(print);
  github.poolEvents();
}