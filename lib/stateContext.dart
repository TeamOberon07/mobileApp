import 'package:dart_web3/dart_web3.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const String rpcUrl = 'https://api.avax-test.network/ext/bc/C/rpc';
final EthereumAddress contractAddr =
    EthereumAddress.fromHex('0x1648471B1b56bd703de37216Aa298077628Dcf27');
var balance, session, account, escrow, credentials;
Barcode? result;
String barCodeResult = "";