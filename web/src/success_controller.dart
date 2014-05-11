part of ompa_html;

@Controller( selector: '[ompa-success]', publishAs: 'OmpaSuccess')
@Injectable()
class SuccessController{
  static const DAY = const Duration(days:1);
  
  DateTime date = new DateTime.now().toUtc();
  List<Success> successes = [];
  String addBox = '';
  
  final SuccessService _service;

  SuccessController(this._service){
    getDay(date);
  }
  
  add(){
    var success = new Success();
    success.desc = addBox;
    addBox = '';
    _service.save(success).then((_) => getDay(date));
  }
  
  next(){
    date = date.add(DAY);
    getDay(date);
  }
  
  prev(){
    date = date.subtract(DAY);
    getDay(date);
  }
  
  getDay(DateTime day){
    return _service.getDay(day).then((list) => successes = list);
  }
}