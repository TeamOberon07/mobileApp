import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/log.dart';

void main() {
   test('log', (){
     dynamic lista = [BigInt.from(1),BigInt.from(1)];
     Log log = Log();
     log.addElement(lista);
     log.toString();
     log.getColumn();


  });
}