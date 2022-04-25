import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher.dart';

import 'escrow.g.dart';
import 'EthereumCredentials.dart';
import 'OrdersPage.dart';
import 'QRScanPage.dart';
import 'stateContext.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView( child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/app-wallpaper1.png"),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Center(
              child: Column(children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue.shade900,
                  Colors.red.shade700,
                ],
              )),
              child: Center(
                child: Text(
                  "ShopChain",
                  style: TextStyle(fontSize: 30.0, fontFamily: 'Poppins'),
                ),
              ),
            ),
            _getButtons(),
          ])),
        ),
      ),
    ));
  }

  _walletConnect() async {
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );
    // Subscribe to events
    connector.on('connect', (session) => print(session));
    connector.on('session_update', (payload) => print(payload));
    connector.on('disconnect', (session) => print(session));

    // Create a new session
    if (!connector.connected) {
      session = await connector.createSession(
          chainId: 43113,
          onDisplayUri: (uri) async => {print(uri), await launch(uri)});
    }

    setState(() {
      account = session.accounts[0];
    });
    if (account != null) {
      final client = Web3Client(rpcUrl, Client());
      EthereumWalletConnectProvider provider =
          EthereumWalletConnectProvider(connector);
      credentials = WalletConnectEthereumCredentials(provider: provider);
      escrow = Escrow(address: contractAddr, client: client);
    }
  }

  Column _getButtons() {
    if (account != null) {
      return Column(children: [
        SizedBox(
            height: 400,
            width: 400,
            child: Image.asset("assets/LogoShopChainTest5.png", scale: 2.25)),
        Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
            child: Text(
              "Please select an option",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white12,
                  padding: const EdgeInsets.all(16.0),
                  textStyle:
                      const TextStyle(fontSize: 22, fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  Navigator.of(context).push(_createRoute1());
                },
                child: Text("Scan QR", style: TextStyle(fontSize: 20)),
              ),
              width: 140,
              height: 80,
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white12,
                  padding: const EdgeInsets.all(16.0),
                  textStyle:
                      const TextStyle(fontSize: 22, fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  Navigator.of(context).push(_createRoute3());
                },
                child: Text("Orders", style: TextStyle(fontSize: 20)),
              ),
              width: 140,
              height: 80,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ]);
    }
    return Column(children: [
      SizedBox(
          height: 400,
          width: 400,
          child: Image.asset(
            "assets/LogoShopChainTest5.png",
            scale: 2.0,
            color: Colors.white.withOpacity(0.25),
            colorBlendMode: BlendMode.modulate,
          )),
      Padding(
          padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
          child: Text(
            "Welcome to ShopChain, please connect your wallet",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
      SizedBox(
        height: 30,
      ),
      Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white12,
              padding: const EdgeInsets.all(16.0),
              textStyle: const TextStyle(fontSize: 22, fontFamily: 'Poppins'),
            ),
            onPressed: () async => _walletConnect(),
            child: const Text('Connect Wallet'),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      )
    ]);
  }

  Route _createRoute1() {
    // reset QRCode scan results
    result = null;
    barCodeResult = "";

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const QRScanPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Route _createRoute3() {
    // reset QRCode scan results
    result = null;
    barCodeResult = "";

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => OrdersPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}