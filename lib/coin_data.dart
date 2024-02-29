import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker_flutter/services/networking.dart';

const apiKey = '';
const restCoinURL = 'https://rest.coinapi.io/v1/exchangerate/';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  Future<dynamic> getExchangeRate(String baseCurrency, String quoteCurrency) async {
    NetworkHelper networkHelper = NetworkHelper('$restCoinURL$baseCurrency/$quoteCurrency/?apikey=$apiKey');

    var currencyData = await networkHelper.getData();
    print(currencyData);

    return currencyData;
  }
}
