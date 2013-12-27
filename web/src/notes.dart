part of ompa_html;

class Notes{
  final DivElement elem = new DivElement();
  
  final Server _server;
  
  Notes(this._server){
    elem.className = 'notes';
    
    _server.getJson('note').then((List notes){
      notes.forEach((Map note){
        add(new Note(note['name'],note['text'],_server));
      });
    });
  }
  
  add(Note note){
    elem.append(note.elem);
  }
}
