import 'dart:io';
import 'dart:convert';

main(){
  var uri = Uri.parse('https://8f55e6b86df1a2f3a00a8cc046c3489438d7645f@api.github.com/users/gjersvik/events');
  
  var client = new HttpClient();
  client.userAgent = 'gjersvik';
  client.getUrl(uri).then((HttpClientRequest request) {
    return request.close();
  })
  .then((HttpClientResponse res) {
    print('${res.statusCode} ${res.reasonPhrase }');
    res.headers.forEach((name, values) => print('$name: ' + values.join(', ')));
    UTF8.decodeStream(res).then(print);
    
  });
}