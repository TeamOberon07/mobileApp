import 'package:dart_web3/dart_web3.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class stateContext {
  static stateContext? _stateContext;
  String? _rpcUrl;
  EthereumAddress? _contractAddr;
  var _balance, _session, _account, _escrow, _credentials;
  Barcode? _result;
  String? _barCodeResult;

  stateContext._internal() {
    _rpcUrl = 'https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
    _contractAddr =
        EthereumAddress.fromHex('0x7419970Bb76dD5bB893666368923d24f43191E61');
    _barCodeResult = "";
  }

  static stateContext getState() {
    if (_stateContext == null) {
      _stateContext = stateContext._internal();
    }

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
