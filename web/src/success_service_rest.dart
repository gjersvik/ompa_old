part of ompa_html;

@Injectable()
class SuccessServiceRest extends SuccessService{
  Server _server;
  SuccessServiceRest(this._server);
  
  Future<List<Success>> getDay(DateTime day) {
    return _server.getJson('success/${day.year}/${day.month}/${day.day}')
            .then((List data) => data.map((d)=> new Success(d)).toList());
  }

  Future<Success> save(Success success) {
    return _server.putJson('success/add',success).then((_) => success);
  }
}