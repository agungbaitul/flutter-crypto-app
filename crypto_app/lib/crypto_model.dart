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