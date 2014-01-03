part of ompa_html;

class AuthPanel extends Panel{
  
  Stream<String> onPassword;
  
  AuthPanel():super(){
    var pass = new InputElement(type: 'password');
    var start = new ButtonElement();
    start.text = 'Start';
    
    content.classes.add('auth');
    content.append(pass);
    content.append(start);
    
    onPassword = start.onClick
      .where((e) => e.button == 0)
      .map((_) => pass.value);
  }
}