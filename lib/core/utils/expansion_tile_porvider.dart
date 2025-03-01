import 'package:flutter_riverpod/flutter_riverpod.dart';

final expansionTileProvider = NotifierProvider<ExpansionTileProvider,int>((){
  return ExpansionTileProvider();
});

class ExpansionTileProvider extends Notifier<int>{
  @override
  build() {
    return 0;
  }
  void setIndex(int index){
    state = index;
  }
}