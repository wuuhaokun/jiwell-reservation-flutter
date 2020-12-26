import 'package:dio/dio.dart';

import 'package:jiwell_reservation/models/entity_factory.dart';
// ignore: directives_ordering
import 'dart:async';

//const CLEAR_URL = '$JIWELL_SERVER_HOST/cart/';
const String CLEAR_URL = 'http://47.107.101.76/classify/list';

class ClassifyDao{
  static Future<Classify> fetch() async{
    try {
      // ignore: always_specify_types
      final Response response = await Dio().get(CLEAR_URL);
      if(response.statusCode == 200){
        return EntityFactory.generateOBJ<Classify>(response.data);
      }else{
        throw Exception('StatusCode: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class Classify {
  List<ClassifyEntity> category;
  // ignore: sort_constructors_first
  Classify({this.category});
  // ignore: sort_constructors_first
  Classify.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      category = <ClassifyEntity>[];
      // ignore: avoid_as, always_specify_types, avoid_function_literals_in_foreach_calls
      (json['data'] as List).forEach((v) {
        category.add(ClassifyEntity.fromJson(v)); });
    }
  }
}
class ClassifyEntity{
  int id;
  String classifyName;
  int parentId;
  String img;
  List<Children> children;

  // ignore: sort_constructors_first
  ClassifyEntity({this.id,this.classifyName,this.parentId,this.img, this.children});
  // ignore: sort_constructors_first
  factory ClassifyEntity.fromJson(Map<String, dynamic> parsedJson){
    // ignore: always_specify_types
    final List<Children> childrenList = [];
    // ignore: avoid_as, always_specify_types
    final List<Map> dataList= (parsedJson['Children'] as List).cast();
    // ignore: always_specify_types, avoid_function_literals_in_foreach_calls
    dataList.forEach((Map v) {
      childrenList.add(Children.fromJson(v));
    });

    return ClassifyEntity(
        // ignore: unnecessary_parenthesis
        id: (parsedJson['Id']),
        classifyName: parsedJson['ClassifyName'],
        // ignore: unnecessary_parenthesis
        img: (parsedJson['Img']),
        // ignore: unnecessary_parenthesis
        parentId: (parsedJson['ParentId']),
        children: childrenList
    );
  }
}

class Children {
  int id;
  String classifyName;
  int parentId;
  String img;

  // ignore: sort_constructors_first
  Children({this.id, this.classifyName, this.parentId, this.img});
  // ignore: sort_constructors_first
  Children.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    classifyName = json['ClassifyName'];
    parentId = json['ParentId'];
    img = json['Img'];
  }
}
