import 'package:flutter/material.dart';
import 'package:jiwell_reservation/models/new/specifications_entity.dart';
import 'package:jiwell_reservation/receiver/event_bus.dart';
import 'package:smart_select/smart_select.dart';

// ignore: must_be_immutable
class FeaturesMultiPopup extends StatefulWidget {
  String title;
  List<String> multiValue = [];
  List<S2Choice<String>> items = [];
  ParamsModel paramsModel;
  int localOwnSpecIndex;
  int globalOwnSpecIndex;
  int multiCount;
  int ownSpecIndex;
  FeaturesMultiPopup({Key key,this.title,this.multiValue,this.items,this.paramsModel,
    this.localOwnSpecIndex,this.globalOwnSpecIndex,this.multiCount,this.ownSpecIndex}):super(key:key);

  @override
  _FeaturesMultiPopupState createState() => _FeaturesMultiPopupState();
}

class _FeaturesMultiPopupState extends State<FeaturesMultiPopup> {

  List<String> _multiValue = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.multiple(
          title: widget.title,
          value: _multiValue,
          placeholder:'選擇一個或多個',
          //onChange: (state) => setState(() => _multiValue = state.value),
          onChange: (state) {
            String selectedValue = '';
            _multiValue = state.value;
            _multiValue.forEach((v) {
              int index = int.parse(v);
              S2Choice s2Choice = widget.items[index];
              if(selectedValue == ''){
                selectedValue = s2Choice.title;
              }
              else{
                selectedValue = selectedValue + '+'+ s2Choice.title;
              }
            });

            eventBus.fire(SelectSpecsMultiValueEvent(widget.localOwnSpecIndex,widget.globalOwnSpecIndex,_multiValue,widget.multiCount,widget.ownSpecIndex,widget.title,selectedValue));
            setState(() {

            });
          },
          choiceItems: widget.items,
          modalType: S2ModalType.popupDialog,
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              isTwoLine: true,
              leading: Container(
                width: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.library_add),
              ),
            );
          },
        ),
        const Divider(indent: 20),
      ],
    );
  }
  @override
  void initState() {
    _multiValue = widget.multiValue;
    super.initState();
  }
}