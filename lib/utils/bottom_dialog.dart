import 'dart:ui';
import 'package:flutter/material.dart';

/// 底部弹出框
class CommonBottomSheet extends StatefulWidget {
  const CommonBottomSheet({Key key, @required this.list, this.onItemClickListener})
      : assert(list != null),
        super(key: key);
  // ignore: always_specify_types, prefer_typing_uninitialized_variables
  final list;
  final OnItemClickListener onItemClickListener;

  @override
  _CommonBottomSheetState createState() => _CommonBottomSheetState();
}

typedef OnItemClickListener = void Function(int index);

class _CommonBottomSheetState extends State<CommonBottomSheet> {
  OnItemClickListener onItemClickListener;
  // ignore: prefer_typing_uninitialized_variables, always_specify_types
  var itemCount;
  double itemHeight = 44;
  Color borderColor = Colors.white;

  @override
  void initState() {
    super.initState();
    onItemClickListener = widget.onItemClickListener;
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Size screenSize = MediaQuery.of(context).size;

    final double deviceWidth = orientation == Orientation.portrait
        ? screenSize.width
        : screenSize.height;
    print('devide width');
    print(deviceWidth);

    /// *2-1是为了加分割线，最后还有一个cancel，所以加1
    itemCount = (widget.list.length * 2 - 1) + 1;
    // ignore: always_specify_types
    final height = ((widget.list.length+1) * 50 + 20).toDouble();
    final GestureDetector cancelContainer = GestureDetector(
      onTap:()  {
        Navigator.pop(context);
    },
      child:Container(
          height: itemHeight,
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 0.5), // 边色与边宽度
            color: Colors.white, // 底色
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(

              child: Text(
                '取消',
                style: TextStyle(
                    fontFamily: 'Robot',
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: const Color(0xff333333),
                    fontSize: 18),
              ),

          )) ,
    );
    final ListView listview = ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          if (index == itemCount - 1) {
            return cancelContainer;
          }
          return getItemContainer(context, index);
        });

    final Container totalContainer = Container(
      child: listview,
      height: height,
      width: deviceWidth * 0.95,
    );

    final Stack stack = Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          bottom: 20,
          child: totalContainer,
        ),
      ],
    );
    return stack;
  }

  Widget getItemContainer(BuildContext context, int index) {
    if (widget.list == null) {
      return Container();
    }
    if (index.isOdd) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Divider(
          height: 0.5,
          color: borderColor,
        ),
      );
    }

    // ignore: prefer_typing_uninitialized_variables, always_specify_types
    var borderRadius;
    // ignore: prefer_typing_uninitialized_variables, always_specify_types
    var margin;
    // ignore: always_specify_types, prefer_typing_uninitialized_variables
    var border;
    final Border borderAll = Border.all(color: borderColor, width: 0.5);
    final BorderSide borderSide = BorderSide(color: borderColor, width: 0.5);
    bool isFirst = false;
    bool isLast = false;

    /// 只有一个元素
    if (widget.list.length == 1) {
      borderRadius = BorderRadius.circular(12);
      margin = const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 20);
      border = borderAll;
    } else if (widget.list.length > 1) {
      /// 第一个元素
      if (index == 0) {
        isFirst = true;
        borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12));
        margin = const EdgeInsets.only(left: 10, right: 10, top: 20);
        border = Border(top: borderSide, left: borderSide, right: borderSide);
      } else if (index == itemCount - 2) {
        isLast = true;

        /// 最后一个元素
        borderRadius = const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12));
        margin = const EdgeInsets.only(bottom: 10, left: 10, right: 10);
        border =
            Border(bottom: borderSide, left: borderSide, right: borderSide);
      } else {
        /// 其他位置元素
        margin = const EdgeInsets.only(left: 10, right: 10);
        border = Border(left: borderSide, right: borderSide);
      }
    }
    final bool isFirstOrLast = isFirst || isLast;
    final int listIndex = index ~/ 2;
    // ignore: always_specify_types
    final text = widget.list[listIndex];
    final Text contentText = Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          color: const Color(0xFF333333),
          fontSize: 18),
    );

    // ignore: prefer_typing_uninitialized_variables, always_specify_types
    var center;
    if (!isFirstOrLast) {
      center = Center(
        child: contentText,
      );
    }
    final Container itemContainer = Container(
        height: itemHeight,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: borderRadius,
          border: border,
        ),
        child: center);
    final Null Function() onTap2 = () {
      if (onItemClickListener != null) {
        onItemClickListener(index);
      }
    };
    final Stack stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[itemContainer, contentText],
    );
    final GestureDetector getsture = GestureDetector(
      onTap: onTap2,
      child: isFirstOrLast ? stack : itemContainer,
    );
    return getsture;
  }
}
