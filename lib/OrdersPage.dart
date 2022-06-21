import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'stateContext.dart';
import 'order.dart';

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
          child: ListView(children: [
          FutureBuilder(
              //futureBuilder si mette in attesa della risposta della funzione asincrona getOrders
              future: getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //la funzione non ha ancora completato il suo corso e perciò va indicato il caricamento
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Center(child: CircularProgressIndicator())]);
                }

                //il risultato è castabile come List<Order>
                List<Order> orders = snapshot.data as List<Order>;

                //inizializzazione della riga di intestazione
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
                //per ogni ordine viene creata la riga che lo rappresenta ed aggiunta alla lista di righe della tabella
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
                            child: Text(
                              element.getFormattedSeller(),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white24,
                          ),
                          Container(
                            width: 80,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              element.getAmount() + "\$",
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white12,
                          ),
                          Container(
                            width: 120,
                            height: 50,
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              EnumToString.convertToString(element.getState()).replaceAll('_', ' '),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.white24,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                    });
                return Column(children: [
                  SizedBox(height: 20),
                  SingleChildScrollView(child: (Column(children: col)))
                ]);
              })],)),
    );
  }

  //funzione asincrona il cui scopo consiste nell'ottenere la lista degli ordini di cui il wallet loggato è il Buyer
  Future<List<Order>> getOrders({bool jump = false}) async {
    try {
      List<dynamic> rawOrders = 
      [[BigInt.from(12), 
      "0xe5b197d91ad002a18917ab4fdc6b6e0126797482",
      "0xe5b197d91ad002a18917ab4fdc6b6e0126797482",
      BigInt.from(1),
      "Created"]];

      if(!jump){
        rawOrders= await stateContext
        .getState()
        .getEscrow()
        .getOrdersOfUser(
        EthereumAddress.fromHex(stateContext.getState().getAccount()));
      }
      List<Order> orders = [];

      //gli ordini ottenuti dallo smart contract vengono convertiti in Order.dart
      rawOrders.forEach((element) => {
            orders.add(Order(
                int.parse(element[0].toString()),
                EthereumAddress.fromHex(element[1].toString()),
                EthereumAddress.fromHex(element[2].toString()),
                element[4].toString(),
                EtherAmount.fromUnitAndValue(EtherUnit.wei, element[3])
                    .getValueInUnit(EtherUnit.ether)
                    .toString()))
          });
      return orders;
    } catch (e) {
      if (e is SocketException) {
        if (e.message == "Connection timed out") {
          print("error Message: Connection timed out");
        }
      }
      print("error SocketException");
      print(e);
      return [];
    }
  }
}
