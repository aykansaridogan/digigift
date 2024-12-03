
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

String google_api_key = "goog_FIOSYCinbeNZasEyQdtHQXXkZZw";

class Products {
  static const idStandart = "sarki_999_standart";
  static const idPremium = "sarki_1999_premium";
  static const idPremiumPlus = "sarki_5999_premiumplus";

  static const allIds = [idStandart, idPremium, idPremiumPlus];
}

class PurchaseApi {
  static const _apiKey = "";

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException {
      return [];
    }
  }
}
