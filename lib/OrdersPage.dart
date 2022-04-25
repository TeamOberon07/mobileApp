
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dart_web3/dart_web3.dart';
import 'stateContext.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/app-wallpaper1.png"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: _getOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    dynamic orders = snapshot.data;
                    List<Row> col = [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "ID",
                              style: TextStyle(fontSize: 23),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white24,
                          ),
                          Container(
                            width: 120,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "Seller",
                              style: TextStyle(fontSize: 23),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white12,
                          ),
                          Container(
                            width: 80,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "Amnt",
                              style: TextStyle(fontSize: 23),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white24,
                          ),
                          Container(
                            width: 120,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              "State",
                              style: TextStyle(fontSize: 23),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white12,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ];
                    String seller = "";
                    String amount = "";
                    String state = "";
                    Set<String> states = {
                      "Created",
                      "Confirmed",
                      "Deleted",
                      "Asked Refund",
                      "Refunded"
                    };
                    orders.forEach((element) => {
                          seller = element[2].toString(),
                          amount = EtherAmount.fromUnitAndValue(
                                  EtherUnit.wei, element[3])
                              .getValueInUnit(EtherUnit.ether)
                              .toString(),
                          state = states
                              .elementAt(int.parse(element[4].toString())),
                          col.add(Row(
                            children: [
                              Container(
                                width: 40,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  element[0].toString(),
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white12,
                              ),
                              Container(
                                width: 120,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  seller.substring(0, 5) +
                                      "..." +
                                      seller.substring(seller.length - 5),
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white24,
                              ),
                              Container(
                                width: 80,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  amount,
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white12,
                              ),
                              Container(
                                width: 120,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  state,
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white24,
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ))
                        });
                    return Column(children: col);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _getOrders() async {
    List<dynamic> orders =
        await escrow.getOrdersOfUser(EthereumAddress.fromHex(account));
    return orders;
  }
}