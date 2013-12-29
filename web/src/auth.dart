part of ompa_html;

class Auth{
  final DivElement elem = new DivElement();
  
  final InputElement _pass = new InputElement(type: 'password');
  final ButtonElement _start = new ButtonElement();
  
  Auth(Element parent){
    elem.className = 'login';
    elem.append(_pass);
    elem.append(_start);
    
    _start.text = 'Start';
    _start.onClick.listen((MouseEvent e) => e.button == 0 ? _login(): null);
    
    parent.append(elem);
  }
  
  _login(){
    var key = _pass.value;
    var hash = new SHA256();
    hash.add(key.codeUnits);
    print(hash.close());
    
  }
}