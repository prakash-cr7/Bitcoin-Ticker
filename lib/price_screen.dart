import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

const apiKey = '736CC145-02DA-4E8A-813F-40E498CF67E9';
String url =
    'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=736CC145-02DA-4E8A-813F-40E498CF67E9';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> dropDownList = [];
    for (String currency in currenciesList) {
      var newitem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownList.add(newitem);
    }
    return DropdownButton<String>(
        // focusColor: Color(0xFF000000),
        elevation: 20,
        disabledHint: Text(
          'USD',
        ),
        hint: Text(selectedCurrency, style: TextStyle(color: Colors.white)),
        items: dropDownList,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
          });
          getDataForAll();
        });
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerMenu = [];
    for (String currency in currenciesList) {
      pickerMenu.add(Text(
        currency,
        style: TextStyle(color: Colors.white),
      ));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      children: pickerMenu,
      onSelectedItemChanged: (value) {
        selectedCurrency = pickerMenu[value].data;
        print(selectedCurrency);
        getDataForAll();
      },
    );
  }

  Future<String> getData(String currency, String cryptoCurrency) async {
    var decodedData = await CoinData(
            url:
                'https://rest.coinapi.io/v1/exchangerate/$cryptoCurrency/$currency?apikey=736CC145-02DA-4E8A-813F-40E498CF67E9')
        .getDecodedData();
    return decodedData['rate'].toStringAsFixed(0);
  }

  String ETHrate;
  String BTCrate;
  String LTCrate;

  void getDataForAll() async {
    var tempETHrate = await getData(selectedCurrency, 'ETH');
    var tempBTCrate = await getData(selectedCurrency, 'BTC');
    var tempLTCrate = await getData(selectedCurrency, 'LTC');
    setState(() {
      ETHrate = tempETHrate;
      BTCrate = tempBTCrate;
      LTCrate = tempLTCrate;
    });
  }

  @override
  void initState() {
    getDataForAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CardTile(
                currency: selectedCurrency,
                cryptoCurrency: 'BTC',
                rate: BTCrate,
              ),
              CardTile(
                currency: selectedCurrency,
                cryptoCurrency: 'ETH',
                rate: ETHrate,
              ),
              CardTile(
                currency: selectedCurrency,
                cryptoCurrency: 'LTC',
                rate: LTCrate,
              ),

            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}

class CardTile extends StatelessWidget {
  CardTile({this.currency, this.cryptoCurrency, this.rate});

  final String cryptoCurrency;
  final String currency;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $rate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
