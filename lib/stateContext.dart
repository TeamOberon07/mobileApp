import 'package:dart_web3/dart_web3.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class stateContext {
  static stateContext? _stateContext;       //istanza unica di stateContext
  String? _rpcUrl;                     //nodo della blockchain al quale vengono inviate le richieste per ottenere dati
  EthereumAddress? _contractAddr;           //indirizzo di deploy dello smart contract
  var _balance, _session, _account, _escrow, _credentials;
  Barcode? _result;                  //risultato della scansione QR code
  String? _barCodeResult;

  stateContext._internal() {
    _rpcUrl = 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
    _contractAddr =
        EthereumAddress.fromHex('0xCB99efB19481eF91F3296a6E6a61caA7F02Af65D');
    _barCodeResult = "";
  }

  static stateContext getState() {
    if (_stateContext == null) {
      //non è stata istanziata
      _stateContext = stateContext._internal();
    }
    //ritorna l'unica istanza
    return _stateContext!;
  }

  String getRpcUrl() {
    return _rpcUrl!;
  }

  EthereumAddress getContractAddr() {
    return _contractAddr!;
  }

  getBalance() {
    return _balance;
  }

  getSession() {
    return _session;
  }

  setSession(session) {
    _session = session;
  }

  getAccount() {
    return _account;
  }

  setAccount(account) {
    _account = account;
  }

  getEscrow() {
    return _escrow;
  }

  setEscrow(escrow) {
    _escrow = escrow; 
  }

  getCredentials() {
    return _credentials;
  }

  setCredentials(credentials) {
    _credentials = credentials;
  }

  Barcode? getResult() {
    return _result;
  }

  setResult(result) {
    _result = result;
  }

  String? getBarcodeResult() {
    return _barCodeResult;
  }

  setBarcodeResult(barCodeResult) {
    _barCodeResult = barCodeResult;
  }
}
