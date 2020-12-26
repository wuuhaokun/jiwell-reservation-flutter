import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/new/specifications_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:smart_select/smart_select.dart';

class FeaturesSinglePopup extends StatefulWidget {
  String title ='';
  String value = '';
  List<S2Choice<String>> items = [];
  ParamsModel paramsModel;
  int localOwnSpecIndex;
  int globalOwnSpecIndex;
  int ownSpecindex;
  FeaturesSinglePopup({Key key,this.title,this.value,this.items,this.paramsModel,this.localOwnSpecIndex,this.globalOwnSpecIndex,this.ownSpecindex}):super(key:key);
  @override
  _FeaturesSinglePopupState createState() => _FeaturesSinglePopupState();
}

class _FeaturesSinglePopupState extends State<FeaturesSinglePopup> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.single(
          title: widget.title,
          value: _value,
          choiceItems: widget.items,
          //onChange: (state) => setState(() => _value = state.value),
          onChange: (state) {
            setState(() {
              _value = state.value;
              S2Choice s2Choice = widget.items[int.parse(_value)];
              eventBus.fire(SelectSpecsSingleValueEvent(widget.localOwnSpecIndex,widget.globalOwnSpecIndex,_value,widget.ownSpecindex,widget.title,s2Choice.title));
            });
          } ,
          modalType: S2ModalType.popupDialog,
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              leading: const Icon(Icons.shopping_cart),
            );
          },
        ),
        const SizedBox(height: 7),
      ],
    );
  }

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }
}