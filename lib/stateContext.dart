import 'package:dart_web3/dart_web3.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class stateContext{
   static stateContext? _stateContext;
    String? _rpcUrl;
    EthereumAddress? _contractAddr;
    var _balance, _session, _account, _escrow, _credentials;
    Barcode? _result;
    String? _barCodeResult;

    stateContext._internal(){
     _rpcUrl = 'https://api.avax-test.network/ext/bc/C/rpc';
    _contractAddr =
    EthereumAddress.fromHex('0x1648471B1b56bd703de37216Aa298077628Dcf27');
     _barCodeResult = "";
  }

  static stateContext getState(){
    if(_stateContext == null){
      _stateContext = stateContext._internal();
    }

    return _stateContext!;
  }

  String getRpcUrl(){
    return _rpcUrl!;
  }

  EthereumAddress getContractAddr(){
    return _contractAddr!;
  }

  getBalance(){
    return _balance;
  }

  getSession(){
    return _session;
  }

  setSession(session){
    _session = session;
  }

  getAccount(){
    return _account;
  }

  setAccount(account){
    _account = account;
  }

  getEscrow(){
    return _escrow;
  }

  setEscrow(escrow){
    _escrow = escrow;
  }

  getCredentials(){
    return _credentials;
  }

  setCredentials(credentials){
    credentials = _credentials;
  }

  Barcode getResult(){
    return _result!;
  }

  setResult(result){
    _result = result;
  }
  
  String getBarcodeResult(){
    return _barCodeResult!;
  }

  setBarcodeResult(barCodeResult){
    _barCodeResult = barCodeResult;
  }
  
}
