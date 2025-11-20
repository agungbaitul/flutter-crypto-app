import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'crypto_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CryptoScreen());
  }
}

class CryptoScreen extends StatefulWidget {
  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  List<Crypto> cryptos = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'];
      setState(() {
        cryptos = list.map((e) => Crypto.fromJson(e)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto List')),
      body: cryptos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                final crypto = cryptos[index];
                return ListTile(
                  leading: Text('#${crypto.rank}'),
                  title: Text(crypto.name),
                  subtitle: Text(crypto.symbol),
                  trailing: Text('\$${crypto.priceUsd}'),
                );
              },
            ),
    );
  }
}