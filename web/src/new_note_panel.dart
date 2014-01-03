part of ompa_html;

class NewNotePanel extends Panel{
  Stream<String> onNewNote;
  NewNotePanel():super(){
    var name = new TextInputElement();
    var button = new ButtonElement();
    button.text = 'Create new note';
    onNewNote = button.onClick
        .where((e) => e.button == 0)
        .map((_) => name.value);
    
    content.classes.add('newNote');
    content.append(name);
    content.append(button);
  }
}