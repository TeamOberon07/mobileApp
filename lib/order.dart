import 'package:dart_web3/dart_web3.dart';
import 'orderState.dart';

class Order{
  final int? _id;
  final EthereumAddress? _buyer;
  final EthereumAddress? _seller;
  OrderState? _state;
  String? _amount;

  Order(this._id, this._buyer, this._seller, String state, EtherAmount amount){
    _state = OrderState.values[int.parse(state)];
    _amount = EtherAmount.fromUnitAndValue(EtherUnit.wei, amount)
                            .getValueInUnit(EtherUnit.ether)
                            .toString();
  }

  String getFormattedBuyer(){
    String buyer = _buyer.toString();
    return buyer.substring(0, 5) + "..." + buyer.substring(buyer.length - 5);
  }

  String getFormattedSeller(){
    String seller = _seller.toString();
    return seller.substring(0, 5) + "..." + seller.substring(seller.length - 5);
  }

  String getId(){
    return _id.toString();
  }

  String getAmount(){
    return _amount!;
  }

  OrderState getState(){
    return _state!;
  }

}