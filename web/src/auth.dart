part of ompa_html;

Future<List<int>> auth(Element parent){
  var salt = '5Yc8GDdmKxlYpLnzcGBKpxZ0YU1rottDYGsWbDJrTK4WBsp2Hzd1sOSjAOLPdBfc';
  var elem = new DivElement();
  var pass = new InputElement(type: 'password');
  var start = new ButtonElement();
  var key = new Completer();
  
  elem.className = 'login';
  elem.append(pass);
  elem.append(start);
  
  start.text = 'Start';
  parent.append(elem);
  
  return start.onClick.firstWhere((e) => e.button == 0).then((_){
    var key = pass.value + salt;
    var hash = new SHA256();
    hash.add(key.codeUnits);
    elem.remove();
    return hash.close();
  });
}