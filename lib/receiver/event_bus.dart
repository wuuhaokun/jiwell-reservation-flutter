import 'package:event_bus/event_bus.dart';

//Bus初始化
EventBus eventBus = EventBus();

class ToCarPageInEvent{
  String  index;
  // ignore: sort_constructors_first
  ToCarPageInEvent(String text){
    // ignore: prefer_initializing_formals
    index = text;
  }
}

class UserLoggedInEvent {
  String text;
  // ignore: sort_constructors_first
  UserLoggedInEvent(String text){
    // ignore: prefer_initializing_formals
    this.text = text;
  }
}

class UserNumInEvent{
  String num;
  // ignore: sort_constructors_first
  UserNumInEvent(String text){
    // ignore: prefer_initializing_formals
    num = text;
  }
}

class GoodsRemoveInEvent{
  String  event;
  int index;
  // ignore: sort_constructors_first
  GoodsRemoveInEvent(String text, int index){
    // ignore: prefer_initializing_formals
    this.index = index;
    event = text;
  }
}

class GoodsNumInEvent{
  String  event;
  // ignore: sort_constructors_first
  GoodsNumInEvent(String text){
    // ignore: prefer_initializing_formals
    event = text;
  }
}

class IndexInEvent{
  String  index;
  // ignore: sort_constructors_first
  IndexInEvent(String text){
    // ignore: prefer_initializing_formals
    index = text;
  }
}

class OrderInEvent {
  String text;
  // ignore: sort_constructors_first
  OrderInEvent(String text){
    // ignore: prefer_initializing_formals
    this.text = text;
  }
}

class UserInfoInEvent {
  String text;
  // ignore: sort_constructors_first
  UserInfoInEvent(String text){
    // ignore: prefer_initializing_formals
    this.text = text;
  }
}

class SpecEvent{
  String  code;
  // ignore: sort_constructors_first
  SpecEvent(String text){
    // ignore: prefer_initializing_formals
    code = text;
  }
}

class SelectSpecsSingleValueEvent{
  int  globalOwnSpecIndex;
  int  localOwnSpecIndex;
  String  value;
  List<String> multiValue = [];
  int ownSpecIndex;
  String key;
  String selectValue;
  SelectSpecsSingleValueEvent(int localOwnIndex,int globalOwnIndex, String ownValue,int ownSpecIndex, String key, String selectValue){
    globalOwnSpecIndex = globalOwnIndex;
    localOwnSpecIndex = localOwnIndex;
    value = ownValue;
    this.ownSpecIndex = ownSpecIndex;
    this.key = key;
    this.selectValue = selectValue;
  }
}

class SelectSpecsMultiValueEvent{
  int  globalOwnSpecIndex;
  int  localOwnSpecIndex;
  List<String> multiValue = [];
  int multiCount;
  int ownSpecIndex;
  String key;
  String selectValue;

  SelectSpecsMultiValueEvent(int localOwnIndex,int globalOwnIndex, List<String> ownMultiValue,int ownMultiCount,int ownSpecIndex, String key, String selectValue){
    globalOwnSpecIndex = globalOwnIndex;
    localOwnSpecIndex = localOwnIndex;
    multiValue = ownMultiValue;
    multiCount = ownMultiCount;
    this.ownSpecIndex = ownSpecIndex;
    this.key = key;
    this.selectValue = selectValue;
  }
}

class SelectedSkuEvent{
  int  index;
  Map ownSpec;
  SelectedSkuEvent(int modelIndex,Map ownSpec){
    this.index = modelIndex;
    this.ownSpec = ownSpec;
  }
}

class ToAddCarButtonInEvent{
  String  index;
  ToAddCarButtonInEvent(String  index){
    this.index = index;
  }
}

class DeleteOrderInEvent{
  //String  index;
  DeleteOrderInEvent(){
    //this.index = index;
  }
}

class LikeNumInEvent{
  String  event;
  // ignore: sort_constructors_first
  LikeNumInEvent(String text){
    // ignore: prefer_initializing_formals
    event = text;
  }
}