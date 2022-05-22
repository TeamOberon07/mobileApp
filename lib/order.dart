import 'package:dart_web3/dart_web3.dart';
import 'orderState.dart';

class Order{
  final int? _id;            //identificatore univoco dell'ordine
  final EthereumAddress? _buyer;           //indirizzo esadecimale del Buyer
  final EthereumAddress? _seller;          //indirizzo esadecimale del Seller
  OrderState? _state;         //stato nel quale si trova l'ordine attualmente
  String? _amount;            //quantità di stable coin legata all'ordine

  //costruttore di ordini non validi per casi di errore
  Order.invalid():_id=-1, _buyer=null, _seller=null;

  //costruttore in cui vengono forniti i valori delle variabili
  Order(this._id, this._buyer, this._seller, String state, this._amount){
    _state = OrderState.values[int.parse(state)];
  }

  //funzione che permette di costruire la stringa che semplifica la visualizzazione dell'indirizzo wallet del Buyer
  String getFormattedBuyer(){
    String buyer = _buyer.toString();
    return buyer.substring(0, 5) + "..." + buyer.substring(buyer.length - 5);
  }

  //funzione che permette di costruire la stringa che semplifica la visualizzazione dell'indirizzo wallet del Seller
  String getFormattedSeller(){
    String seller = _seller.toString();
    return seller.substring(0, 5) + "..." + seller.substring(seller.length - 5);
  }

  //l'id viene convertito in stringa per comodità
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