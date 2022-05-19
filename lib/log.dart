import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'orderState.dart';
import 'package:intl/intl.dart';

class Log {
  late Map<OrderState, DateTime> _value;

  Log() {
    _value = Map<OrderState, DateTime>();
  }

  void addElement(dynamic el) {
    _value[OrderState.values[(el[0] as BigInt).toInt()]] =
        DateTime.fromMillisecondsSinceEpoch((el[1] as BigInt).toInt() * 1000);
  }

  @override
  String toString() {
    String re = "";
    _value.forEach((key, value) {
      re += key.toString() + "=" + value.toString() + "\n";
    });
    return re;
  }

  List<Row> getColumn() {
    List<Row> list = [];
    _value.forEach((key, value) {
      list.add(
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(EnumToString.convertToString(key).replaceAll('_', ' ') + ": ",
            style: TextStyle(fontSize: 20)),
        Text(DateFormat("dd/MM/yyyy - HH:mm").format(value),
            style: TextStyle(
                fontFamily: 'Piazzolla',
                fontSize: 15,
                fontFeatures: [FontFeature.tabularFigures()]))
      ]));
    });
    return list;
  }
}
