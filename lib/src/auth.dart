part of ompa_common;

class Auth{

  final List<int> _key;
  Auth(this._key);
  factory Auth.fromPassword(String password){
    const salt = '5Yc8GDdmKxlYpLnzcGBKpxZ0YU1rottDYGsWbDJrTK4WBsp2Hzd1sOSjAOLPdBfc';
    var hash = new SHA256();
    hash.add("$password$salt".codeUnits);
    return new Auth(hash.close());
  }

  factory Auth.fromBase64(String key){
    return new Auth(CryptoUtils.base64StringToBytes(key));
  }

  String sign({String path: '/',
               String body: '',
               String method: 'GET'}){
    var key = CryptoUtils.bytesToBase64(_getHmac(path,body,method).close());
    return 'OMPA-TOKEN token="$key"';
  }

  bool validate(String authHeader, {String path: '/',
                 String body: '',
                 String method: 'GET'}){

    var digest = CryptoUtils.base64StringToBytes(authHeader.split('"')[1]);
    return _getHmac(path,body, method).verify(digest);
  }

  String toBase64(){
    return CryptoUtils.bytesToBase64(_key);
  }

  HMAC _getHmac(path, body, method){
    var hmac = new HMAC(new SHA256(),_key);
    hmac.add(path.codeUnits);
    hmac.add(method.codeUnits);
    if(body != null){
      hmac.add(body.codeUnits);
    }
    return hmac;
  }
}