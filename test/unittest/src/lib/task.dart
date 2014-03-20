part of ompa_common_unittest;

taskTest() => group('Task', (){
  test('EMPTY', (){
    expect(Task.EMPTY, new Task());
  });
});