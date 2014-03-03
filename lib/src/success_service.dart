part of ompa_common;

abstract class SuccessService{
  Future<List<Success>> getDay(DateTime day);
  Future<Success> save(Success);
}