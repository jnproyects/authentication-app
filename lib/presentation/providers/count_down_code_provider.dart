
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_down_code_provider.g.dart';

@riverpod
Stream<int> countDownCode(CountDownCodeRef ref) async* {

  yield 60;
  await for( final numb in _countDownStream() ) {
    yield numb;
  }
}


Stream<int> _countDownStream() {

  const duration = Duration( seconds: 1 );
  int intialValue = 59;
  
  return Stream.periodic( 
    duration, 
    (i) => intialValue--
  ).take(60);


}