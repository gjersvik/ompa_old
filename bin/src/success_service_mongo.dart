part of ompa;

class SuccessServiceMongo extends SuccessService{
  DbCollection _db;
  SuccessServiceMongo(Db db){
    _db = db.collection('success');
  }
  
  Future save(Success success){
    return _db.insert(_toMongo(success)).then((_) => success);
  }
  
  Future<List<Success>> getDay(DateTime day){
    var start = new DateTime.utc(day.year,day.month,day.day);
    var end = new DateTime.utc(day.year,day.month,day.day + 1);
    return _db.find(where.inRange('time', start, end)).toList()
        .then((list) => list.map(_fromMongo).toList());
  }
  
  Success _fromMongo(Map data){
    data = fromMongo(data);
    data['time'] = data['time'].toUtc().toString();
    return new Success(data);
  }
  
  Map _toMongo(Success success){
    var data = success.toJson();
    data['time'] = DateTime.parse(data['time']);
    return toMongo(data);
  }
}