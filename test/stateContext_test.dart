import 'dart:developer';
import 'package:dart_web3/credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/stateContext.dart';

void main() {
  test('State context funzionamento', (){

    var state = stateContext.getState();

    state.setAccount(null);
    state.setBarcodeResult("");
    state.setCredentials(null);
    state.setEscrow(null);
    state.setResult(null);
    state.setSession(null);

    expect(state.getRpcUrl(), 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161');
    expect(state.getContractAddr(), EthereumAddress.fromHex('0xCB99efB19481eF91F3296a6E6a61caA7F02Af65D'));
    expect(state.getBarcodeResult(), "");
    expect(state.getAccount(), null);
    expect(state.getBalance(), null);
    expect(state.getCredentials(), null);
    expect(state.getEscrow(), null);
    expect(state.getSession(), null);
    expect(state.getResult(), null);
  });
}