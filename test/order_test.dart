import 'package:dart_web3/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/order.dart';
import 'package:mobile_app_poc/orderState.dart';

void main() {
  test('order funzionamento', (){

    Order orderNonValido = Order.invalid();
    Order order = Order(1,EthereumAddress.fromHex('0xCB99efB19481eF91F3296a6E6a61caA7F02Af65D'),EthereumAddress.fromHex('0xCB99efB19481eF91F3296a6E6a61caA7F02Af65D'),"0","12");

    expect(orderNonValido.getId(), "-1");

    expect(order.getId(), "1");
    expect(order.getFormattedBuyer(), "0xcb9...af65d");
    expect(order.getFormattedSeller(), "0xcb9...af65d");
    expect(order.getState(), OrderState.Created);
    expect(order.getAmount(), "12");
  });
}