
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'stateContext.dart';
import 'order.dart';
import 'orderState.dart';

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
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<Order> orders = snapshot.data as List<Order>;
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
                    orders.forEach((element) => {
                          col.add(Row(
                            children: [
                              Container(
                                width: 40,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  element.getId(),
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white12,
                              ),
                              Container(
                                width: 120,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(element.getFormattedSeller(),
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white24,
                              ),
                              Container(
                                width: 80,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  element.getAmount(),
                                  textAlign: TextAlign.center,
                                ),
                                color: Colors.white12,
                              ),
                              Container(
                                width: 120,
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  EnumToString.convertToString(element.getState()),
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

  Future<List<Order>> _getOrders() async {
    List<dynamic> rawOrders =
        await stateContext.getState().getEscrow().getOrdersOfUser(EthereumAddress.fromHex(stateContext.getState().getAccount()));
    List<Order> orders = [];
    rawOrders.forEach((element) => {
      orders.add(
        Order(
          int.parse(element[0].toString()), 
          EthereumAddress.fromHex(element[1].toString()),
          EthereumAddress.fromHex(element[2].toString()),
          element[4].toString(),
          EtherAmount.fromUnitAndValue(EtherUnit.wei, element[3])
                          .getValueInUnit(EtherUnit.ether).toString()
          )
        )
    });
    return orders;
  }
}