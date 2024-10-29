import 'dart:convert';

class CardsList {
  String object;
  int totalCards;
  bool hasMore;
  List<Card> data;

  CardsList({
    required this.object,
    required this.totalCards,
    required this.hasMore,
    required this.data,
  });

  factory CardsList.fromRawJson(String str) =>
      CardsList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardsList.fromJson(Map<String, dynamic> json) => CardsList(
        object: json["object"],
        totalCards: json["total_cards"],
        hasMore: json["has_more"],
        data: List<Card>.from(json["data"].map((x) => Card.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "total_cards": totalCards,
        "has_more": hasMore,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CardQuantity {
  Card? card;
  int quantity;

  CardQuantity({
    this.card,
    required this.quantity,
  });

  factory CardQuantity.fromRawJson(String str) =>
      CardQuantity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardQuantity.fromJson(Map<String, dynamic> json) => CardQuantity(
        card: Card.fromJson(json["card"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "card": card?.toJson(),
        "quantity": quantity,
      };
}

class Card {
  String object;
  String id;
  String oracleId;
  List<int> multiverseIds;
  String name;
  String printedName;
  String lang;
  DateTime releasedAt;
  String uri;
  String scryfallUri;
  String layout;
  bool highresImage;
  String imageStatus;
  ImageUris imageUris;
  String manaCost;
  double cmc;
  String typeLine;
  String oracleText;
  List<String> colors;
  List<String> colorIdentity;
  List<dynamic> keywords;
  Legalities legalities;
  List<String> games;
  bool reserved;
  bool foil;
  bool nonfoil;
  List<String> finishes;
  bool oversized;
  bool promo;
  bool reprint;
  bool variation;
  String setId;
  String CardSet;
  String setName;
  String setType;
  String setUri;
  String setSearchUri;
  String scryfallSetUri;
  String rulingsUri;
  String printsSearchUri;
  String collectorNumber;
  bool digital;
  String rarity;
  String cardBackId;
  String artist;
  List<String> artistIds;
  String illustrationId;
  String borderColor;
  String frame;
  bool fullArt;
  bool textless;
  bool booster;
  bool storySpotlight;
  int edhrecRank;
  Prices prices;
  RelatedUris relatedUris;
  PurchaseUris purchaseUris;
  int? pennyRank;
  String? printedTypeLine;
  String? printedText;
  String? flavorText;

  Card({
    required this.object,
    required this.id,
    required this.oracleId,
    required this.multiverseIds,
    required this.name,
    required this.printedName,
    required this.lang,
    required this.releasedAt,
    required this.uri,
    required this.scryfallUri,
    required this.layout,
    required this.highresImage,
    required this.imageStatus,
    required this.imageUris,
    required this.manaCost,
    required this.cmc,
    required this.typeLine,
    required this.oracleText,
    required this.colors,
    required this.colorIdentity,
    required this.keywords,
    required this.legalities,
    required this.games,
    required this.reserved,
    required this.foil,
    required this.nonfoil,
    required this.finishes,
    required this.oversized,
    required this.promo,
    required this.reprint,
    required this.variation,
    required this.setId,
    required this.CardSet,
    required this.setName,
    required this.setType,
    required this.setUri,
    required this.setSearchUri,
    required this.scryfallSetUri,
    required this.rulingsUri,
    required this.printsSearchUri,
    required this.collectorNumber,
    required this.digital,
    required this.rarity,
    required this.cardBackId,
    required this.artist,
    required this.artistIds,
    required this.illustrationId,
    required this.borderColor,
    required this.frame,
    required this.fullArt,
    required this.textless,
    required this.booster,
    required this.storySpotlight,
    required this.edhrecRank,
    required this.prices,
    required this.relatedUris,
    required this.purchaseUris,
    this.pennyRank,
    this.printedTypeLine,
    this.printedText,
    this.flavorText,
  });

  factory Card.fromRawJson(String str) => Card.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        object: json["object"],
        id: json["id"],
        oracleId: json["oracle_id"],
        multiverseIds: List<int>.from(json["multiverse_ids"].map((x) => x)),
        name: json["name"],
        printedName: json["printed_name"] ?? '',
        lang: json["lang"],
        releasedAt: DateTime.parse(json["released_at"]),
        uri: json["uri"],
        scryfallUri: json["scryfall_uri"],
        layout: json["layout"],
        highresImage: json["highres_image"],
        imageStatus: json["image_status"],
        imageUris: ImageUris.fromJson(json["image_uris"]),
        manaCost: json["mana_cost"],
        cmc: json["cmc"],
        typeLine: json["type_line"],
        oracleText: json["oracle_text"],
        colors: List<String>.from(json["colors"].map((x) => x)),
        colorIdentity: List<String>.from(json["color_identity"].map((x) => x)),
        keywords: List<dynamic>.from(json["keywords"].map((x) => x)),
        legalities: Legalities.fromJson(json["legalities"]),
        games: List<String>.from(json["games"].map((x) => x)),
        reserved: json["reserved"],
        foil: json["foil"],
        nonfoil: json["nonfoil"],
        finishes: List<String>.from(json["finishes"].map((x) => x)),
        oversized: json["oversized"],
        promo: json["promo"],
        reprint: json["reprint"],
        variation: json["variation"],
        setId: json["set_id"],
        CardSet: json["set"],
        setName: json["set_name"],
        setType: json["set_type"],
        setUri: json["set_uri"],
        setSearchUri: json["set_search_uri"],
        scryfallSetUri: json["scryfall_set_uri"],
        rulingsUri: json["rulings_uri"],
        printsSearchUri: json["prints_search_uri"],
        collectorNumber: json["collector_number"],
        digital: json["digital"],
        rarity: json["rarity"],
        cardBackId: json["card_back_id"],
        artist: json["artist"],
        artistIds: List<String>.from(json["artist_ids"].map((x) => x)),
        illustrationId: json["illustration_id"],
        borderColor: json["border_color"],
        frame: json["frame"],
        fullArt: json["full_art"],
        textless: json["textless"],
        booster: json["booster"],
        storySpotlight: json["story_spotlight"],
        edhrecRank: json["edhrec_rank"],
        prices: Prices.fromJson(json["prices"]),
        relatedUris: RelatedUris.fromJson(json["related_uris"]),
        purchaseUris: PurchaseUris.fromJson(json["purchase_uris"] ?? {}),
        pennyRank: json["penny_rank"],
        printedTypeLine: json["printed_type_line"],
        printedText: json["printed_text"],
        flavorText: json["flavor_text"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "oracle_id": oracleId,
        "multiverse_ids": List<dynamic>.from(multiverseIds.map((x) => x)),
        "name": name,
        "printed_name": printedName,
        "lang": lang,
        "released_at":
            "${releasedAt.year.toString().padLeft(4, '0')}-${releasedAt.month.toString().padLeft(2, '0')}-${releasedAt.day.toString().padLeft(2, '0')}",
        "uri": uri,
        "scryfall_uri": scryfallUri,
        "layout": layout,
        "highres_image": highresImage,
        "image_status": imageStatus,
        "image_uris": imageUris.toJson(),
        "mana_cost": manaCost,
        "cmc": cmc,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "colors": List<dynamic>.from(colors.map((x) => x)),
        "color_identity": List<dynamic>.from(colorIdentity.map((x) => x)),
        "keywords": List<dynamic>.from(keywords.map((x) => x)),
        "legalities": legalities.toJson(),
        "games": List<dynamic>.from(games.map((x) => x)),
        "reserved": reserved,
        "foil": foil,
        "nonfoil": nonfoil,
        "finishes": List<dynamic>.from(finishes.map((x) => x)),
        "oversized": oversized,
        "promo": promo,
        "reprint": reprint,
        "variation": variation,
        "set_id": setId,
        "set": CardSet,
        "set_name": setName,
        "set_type": setType,
        "set_uri": setUri,
        "set_search_uri": setSearchUri,
        "scryfall_set_uri": scryfallSetUri,
        "rulings_uri": rulingsUri,
        "prints_search_uri": printsSearchUri,
        "collector_number": collectorNumber,
        "digital": digital,
        "rarity": rarity,
        "card_back_id": cardBackId,
        "artist": artist,
        "artist_ids": List<dynamic>.from(artistIds.map((x) => x)),
        "illustration_id": illustrationId,
        "border_color": borderColor,
        "frame": frame,
        "full_art": fullArt,
        "textless": textless,
        "booster": booster,
        "story_spotlight": storySpotlight,
        "edhrec_rank": edhrecRank,
        "prices": prices.toJson(),
        "related_uris": relatedUris.toJson(),
        "purchase_uris": purchaseUris.toJson(),
        "penny_rank": pennyRank,
        "printed_type_line": printedTypeLine,
        "printed_text": printedText,
        "flavor_text": flavorText,
      };
}

class ImageUris {
  String small;
  String normal;
  String large;
  String png;
  String artCrop;
  String borderCrop;

  ImageUris({
    required this.small,
    required this.normal,
    required this.large,
    required this.png,
    required this.artCrop,
    required this.borderCrop,
  });

  factory ImageUris.fromRawJson(String str) =>
      ImageUris.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageUris.fromJson(Map<String, dynamic> json) => ImageUris(
        small: json["small"],
        normal: json["normal"],
        large: json["large"],
        png: json["png"],
        artCrop: json["art_crop"],
        borderCrop: json["border_crop"],
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "normal": normal,
        "large": large,
        "png": png,
        "art_crop": artCrop,
        "border_crop": borderCrop,
      };
}

class Legalities {
  String standard;
  String future;
  String historic;
  String timeless;
  String gladiator;
  String pioneer;
  String explorer;
  String modern;
  String legacy;
  String pauper;
  String vintage;
  String penny;
  String commander;
  String oathbreaker;
  String standardbrawl;
  String brawl;
  String alchemy;
  String paupercommander;
  String duel;
  String oldschool;
  String premodern;
  String predh;

  Legalities({
    required this.standard,
    required this.future,
    required this.historic,
    required this.timeless,
    required this.gladiator,
    required this.pioneer,
    required this.explorer,
    required this.modern,
    required this.legacy,
    required this.pauper,
    required this.vintage,
    required this.penny,
    required this.commander,
    required this.oathbreaker,
    required this.standardbrawl,
    required this.brawl,
    required this.alchemy,
    required this.paupercommander,
    required this.duel,
    required this.oldschool,
    required this.premodern,
    required this.predh,
  });

  factory Legalities.fromRawJson(String str) =>
      Legalities.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Legalities.fromJson(Map<String, dynamic> json) => Legalities(
        standard: json["standard"],
        future: json["future"],
        historic: json["historic"],
        timeless: json["timeless"],
        gladiator: json["gladiator"],
        pioneer: json["pioneer"],
        explorer: json["explorer"],
        modern: json["modern"],
        legacy: json["legacy"],
        pauper: json["pauper"],
        vintage: json["vintage"],
        penny: json["penny"],
        commander: json["commander"],
        oathbreaker: json["oathbreaker"],
        standardbrawl: json["standardbrawl"],
        brawl: json["brawl"],
        alchemy: json["alchemy"],
        paupercommander: json["paupercommander"],
        duel: json["duel"],
        oldschool: json["oldschool"],
        premodern: json["premodern"],
        predh: json["predh"],
      );

  Map<String, dynamic> toJson() => {
        "standard": standard,
        "future": future,
        "historic": historic,
        "timeless": timeless,
        "gladiator": gladiator,
        "pioneer": pioneer,
        "explorer": explorer,
        "modern": modern,
        "legacy": legacy,
        "pauper": pauper,
        "vintage": vintage,
        "penny": penny,
        "commander": commander,
        "oathbreaker": oathbreaker,
        "standardbrawl": standardbrawl,
        "brawl": brawl,
        "alchemy": alchemy,
        "paupercommander": paupercommander,
        "duel": duel,
        "oldschool": oldschool,
        "premodern": premodern,
        "predh": predh,
      };
}

class Prices {
  dynamic usd;
  dynamic usdFoil;
  dynamic usdEtched;
  dynamic eur;
  dynamic eurFoil;
  dynamic tix;

  Prices({
    required this.usd,
    required this.usdFoil,
    required this.usdEtched,
    required this.eur,
    required this.eurFoil,
    required this.tix,
  });

  factory Prices.fromRawJson(String str) => Prices.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        usd: json["usd"],
        usdFoil: json["usd_foil"],
        usdEtched: json["usd_etched"],
        eur: json["eur"],
        eurFoil: json["eur_foil"],
        tix: json["tix"],
      );

  Map<String, dynamic> toJson() => {
        "usd": usd,
        "usd_foil": usdFoil,
        "usd_etched": usdEtched,
        "eur": eur,
        "eur_foil": eurFoil,
        "tix": tix,
      };
}

class PurchaseUris {
  String tcgplayer;
  String cardmarket;
  String cardhoarder;

  PurchaseUris({
    required this.tcgplayer,
    required this.cardmarket,
    required this.cardhoarder,
  });

  factory PurchaseUris.fromRawJson(String str) =>
      PurchaseUris.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseUris.fromJson(Map<String, dynamic> json) => PurchaseUris(
        tcgplayer: json["tcgplayer"] ?? '',
        cardmarket: json["cardmarket"] ?? '',
        cardhoarder: json["cardhoarder"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "tcgplayer": tcgplayer,
        "cardmarket": cardmarket,
        "cardhoarder": cardhoarder,
      };
}

class RelatedUris {
  String tcgplayerInfiniteArticles;
  String tcgplayerInfiniteDecks;
  String edhrec;
  String? gatherer;

  RelatedUris({
    required this.tcgplayerInfiniteArticles,
    required this.tcgplayerInfiniteDecks,
    required this.edhrec,
    this.gatherer,
  });

  factory RelatedUris.fromRawJson(String str) =>
      RelatedUris.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RelatedUris.fromJson(Map<String, dynamic> json) => RelatedUris(
        tcgplayerInfiniteArticles: json["tcgplayer_infinite_articles"],
        tcgplayerInfiniteDecks: json["tcgplayer_infinite_decks"],
        edhrec: json["edhrec"],
        gatherer: json["gatherer"],
      );

  Map<String, dynamic> toJson() => {
        "tcgplayer_infinite_articles": tcgplayerInfiniteArticles,
        "tcgplayer_infinite_decks": tcgplayerInfiniteDecks,
        "edhrec": edhrec,
        "gatherer": gatherer,
      };
}
