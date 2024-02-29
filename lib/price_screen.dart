import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, Map<String, String>> currencyData = {};
  String selectedCurrency = 'CAD';
  String baseCurrency = 'BTC';
  String currencyFromList = currenciesList[0];

  choosePicker() {
    if (Platform.isIOS) {
      return populateCupertino(currenciesList);
    } else {
      return populateAndroid(currenciesList);
    }
  }

  populateAndroid(currencyList) {
    List<DropdownMenuItem<String>> dropdownListOfItems = [];

    for (String currency in currencyList) {
      dropdownListOfItems.add(DropdownMenuItem(
        value: currency,
        child: Text(currency),
      ));
    }

    return DropdownButton<String>(
      value: currencyFromList,
      items: dropdownListOfItems,
      onChanged: (value) {
        setState(() {
          currencyFromList = value!;
          for (String currency in ['BTC','ETH','LTC']) {
            getRate(currency, currencyFromList);
          }
        });
      },
    );
  }

  populateCupertino(currencyList) {
    List<Text> dropdownListOfItems = [];

    for (String currency in currencyList) {
      dropdownListOfItems.add(Text(currency));
    }

    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (int value) {},
        children: dropdownListOfItems);
  }

  @override
  void initState() {
    super.initState();
    for (String currency in ['BTC','ETH','LTC']) {
      getRate(currency, currencyFromList);
    }
  }

  void getRate(String baseCurrency, String selectedCurrency) async {
    var coinData =
        await CoinData().getExchangeRate(baseCurrency, selectedCurrency);
    updateUI(baseCurrency, coinData);
  }

  void updateUI(String baseCurrency, dynamic coinData) {
    setState(() {
      if (coinData == null) {
        currencyData[baseCurrency] = {
          'currencyQuote' : 'Error',
          'exchangeRate' : 'Error',
        };
        return;
      } else {
        currencyData[baseCurrency] = {
          'exchangeRate' : coinData['rate'].toStringAsFixed(2),
          'currencyQuote' : coinData['asset_id_quote'].toString(),
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (String currency in ['BTC', 'ETH', 'LTC'])
            Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Text(
                    "1 $currency = ${currencyData[currency]?['exchangeRate']} ${currencyData[currency]?['currencyQuote']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

        ],
      ),
      bottomNavigationBar: Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: choosePicker(),
      ),
    );
  }
}
