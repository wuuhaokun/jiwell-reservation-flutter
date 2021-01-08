
class CouponEntity {
  List<CouponModel> couponModellList;
  CouponEntity({this.couponModellList});
  CouponEntity.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      couponModellList = <CouponModel>[];
      List<Map> dataList= (json['items'] as List).cast();
      dataList.forEach((v) {
        couponModellList.add(new CouponModel.fromJson(v));
      }
      );
    }
  }
}

class CouponModel {
  int id;
  int type;
  String name;
  int platform;
  int count;
  double amount;
  int perLimit;
  double minPoint;
  int startTime;
  int endTime;
  int useType;
  String note;
  int publishCount;
  int useCount;
  int receiveCount;
  int enableTime;
  String code;
  int memberLevel;
  CouponModel({this.id,this.type,this.name,this.platform,this.count,this.amount,this.perLimit,
  this.minPoint,this.startTime,this.endTime,this.useType,this.note,
  this.publishCount,this.useCount,this.receiveCount,this.enableTime,this.code,this.memberLevel});
  CouponModel.fromJson(Map<String, dynamic> data) {
    id = (data['id']??-1);
    type = (data['type']??-1);
    name = (data['name']??'');
    platform = (data['platform']??-1);
    count = (data['count']??-1);
    perLimit = (data['perLimit']??-1);
    minPoint = (data['minPoint']??-1);
    startTime = (data['startTime']??'');
    endTime = (data['endTime']??'');
    useType = (data['useType']??-1);
    endTime = (data['endTime']??'');
    note = (data['note']??'');
    publishCount = (data['publishCount']??-1);
    useCount = (data['useCount']??-1);
    receiveCount = (data['receiveCount']??-1);
    enableTime = (data['enableTime']??-1);
    code = (data['code']??'');
    memberLevel = (data['memberLevel']??-1);
  }
}

class CouponHistoryDetailEntity {
  List<CouponHistoryDetailModel> couponHistoryDetailModelList;
  CouponHistoryDetailEntity({this.couponHistoryDetailModelList});
  CouponHistoryDetailEntity.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      couponHistoryDetailModelList = <CouponHistoryDetailModel>[];
      List<Map> dataList= (json['items'] as List).cast();
      dataList.forEach((v) {
        couponHistoryDetailModelList.add(new CouponHistoryDetailModel.fromJson(v));
      });
    }
  }
}

class CouponHistoryDetailModel {
  CouponModel couponModel;
//   //优惠券关联商品
//   private List<CouponProductRelation> productRelationList;
//   //优惠券关联商品分类
//   private List<CouponProductCategoryRelation> categoryRelationList;

  CouponHistoryDetailModel({this.couponModel});
  CouponHistoryDetailModel.fromJson(Map<String, dynamic> data) {
    if (data['coupon'] != null) {
      couponModel = CouponModel.fromJson(data['coupon']);
    }
  }
}

// public class CouponHistoryDetail extends CouponHistory {
//   //相关优惠券信息
//   private Coupon coupon;
//   //优惠券关联商品
//   private List<CouponProductRelation> productRelationList;
//   //优惠券关联商品分类
//   private List<CouponProductCategoryRelation> categoryRelationList;
//
//   public Coupon getCoupon() {
//     return coupon;
//   }
//
//   public void setCoupon(Coupon coupon) {
//     this.coupon = coupon;
//   }
//
//   public List<CouponProductRelation> getProductRelationList() {
//     return productRelationList;
//   }

// class CouponModel {
//   String id;
//   int type;
//   String name;
//   int platform;
//   int count;
//   double amount;
//   int perLimit;
//   double minPoint;
//   int startTime;
//   int endTime;
//   int useType;
//   String note;
//   int publishCount;
//   int useCount;
//   int receiveCount;
//   int enableTime;
//   String code;
//   int memberLevel;
//   CouponModel({this.id,this.type,this.name,this.platform,this.count,this.amount,this.perLimit,
//     this.minPoint,this.startTime,this.endTime,this.useType,this.note,
//     this.publishCount,this.useCount,this.receiveCount,this.enableTime,this.code,this.memberLevel});
//   CouponModel.fromJson(Map<String, dynamic> data) {
//     id = (data['id']??'');
//     type = (data['type']??-1);
//     name = (data['name']??'');
//     platform = (data['platform']??-1);
//     count = (data['count']??-1);
//     perLimit = (data['perLimit']??-1);
//     minPoint = (data['minPoint']??-1);
//     startTime = (data['startTime']??'');
//     endTime = (data['endTime']??'');
//     useType = (data['useType']??-1);
//     endTime = (data['endTime']??'');
//     note = (data['note']??'');
//     publishCount = (data['publishCount']??-1);
//     useCount = (data['useCount']??-1);
//     receiveCount = (data['receiveCount']??-1);
//     enableTime = (data['enableTime']??"");
//     code = (data['code']??'');
//     memberLevel = (data['memberLevel']??-1);
//   }
// }
