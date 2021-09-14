import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:nash_dashboard/views/token/token_view.dart';
import 'package:nash_dashboard/widgets/appbar_widget.dart';
import 'package:nash_dashboard/widgets/bottomBar_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(home: Main()),
  );
}

class Main extends StatefulWidget {
  static _MainState _state = _MainState();
  static Widget _currentPage;
  static String _pageTitle = "Home";
  static Map<int, Color> color = {
    50: Color.fromRGBO(0, 82, 243, 0.1),
    100: Color.fromRGBO(0, 82, 243, 0.2),
    200: Color.fromRGBO(0, 82, 243, 0.3),
    300: Color.fromRGBO(0, 82, 243, 0.4),
    400: Color.fromRGBO(0, 82, 243, 0.5),
    500: Color.fromRGBO(0, 82, 243, 0.6),
    600: Color.fromRGBO(0, 82, 243, 0.7),
    700: Color.fromRGBO(0, 82, 243, 0.8),
    800: Color.fromRGBO(0, 82, 243, 0.9),
    900: Color.fromRGBO(0, 82, 243, 1),
  };

  // COINGECKO
  static DocumentSnapshot nexStatsCoingecko;
  static DocumentSnapshot exchangeData;
  static DocumentSnapshot tokens;
  // CMC
  static DocumentSnapshot nexStatsCMC;
  // NEOSCAN
  static DocumentSnapshot nashStakingContract;
  static QuerySnapshot nashStakingTransactions;
  static DocumentSnapshot topStakers;
  // ETHPLORER
  static QuerySnapshot nashEarningsContract;
  // NASH
  static QuerySnapshot nashEarningsStats;
  static DocumentSnapshot nashL2Stats;
  static DocumentSnapshot nashFiatRampStats;
  static DocumentSnapshot nashEarningsAPYOverTime;
  static DocumentSnapshot earningsContractSizeOverTime;
  // AAVE
  static DocumentSnapshot aavePools;
  // DORA
  static DocumentSnapshot nexStakingHistory;
  // TOKOK
  static DocumentSnapshot nexStatsTokok;
  // UNISWAP
  static DocumentSnapshot nexStatsUniswap;
  // SWITCHEO
  static DocumentSnapshot nexStatsSwitcheo;

  static void setCurrentPage(Widget page, String title) {
    _state.setState(() {
      _currentPage = page;
      _pageTitle = title;
    });
  }

  static pullReferesh() {
    print("refreshed");
  }

  @override
  _MainState createState() => _state;
}

class _MainState extends State<Main> {
  bool loadedData = false;

  Future loadData() async {
    // COINGECKO
    Main.nexStatsCoingecko = await FirebaseFirestore.instance
        .collection('coingecko_coins_tokens')
        .doc("neon-exchange")
        .get();
    Main.exchangeData = await FirebaseFirestore.instance
        .collection('coingecko')
        .doc("exchangeData")
        .get();
    Main.tokens = await FirebaseFirestore.instance
        .collection('coingecko_coins_tokens_simple')
        .doc("selectedListOfTokens")
        .get();

    // CMC
    Main.nexStatsCMC = await FirebaseFirestore.instance
        .collection('cmc')
        .doc("nexStats")
        .get();

    // AAVE
    Main.aavePools = await FirebaseFirestore.instance
        .collection('aave')
        .doc("aaveTokenStats")
        .get();

    // ETHPLORER
    Main.nashEarningsContract = await FirebaseFirestore.instance
        .collection('ethplorer_nexEarningsContract')
        .orderBy("contractInfo.timestamp", descending: true)
        .limit(1)
        .get();

    // NASH
    Main.nashEarningsStats = await FirebaseFirestore.instance
        .collection('nash_earnings_apy_over_time')
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();
    Main.nashL2Stats = await FirebaseFirestore.instance
        .collection('nash')
        .doc("L2_ExchangeStats")
        .get();
    Main.nashFiatRampStats = await FirebaseFirestore.instance
        .collection('nash')
        .doc("FiatRampStats")
        .get();
    Main.nashEarningsAPYOverTime = await FirebaseFirestore.instance
        .collection('nash')
        .doc("nashEarningsAPYOverTime")
        .get();
    Main.earningsContractSizeOverTime = await FirebaseFirestore.instance
        .collection('nash')
        .doc("earningsContractSizeOverTime")
        .get();

    // NEOSCAN
    Main.nashStakingTransactions = await FirebaseFirestore.instance
        .collection('nex_staking_transactions')
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    Main.nashStakingContract = await FirebaseFirestore.instance
        .collection('neoscan')
        .doc("Nash_staking_addresse_balance")
        .get();

    Main.topStakers = await FirebaseFirestore.instance
        .collection('nex_top_stakers')
        .doc("topStakersAll")
        .get();

    // DORA
    Main.nexStakingHistory = await FirebaseFirestore.instance
        .collection('dora')
        .doc("nexStakingHistory")
        .get();

    // TOKOK
    Main.nexStatsTokok = await FirebaseFirestore.instance
        .collection('tokok')
        .doc("nexStats")
        .get();

    // UNISWAP
    Main.nexStatsUniswap = await FirebaseFirestore.instance
        .collection('uniswap')
        .doc("nashStats")
        .get();

    setState(() {
      Main._currentPage = TokenView();
      Main._pageTitle = "Token";
      loadedData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadedData) {
      return _appWidget();
    } else {
      loadData();
      return _loadingDataWidget();
    }
  }

  Widget _appWidget() {
    return MaterialApp(
        title: 'Nash Dashboard',
        theme: ThemeData(
            fontFamily: 'Montserrat',
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: MaterialColor(0xFF0052f3, Main.color)),
        home: Container(
          color: Colors.grey[50],
          child: Center(
            child: Container(
              width: kIsWeb ? 1000 : MediaQuery.of(context).size.width,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: AppBarWidget(
                    Main._pageTitle,
                    backgroundColor: Colors.grey[50],
                    foregroundColor: Main.color[900],
                    elevation: 0,
                    toolbarHeight: 60,
                  ),
                ),
                body: Container(
                  child: Main._currentPage,
                ),
                bottomNavigationBar: BottomBarWidget(),
              ),
            ),
          ),
        ));
  }

  Widget _loadingDataWidget() {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Montserrat',
          primarySwatch: MaterialColor(0xFF0052f3, Main.color)),
      home: Container(
          color: Colors.white,
          child: Center(
              child: Container(
                  height: 300,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "NashDash",
                            style: TextStyle(
                                fontSize: 40,
                                color: Main.color[900],
                                decoration: TextDecoration.none),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 50),
                            child: Text(
                              "A dashboard for the Nash app",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Main.color[900],
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(60),
                        child: Container(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            strokeWidth: 7,
                            color: Main.color[900],
                          ),
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
