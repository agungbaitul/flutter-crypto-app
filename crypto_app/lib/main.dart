import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model
class Crypto {
  final int rank;
  final String name;
  final String symbol;
  final String priceUsd;

  Crypto({
    required this.rank,
    required this.name,
    required this.symbol,
    required this.priceUsd,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      rank: json['rank'],
      name: json['name'],
      symbol: json['symbol'],
      priceUsd: json['price_usd'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto List',
      home: CryptoScreen(),
    );
  }
}

class CryptoScreen extends StatefulWidget {
  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  // ✅ Dummy data agar UI langsung tampil
  List<Crypto> cryptos = [
    Crypto(rank: 1, name: 'Bitcoin', symbol: 'BTC', priceUsd: '50000'),
    Crypto(rank: 2, name: 'Ethereum', symbol: 'ETH', priceUsd: '4000'),
    Crypto(rank: 3, name: 'Cardano', symbol: 'ADA', priceUsd: '2.1'),
  ];

  Future<void> fetchData() async {
    print('Fetching data from API...');
    try {
      final response = await http.get(
        Uri.parse('https://api.coinlore.net/api/tickers/'),
        headers: {'Access-Control-Allow-Origin': '*'}, // CORS workaround
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'];
        print('Data length: ${list.length}');

        setState(() {
          cryptos = list.map((e) => Crypto.fromJson(e)).toList();
          print('setState called! cryptos updated: ${cryptos.length}');
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called! Starting fetchData...');
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print('Building UI... cryptos length: ${cryptos.length}');
    return Scaffold(
      appBar: AppBar(title: Text('Crypto List')),
      body: ListView.builder(
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