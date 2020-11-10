import 'dart:convert';

import 'package:oxen_wallet/src/domain/common/crypto_currency.dart';
import 'package:oxen_wallet/src/domain/common/currency_formatter.dart';
import 'package:oxen_wallet/src/domain/common/fiat_currency.dart';
import 'package:http/http.dart';

// TODO: USE COINMARKETCAP-PIPE
const fiatApiAuthority = 'fiat-api.cakewallet.com';
const fiatApiPath = '/v1/rates';

Future<double> fetchPriceFor({CryptoCurrency crypto, FiatCurrency fiat}) async {
  var price = 0.0;

  try {
    final fiatStringed = fiat.toString();
    final uri =
        Uri.https(fiatApiAuthority, fiatApiPath, {'convert': fiatStringed});
    final response = await get(uri.toString());

    if (response.statusCode != 200) {
      return 0.0;
    }

    final responseJSON = json.decode(response.body) as Map<String, dynamic>;
    final data = responseJSON['data'] as List<dynamic>;

    for (final item in data) {
      if (item['symbol'] == cryptoToString(crypto)) {
        price = item['quote'][fiatStringed]['price'] as double;
        break;
      }
    }

    return price;
  } catch (e) {
    return price;
  }
}
