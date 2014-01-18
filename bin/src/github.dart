part of ompa;

class GitHub {
  Stream<Success> onSuccess;
  
  final String user;
  final String _auth;
  var _client = new HttpClient();
  var _etag = null;
  Duration _poll =  new Duration(seconds: 60);
  var _lastId = '';
  
  StreamController<Success> _success;
  GitHub(this.user, this._auth){
    _client.userAgent = user;
    _success = new StreamController();
    onSuccess = _success.stream;
  }
  
  poolEvents(){
    var eventuri = Uri.parse('https://$_auth@api.github.com/users/$user/events');
    return _client.getUrl(eventuri).then((HttpClientRequest request) {
      if(_etag != ''){
        request.headers.add('If-None-Match', _etag);
      }
      return request.close();
    }).then((HttpClientResponse res) {
      if(res.statusCode == 200){
        _etag = res.headers.value('etag');
        _poll = new Duration(seconds: int.parse(res.headers.value('x-poll-interval')));
        return UTF8.decodeStream(res).then(parseEvent);
      }
    }).whenComplete((){
      new Timer(_poll, poolEvents);
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
        .expand((event){
          var i =  event['payload']['commits'];
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
      return _client.getUrl(build.decode())
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
