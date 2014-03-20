library ompa_common_unittest;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'package:ompa/ompa.dart';

part 'src/lib/task.dart';

main(){
  useVMConfiguration();
  group('OmpaCommon',(){
    taskTest();
  });
}