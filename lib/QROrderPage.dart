import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:url_launcher/url_launcher.dart';


import 'MyHomePage.dart';
import 'stateContext.dart';

class QROrderPage extends StatefulWidget {
  @override
  State<QROrderPage> createState() => _QROrderPageState();
}

class _QROrderPageState extends State<QROrderPage> {
  get mainAxisAlignment => null;

  @override
  Widget build(BuildContext context) {
    String QRresult = barCodeResult;
    String OrderBuyer = QRresult.split(":")[0];

    if (OrderBuyer != account) {
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
                      onPressed: () => {
                            barCodeResult = "",
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

    //List orders = escrow.getOrdersOfUser();
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Order"),
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
                  future: _getOrder(int.parse(QRresult.split(":")[1])),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    dynamic order = snapshot.data;
                    String seller = order[2].toString();
                    seller = seller.substring(0, 5) +
                        " ... " +
                        seller.substring(seller.length - 5);
                    String buyer = order[1].toString();
                    buyer = buyer.substring(0, 5) +
                        " ... " +
                        buyer.substring(buyer.length - 5);
                    String orderID = order[0].toString();
                    String amount =
                        EtherAmount.fromUnitAndValue(EtherUnit.wei, order[3])
                            .getValueInUnit(EtherUnit.ether)
                            .toString();
                    String state = "";
                    Icon stateIcon;
                    switch (order[4].toString()) {
                      case "0":
                        state = "Created";
                        stateIcon = Icon(Icons.check_circle,
                            color: Colors.white, size: 50.0);
                        break;
                      case "1":
                        state = "Confirmed";
                        stateIcon = Icon(Icons.verified,
                            color: Colors.white, size: 50.0);
                        break;
                      case "2":
                        state = "Deleted";
                        stateIcon =
                            Icon(Icons.delete, color: Colors.white, size: 50.0);
                        break;
                      case "3":
                        state = "Asked Refund";
                        stateIcon = Icon(Icons.assignment_return,
                            color: Colors.white, size: 50.0);
                        break;
                      case "4":
                        state = "Refunded";
                        stateIcon =
                            Icon(Icons.reply, color: Colors.white, size: 50.0);
                        break;
                      default:
                        state = "Unknown State";
                        stateIcon =
                            Icon(Icons.error, color: Colors.white, size: 50.0);
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
                              Text("Order ID: $orderID",
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
                              Text("Seller: $seller",
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
                              Text("Buyer: $buyer",
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
                                  child: Image.asset("assets/LogoAvaxMin.png",
                                      scale: 5),
                                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0)),
                              Text("Amount: $amount",
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
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                              Text("State: $state",
                                  style: TextStyle(fontSize: 22))
                            ],
                            //mainAxisAlignment: MainAxisAlignment.center
                          ),
                          padding: EdgeInsets.fromLTRB(22, 20, 20, 0),
                        ),
                        SizedBox(height: 50),
                        (state == "Created")
                            ? SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white12,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(
                                        fontSize: 22, fontFamily: 'Poppins'),
                                  ),
                                  onPressed: () async => _confirmOrder(orderID),
                                  child: Text("Confirm Order",
                                      style: TextStyle(fontSize: 22)),
                                ),
                                width: 200,
                                height: 75,
                              )
                            : SizedBox(height: 0),
                        (state == "Confirmed")
                            ? SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white12,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(
                                        fontSize: 22, fontFamily: 'Poppins'),
                                  ),
                                  onPressed: () async => _askRefund(orderID),
                                  child: Text("Ask for Refund"),
                                ),
                                width: 200,
                                height: 75,
                              )
                            : SizedBox(height: 0),
                      ],
                    );
                  })
            ],
          ),
        ));
  }

  Future<void> _confirmOrder(String orderID) async {
    final transaction = Transaction(
      to: contractAddr,
      from: EthereumAddress.fromHex(account),
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
    );

    launch("https://metamask.app.link/");

    String returned = await escrow.confirmOrder(BigInt.parse(orderID),
        credentials: credentials, transaction: transaction);
  }

  Future<void> _askRefund(String orderID) async {
    final transaction = Transaction(
      to: contractAddr,
      from: EthereumAddress.fromHex(account),
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, 0),
    );

    launch("https://metamask.app.link/");

    String returned = await escrow.askRefund(BigInt.parse(orderID),
        credentials: credentials, transaction: transaction);
  }

  Future<dynamic> _getOrder(int id) async {
    List<dynamic> orders =
        await escrow.getOrdersOfUser(EthereumAddress.fromHex(account));
    dynamic thisOrder;
    orders.forEach((element) => {
          if ((element[0]).toString() == id.toString()) {thisOrder = element}
        });
    return thisOrder;
    //return orders.where((element) => element[0] == id);
  }

  void makeRoutePage(BuildContext context, Widget pageRef) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pageRef),
        (Route<dynamic> route) => false);
  }
}