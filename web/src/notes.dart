part of ompa_html;

class Notes{
  final DivElement elem = new DivElement();
  
  Notes(){
    elem.className = 'notes';
  }
  
  add(Note note){
    elem.append(note.elem);
  }
}
