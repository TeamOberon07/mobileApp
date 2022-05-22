import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'MyHomePage.dart';
import 'stateContext.dart';
import 'order.dart';
import 'orderState.dart';
import 'log.dart';

class QROrderPage extends StatefulWidget {
  @override
  State<QROrderPage> createState() => _QROrderPageState();
}

class _QROrderPageState extends State<QROrderPage> {
  get mainAxisAlignment => null;

  //variabile contenente l'ordine che viene letto dal QR
  Order? order;

  @override
  Widget build(BuildContext context) {
    String QRresult = stateContext.getState().getBarcodeResult()!;
    String OrderBuyer = QRresult.split(":")[0];
    if (OrderBuyer.toLowerCase() !=
        stateContext.getState().getAccount().toString()) {
      //l'utente connesso al wallet non è il Buyer dell'ordine e viene presentato un errore di conseguenza
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/app-wallpaper1.png"),
                  fit: BoxFit.cover)),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.error),
                const Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
                    child: Text(
                        "Careful!!! The wallet your logged in with is not the buyer of this order.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(255, 0, 0, 100)))),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                      //bottone che permette di ritornare alla home page e riprovare lo scan
                      onPressed: () => {
                            stateContext.getState().setBarcodeResult(""),
                            makeRoutePage(
                                context, MyHomePage(title: "ShopChain Mobile"))
                          },
                      child: const Text("Go back to home page",
                          style: TextStyle(fontSize: 25))),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      );
    }
    //scansione avvenuta correttamente e Buyer combacia, si può procedere a presentare l'ordine
    //List orders = escrow.getOrdersOfUser();
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Order"),
          backgroundColor: Color.fromRGBO(0, 0, 255, 0.35),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/app-wallpaper1.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
              FutureBuilder(
                  //viene prelevato l'id dell'ordine e chiamata la funzione che ne ottiene i dati
                  future: _getOrder(int.parse(QRresult.split(":")[1])),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){
                      //l'app è ancore in attesa del risultato della chiamata asincrona che interroga lo smart contract e quindi
                      //presenta un indicatore di caricamento
                      return Center(child: CircularProgressIndicator());
                    }

                    //il risultato della funzione può essere castato come Order
                    order = snapshot.data as Order;

                    if (order!.getId() == "-1" || order == null) {
                      //in questi casi si è verificato un errore e perciò non è possibile mostrare i dettagli dell'ordine
                      return Center(
                          child: Text(
                              "There may have been an error while loading the order, please try again",
                              style: TextStyle(color: Colors.red)));
                    }

                    //l'ordine è stato ottenuto con successo
                    Icon stateIcon;
                    //viene selezionata un'icona in base all'ordine
                    switch (order!.getState()) {
                      case OrderState.Created:
                        stateIcon = const Icon(Icons.check_circle,
                            color: Colors.white, size: 50.0);
                        break;
                      case OrderState.Shipped:
                        stateIcon = const Icon(Icons.local_shipping,
                            color: Colors.white, size: 50.0);
                        break;
                      case OrderState.Confirmed:
                        stateIcon = const Icon(Icons.verified,
                            color: Colors.white, size: 50.0);
                        break;
                      case OrderState.Deleted:
                        stateIcon = const Icon(Icons.delete,
                            color: Colors.white, size: 50.0);
                        break;
                      case OrderState.Asked_Refund:
                        stateIcon = const Icon(Icons.assignment_return,
                            color: Colors.white, size: 50.0);
                        break;
                      case OrderState.Refunded:
                        stateIcon = const Icon(Icons.reply,
                            color: Colors.white, size: 50.0);
                        break;
                    }
                    return Column(
                      children: [
                        Padding(
                          child: Row(
                            children: [
                              Icon(Icons.tag, color: Colors.white, size: 50.0),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                              Text("Order ID: " + order!.getId(),
                                  style: TextStyle(fontSize: 22))
                            ],
                            //mainAxisAlignment: MainAxisAlignment.center
                          ),
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        ),
                        Padding(
                          child: Row(
                            children: [
                              Icon(Icons.person_outline_outlined,
                                  color: Colors.white, size: 50.0),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                              Text("Seller: " + order!.getFormattedSeller(),
                                  style: TextStyle(fontSize: 22))
                            ],
                            //mainAxisAlignment: MainAxisAlignment.center
                          ),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        ),
                        Padding(
                          child: Row(
                            children: [
                              Icon(Icons.person,
                                  color: Colors.white, size: 50.0),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                              Text("Buyer: " + order!.getFormattedBuyer(),
                                  style: TextStyle(fontSize: 22))
                            ],
                            //mainAxisAlignment: MainAxisAlignment.center
                          ),
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        ),
                        Padding(
                          child: Row(
                            children: [
                              Padding(
                                  child:
                                      Image.asset("assets/coin.png", scale: 5),
                                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                              Text("Amount: \$" + order!.getAmount(),
                                  style: TextStyle(fontSize: 22)),
                            ],
                            //mainAxisAlignment: MainAxisAlignment.center
                          ),
                          padding: EdgeInsets.fromLTRB(26, 20, 20, 0),
                        ),
                        Padding(
                          child: Row(
                            children: [
                              stateIcon,
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                              Text(
                                  //questa chimata permette di stampare i valori dell'enum OrderState come stringhe
                                  "State: " +
                                      EnumToString.convertToString(
                                              order!.getState())
                                          .replaceAll('_', ' '),
                                  style: const TextStyle(fontSize: 22))
                            ],
                            //mainAxisAlignment: MainAxisAlignment.center
                          ),
                          padding: const EdgeInsets.fromLTRB(22, 20, 20, 0),
                        ),
                        const SizedBox(height: 50),
                        //se l'ordine si trova in stato shipped, va data la possibilità di confermare la ricezione
                        (order!.getState() == OrderState.Shipped)
                            ? SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white12,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(
                                        fontSize: 22, fontFamily: 'Poppins'),
                                  ),
                                  onPressed: () async {
                                    _confirmOrder(order!.getId());
                                  },
                                  child: const Text("Confirm Order",
                                      style: TextStyle(fontSize: 22)),
                                ),
                                width: 200,
                                height: 75,
                              )
                            : const SizedBox(height: 0),
                        //in base allo stato è possibile presentare anche l'opzione richiesta reso
                        (order!.getState() == OrderState.Created ||
                                order!.getState() == OrderState.Shipped ||
                                order!.getState() == OrderState.Confirmed)
                            ? SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white12,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(
                                        fontSize: 22, fontFamily: 'Poppins'),
                                  ),
                                  onPressed: () async =>
                                      _askRefund(order!.getId()),
                                  child: const Text("Ask for Refund"),
                                ),
                                width: 200,
                                height: 75,
                              )
                            : const SizedBox(height: 0),
                        SizedBox(
                          height: 30,
                        ),
                        FutureBuilder(
                          //futureBuilder permette di attendere il risultato della chiamata dei log per poi presentarli all'utente
                            future: _getLog(order!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                    child: CircularProgressIndicator());

                              Log log = snapshot.data as Log;

                              return SingleChildScrollView(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: Column(children: log.getColumn()),
                              ));
                            }),
                      ],
                    );
                  })
            ],
          ),
        ));
  }

  //questa funzione costruisce la transazione di conferma ed avvia l'app MetaMask
  Future<void> _confirmOrder(String orderID) async {
    final transaction = Transaction(
      to: stateContext.getState().getContractAddr(),
      from: EthereumAddress.fromHex(stateContext.getState().getAccount()),
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
    );

    launch("https://metamask.app.link/");

    String returned = await stateContext.getState().getEscrow().confirmOrder(
        BigInt.parse(orderID),
        credentials: stateContext.getState().getCredentials(),
        transaction: transaction);
  }

  //questa funzione costruisce la transazione di richiesta reso ed avvia l'app MetaMask
  Future<void> _askRefund(String orderID) async {
    final transaction = Transaction(
      to: stateContext.getState().getContractAddr(),
      from: EthereumAddress.fromHex(stateContext.getState().getAccount()),
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
    );

    launch("https://metamask.app.link/");

    String returned = await stateContext.getState().getEscrow().askRefund(
        BigInt.parse(orderID),
        credentials: stateContext.getState().getCredentials(),
        transaction: transaction);
  }

  //chiamata allo smart contract che richiede i dati di uno specifico ordine per poi inserirli in un'istanza della classe Order.dart
  Future<Order> _getOrder(int id) async {
    try {
      dynamic thisOrder =
          await stateContext.getState().getEscrow().getOrder(BigInt.from(id));
      Order order = Order(
          id,
          EthereumAddress.fromHex(thisOrder[1].toString()),
          EthereumAddress.fromHex(thisOrder[2].toString()),
          thisOrder[4].toString(),
          EtherAmount.fromUnitAndValue(EtherUnit.wei, thisOrder[3])
              .getValueInUnit(EtherUnit.ether)
              .toString());
      return order;
    } catch (e) {
      print(e);
      return Order.invalid();
    }
  }

  //chiamata allo smart contract che richiede i log di uno specifico ordine per poi inserirli in un'istanza della classe Log.dart
  Future<Log> _getLog(Order order) async {
    List<dynamic> rawLog = await stateContext
        .getState()
        .getEscrow()
        .getLogsOfOrder(BigInt.from(int.parse(order.getId())));
    Log log = Log();
    rawLog.forEach((element) {
      log.addElement(element);
    });
    return log;
  }

  void makeRoutePage(BuildContext context, Widget pageRef) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pageRef),
        (Route<dynamic> route) => false);
  }
}
