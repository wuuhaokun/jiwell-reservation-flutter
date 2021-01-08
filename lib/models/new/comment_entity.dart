
class CommentEntity {
  List<CommentModel> commentModellList;
  CommentEntity({this.commentModellList});
  CommentEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      commentModellList = <CommentModel>[];
      Map<String, dynamic> items = json['data'];
      List<Map> dataList= (items['items'] as List).cast();
      dataList.forEach((v) {
        commentModellList.add(new CommentModel.fromJson(v));
      }
      );
    }
  }
}


// private String orderid;
// /**
//  * 商品id
//  */
// private String spuid;
// /**
//  * 评论内容
//  */
// private String content;
// /**
//  * 评论时间
//  */
// private Date publishtime;
// /**
//  * 评论用户id
//  */
// private String userid;
// /**
//  * 评论用户昵称
//  */
// private String nickname;
// /**
//  * 评论的浏览量
//  */
// private Integer visits;
// /**
//  * 评论的点赞数
//  */
// private Integer thumbup;
// /**
//  * 评论中的图片
//  */
// private List<String> images;
// /**
//  * 评论的回复数
//  */
// private Integer comment;
// /**
//  * 该评论是否可以被回复
//  */
// private Boolean iscomment;
// /**
//  * 该评论的上一级id
//  */
// private String parentid;
// /**
//  * 是否是顶级评论
//  */
// private Boolean isparent;
// /**
//  * 评论的类型
//  */
// private Integer type;


// class CommentModel {
//
//   static const int normalCommentType = 0;
//   static const int longCommentType = 1;
//   static const int shortCommentType = 2;
//   static const int longCommentNullType = -1;
//
//
//   final String author;
//   final String content;
//   final String avatar;
//   final int time;
//   var replyToJson;
//   final int id;
//   final int likes;
//
//   ReplyToModel replyTo;
//
//   int itemType = normalCommentType;
//
//   CommentModel({this.avatar,
//     this.author,
//     this.content,
//     this.time,
//     this.replyToJson,
//     this.id,
//     this.likes,this.replyTo});
//
//
//   setItemType(int type) {
//     itemType = type;
//   }
//
//
//   CommentModel.fromJson(Map<String, dynamic> json)
//       : author = json['author'],
//         content = json['content'],
//         id = json['id'],
//         replyToJson = json['reply_to'],
//         time = json['time'],
//         likes = json['likes'],
//         avatar = json['avatar'];
//
// }



class CommentModel {
  static const int normalCommentType = 0;
  static const int longCommentType = 1;
  static const int shortCommentType = 2;
  static const int longCommentNullType = -1;
  int itemType = normalCommentType;
  setItemType(int type) {
    itemType = type;
  }

  String id;
  String orderid;
  String spuid;
  String content;
  int publishtime;
  String userid;
  String nickname;
  int thumbup;
  List<String> images;
  int comment;
  bool iscomment;
  String parentid;
  int type;
  ReplyToModel replyTo;

  String avatar;

  CommentModel({this.id,this.orderid,this.spuid,this.content,this.publishtime,this.userid,this.nickname,
  this.thumbup,this.images,this.comment,this.iscomment,this.parentid,
  this.type, this.replyTo, this.avatar});
  CommentModel.fromJson(Map<String, dynamic> data) {
    id = (data['_id']??'');
    orderid = (data['orderid']??'');
    spuid = (data['spuid']??'');
    content = (data['content']??'');
    publishtime = (data['publishtime']??-1);
    userid = (data['userid']??'');
    nickname = (data['nickname']??'');
    thumbup = (data['thumbup']??-1);
    //images =
    comment = (data['comment']??-1);
    iscomment = (data['iscomment']??false);
    parentid = (data['parentid']??'');
    type = (data['type']??-1);

    //replyTo = (data['replyTo']??null);
    avatar = (data['avatar']??'');
  }
}

class ReplyToModel {
  final String author;
  final String content;
  final int id;
  final int status;

  ReplyToModel({this.author, this.content, this.status, this.id});

  ReplyToModel.fromJson(Map<String, dynamic> json)
      : author = json['author'],
        content = json['content'],
        id = json['id'],
        status = json['status'];
}

