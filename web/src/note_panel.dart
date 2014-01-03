part of ompa_html;

class NotePanel extends Panel{
  final String title;
  
  Stream<NotePanel> onSave;
  Stream<NotePanel> onDelete;
  
  
  ButtonElement _save = new ButtonElement();
  ButtonElement _delete = new ButtonElement();
  TextAreaElement _textbox =  new TextAreaElement();
  
  NotePanel(this.title, text): super(){
    note = text;
    
    content.classes.add('note');
    
    var _title = new DivElement();
    _title.className = 'top';
    _title.text = title;
    content.append(_title);
    
    _textbox.className = 'center';
    content.append(_textbox);
    
    _save.text = 'Save';
    _save.className = 'save';
    onSave = _save.onClick
        .where((MouseEvent e) => e.button == 0)
          .map((_){
            _save.text = 'Saveing...';
            return this;
          });
    content.append(_save);
    
    _delete.text = 'Delete';
    _delete.className = 'delete';
    onDelete = _delete.onClick
        .where((MouseEvent e) => e.button == 0)
          .map((_){
            _delete.text = 'Deleting';
            return this;
          });
    content.append(_delete);
  }
  
  String get note => _textbox.value;
  set note(text) => _textbox.value = text;
  
  saveDone() => _save.text = 'Save';
}
