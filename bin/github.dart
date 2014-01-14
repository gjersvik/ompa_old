import 'dart:async';
import 'dart:io';
import 'dart:convert';

class GitHub {
  var client = new HttpClient();
  var uri = Uri.parse('https://8f55e6b86df1a2f3a00a8cc046c3489438d7645f@api.github.com/users/gjersvik/events');
  var etag = null;
  Duration pool =  new Duration(seconds: 60);
  
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
      res.headers.forEach((name, values) => print('$name: ' + values.join(', ')));
      
      if(res.statusCode == 200){
        etag = res.headers.value('etag');
        pool = new Duration(seconds: int.parse(res.headers.value('x-poll-interval')));
        return UTF8.decodeStream(res).then(print)
            .then((_) => pool);
      }else{
        return pool;
      }
    }).then((Duration poll){
      new Timer(poll, poolEvents);
    });
  }
}

main(){
  var github = new GitHub();
  github.poolEvents();
}