import 'dart:async';
import 'dart:io';
import 'dart:convert';

class GitHub {
  var client = new HttpClient();
  var uri = Uri.parse('https://8f55e6b86df1a2f3a00a8cc046c3489438d7645f@api.github.com/users/gjersvik/events');
  var etag = null;
  Duration poll =  new Duration(seconds: 60);
  
  GitHub(){
    client.userAgent = 'gjersvik';
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
    Iterable pushEvent = json.skipWhile((Map event) => event['type'] != 'PushEvent');
    Iterable commits = pushEvent.expand((Map event){ 
      var i =  event['payload']['commits'];
      if(i is Iterable){ 
        return i; 
      };
      return [];
    });
    
    commits.forEach((commit){
      print(commit['message']);
    });
  }
}

main(){
  var github = new GitHub();
  github.poolEvents();
}