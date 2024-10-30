import 'dart:convert';

class CardPrints {
  CardPrints({
    required this.object,
    required this.totalCards,
    required this.hasMore,
    required this.data,
  });

  final String? object;
  final num? totalCards;
  final bool? hasMore;
  final List<CardPrint> data;

  factory CardPrints.fromJson(Map<String, dynamic> json) {
    return CardPrints(
      object: json["object"],
      totalCards: json["total_cards"],
      hasMore: json["has_more"],
      data: json["data"] == null
          ? []
          : List<CardPrint>.from(
              json["data"]!.map((x) => CardPrint.fromJson(x))),
    );
  }

  factory CardPrints.fromRawJson(String str) =>
      CardPrints.fromJson(json.decode(str));

  Map<String, dynamic> toJson() => {
        "object": object,
        "total_cards": totalCards,
        "has_more": hasMore,
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class CardPrint {
  CardPrint({
    required this.object,
    required this.id,
    required this.oracleId,
    required this.multiverseIds,
    required this.name,
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
    required this.producedMana,
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
    required this.CardPrintSet,
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
    required this.flavorText,
    required this.cardBackId,
    required this.artist,
    required this.artistIds,
    required this.illustrationId,
    required this.borderColor,
    required this.frame,
    required this.frameEffects,
    required this.securityStamp,
    required this.fullArt,
    required this.textless,
    required this.booster,
    required this.storySpotlight,
    required this.promoTypes,
    required this.edhrecRank,
    required this.prices,
    required this.relatedUris,
    required this.purchaseUris,
    required this.preview,
    required this.tcgplayerId,
    required this.mtgoId,
    required this.cardmarketId,
    required this.cardFaces,
    required this.tcgplayerEtchedId,
    required this.watermark,
    required this.mtgoFoilId,
    required this.printedName,
    required this.power,
    required this.toughness,
    required this.allParts,
    required this.printedTypeLine,
    required this.printedText,
  });

  final String? object;
  final String? id;
  final String? oracleId;
  final List<num> multiverseIds;
  final String? name;
  final String? lang;
  final DateTime? releasedAt;
  final String? uri;
  final String? scryfallUri;
  final String? layout;
  final bool? highresImage;
  final String? imageStatus;
  final ImageUris? imageUris;
  final String? manaCost;
  final num? cmc;
  final String? typeLine;
  final String? oracleText;
  final List<String> colors;
  final List<String> colorIdentity;
  final List<String> keywords;
  final List<String> producedMana;
  final Legalities? legalities;
  final List<String> games;
  final bool? reserved;
  final bool? foil;
  final bool? nonfoil;
  final List<String> finishes;
  final bool? oversized;
  final bool? promo;
  final bool? reprint;
  final bool? variation;
  final String? setId;
  final String? CardPrintSet;
  final String? setName;
  final String? setType;
  final String? setUri;
  final String? setSearchUri;
  final String? scryfallSetUri;
  final String? rulingsUri;
  final String? printsSearchUri;
  final String? collectorNumber;
  final bool? digital;
  final String? rarity;
  final String? flavorText;
  final String? cardBackId;
  final String? artist;
  final List<String> artistIds;
  final String? illustrationId;
  final String? borderColor;
  final String? frame;
  final List<String> frameEffects;
  final String? securityStamp;
  final bool? fullArt;
  final bool? textless;
  final bool? booster;
  final bool? storySpotlight;
  final List<String> promoTypes;
  final num? edhrecRank;
  final Map<String, dynamic> prices;
  final RelatedUris? relatedUris;
  final PurchaseUris? purchaseUris;
  final Preview? preview;
  final int? tcgplayerId;
  final int? mtgoId;
  final int? cardmarketId;
  final List<CardFace> cardFaces;
  final int? tcgplayerEtchedId;
  final String? watermark;
  final int? mtgoFoilId;
  final String? printedName;
  final String? power;
  final String? toughness;
  final List<AllPart> allParts;
  final String? printedTypeLine;
  final String? printedText;

  factory CardPrint.fromJson(Map<String, dynamic> json) {
    return CardPrint(
      object: json["object"],
      id: json["id"],
      oracleId: json["oracle_id"],
      multiverseIds: json["multiverse_ids"] == null
          ? []
          : List<num>.from(json["multiverse_ids"]!.map((x) => x)),
      name: json["name"],
      lang: json["lang"],
      releasedAt: DateTime.tryParse(json["released_at"] ?? ""),
      uri: json["uri"],
      scryfallUri: json["scryfall_uri"],
      layout: json["layout"],
      highresImage: json["highres_image"],
      imageStatus: json["image_status"],
      imageUris: json["image_uris"] == null
          ? null
          : ImageUris.fromJson(json["image_uris"]),
      manaCost: json["mana_cost"],
      cmc: json["cmc"],
      typeLine: json["type_line"],
      oracleText: json["oracle_text"],
      colors: json["colors"] == null
          ? []
          : List<String>.from(json["colors"]!.map((x) => x)),
      colorIdentity: json["color_identity"] == null
          ? []
          : List<String>.from(json["color_identity"]!.map((x) => x)),
      keywords: json["keywords"] == null
          ? []
          : List<String>.from(json["keywords"]!.map((x) => x)),
      producedMana: json["produced_mana"] == null
          ? []
          : List<String>.from(json["produced_mana"]!.map((x) => x)),
      legalities: json["legalities"] == null
          ? null
          : Legalities.fromJson(json["legalities"]),
      games: json["games"] == null
          ? []
          : List<String>.from(json["games"]!.map((x) => x)),
      reserved: json["reserved"],
      foil: json["foil"],
      nonfoil: json["nonfoil"],
      finishes: json["finishes"] == null
          ? []
          : List<String>.from(json["finishes"]!.map((x) => x)),
      oversized: json["oversized"],
      promo: json["promo"],
      reprint: json["reprint"],
      variation: json["variation"],
      setId: json["set_id"],
      CardPrintSet: json["set"],
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
      flavorText: json["flavor_text"],
      cardBackId: json["card_back_id"],
      artist: json["artist"],
      artistIds: json["artist_ids"] == null
          ? []
          : List<String>.from(json["artist_ids"]!.map((x) => x)),
      illustrationId: json["illustration_id"],
      borderColor: json["border_color"],
      frame: json["frame"],
      frameEffects: json["frame_effects"] == null
          ? []
          : List<String>.from(json["frame_effects"]!.map((x) => x)),
      securityStamp: json["security_stamp"],
      fullArt: json["full_art"],
      textless: json["textless"],
      booster: json["booster"],
      storySpotlight: json["story_spotlight"],
      promoTypes: json["promo_types"] == null
          ? []
          : List<String>.from(json["promo_types"]!.map((x) => x)),
      edhrecRank: json["edhrec_rank"],
      prices: Map.from(json["prices"])
          .map((k, v) => MapEntry<String, dynamic>(k, v)),
      relatedUris: json["related_uris"] == null
          ? null
          : RelatedUris.fromJson(json["related_uris"]),
      purchaseUris: json["purchase_uris"] == null
          ? null
          : PurchaseUris.fromJson(json["purchase_uris"]),
      preview:
          json["preview"] == null ? null : Preview.fromJson(json["preview"]),
      tcgplayerId: json["tcgplayer_id"],
      mtgoId: json["mtgo_id"],
      cardmarketId: json["cardmarket_id"],
      cardFaces: json["card_faces"] == null
          ? []
          : List<CardFace>.from(
              json["card_faces"]!.map((x) => CardFace.fromJson(x))),
      tcgplayerEtchedId: json["tcgplayer_etched_id"],
      watermark: json["watermark"],
      mtgoFoilId: json["mtgo_foil_id"],
      printedName: json["printed_name"],
      power: json["power"],
      toughness: json["toughness"],
      allParts: json["all_parts"] == null
          ? []
          : List<AllPart>.from(
              json["all_parts"]!.map((x) => AllPart.fromJson(x))),
      printedTypeLine: json["printed_type_line"],
      printedText: json["printed_text"],
    );
  }

  Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "oracle_id": oracleId,
        "multiverse_ids": multiverseIds.map((x) => x).toList(),
        "name": name,
        "lang": lang,
        "released_at": releasedAt?.toIso8601String(),
        "uri": uri,
        "scryfall_uri": scryfallUri,
        "layout": layout,
        "highres_image": highresImage,
        "image_status": imageStatus,
        "image_uris": imageUris?.toJson(),
        "mana_cost": manaCost,
        "cmc": cmc,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "colors": colors.map((x) => x).toList(),
        "color_identity": colorIdentity.map((x) => x).toList(),
        "keywords": keywords.map((x) => x).toList(),
        "produced_mana": producedMana.map((x) => x).toList(),
        "legalities": legalities?.toJson(),
        "games": games.map((x) => x).toList(),
        "reserved": reserved,
        "foil": foil,
        "nonfoil": nonfoil,
        "finishes": finishes.map((x) => x).toList(),
        "oversized": oversized,
        "promo": promo,
        "reprint": reprint,
        "variation": variation,
        "set_id": setId,
        "set": CardPrintSet,
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
        "flavor_text": flavorText,
        "card_back_id": cardBackId,
        "artist": artist,
        "artist_ids": artistIds.map((x) => x).toList(),
        "illustration_id": illustrationId,
        "border_color": borderColor,
        "frame": frame,
        "frame_effects": frameEffects.map((x) => x).toList(),
        "security_stamp": securityStamp,
        "full_art": fullArt,
        "textless": textless,
        "booster": booster,
        "story_spotlight": storySpotlight,
        "promo_types": promoTypes.map((x) => x).toList(),
        "edhrec_rank": edhrecRank,
        "prices":
            Map.from(prices).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "related_uris": relatedUris?.toJson(),
        "purchase_uris": purchaseUris?.toJson(),
        "preview": preview?.toJson(),
        "tcgplayer_id": tcgplayerId,
        "mtgo_id": mtgoId,
        "cardmarket_id": cardmarketId,
        "card_faces": cardFaces.map((x) => x.toJson()).toList(),
        "tcgplayer_etched_id": tcgplayerEtchedId,
        "watermark": watermark,
        "mtgo_foil_id": mtgoFoilId,
        "printed_name": printedName,
        "power": power,
        "toughness": toughness,
        "all_parts": allParts.map((x) => x.toJson()).toList(),
        "printed_type_line": printedTypeLine,
        "printed_text": printedText,
      };
}

class AllPart {
  AllPart({
    required this.object,
    required this.id,
    required this.component,
    required this.name,
    required this.typeLine,
    required this.uri,
  });

  final String? object;
  final String? id;
  final String? component;
  final String? name;
  final String? typeLine;
  final String? uri;

  factory AllPart.fromJson(Map<String, dynamic> json) {
    return AllPart(
      object: json["object"],
      id: json["id"],
      component: json["component"],
      name: json["name"],
      typeLine: json["type_line"],
      uri: json["uri"],
    );
  }

  Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "component": component,
        "name": name,
        "type_line": typeLine,
        "uri": uri,
      };
}

class CardFace {
  CardFace({
    required this.object,
    required this.oracleId,
    required this.layout,
    required this.name,
    required this.manaCost,
    required this.cmc,
    required this.typeLine,
    required this.oracleText,
    required this.colors,
    required this.flavorText,
    required this.artist,
    required this.artistId,
    required this.illustrationId,
    required this.imageUris,
  });

  final String? object;
  final String? oracleId;
  final String? layout;
  final String? name;
  final String? manaCost;
  final num? cmc;
  final String? typeLine;
  final String? oracleText;
  final List<dynamic> colors;
  final String? flavorText;
  final String? artist;
  final String? artistId;
  final String? illustrationId;
  final ImageUris? imageUris;

  factory CardFace.fromJson(Map<String, dynamic> json) {
    return CardFace(
      object: json["object"],
      oracleId: json["oracle_id"],
      layout: json["layout"],
      name: json["name"],
      manaCost: json["mana_cost"],
      cmc: json["cmc"],
      typeLine: json["type_line"],
      oracleText: json["oracle_text"],
      colors: json["colors"] == null
          ? []
          : List<dynamic>.from(json["colors"]!.map((x) => x)),
      flavorText: json["flavor_text"],
      artist: json["artist"],
      artistId: json["artist_id"],
      illustrationId: json["illustration_id"],
      imageUris: json["image_uris"] == null
          ? null
          : ImageUris.fromJson(json["image_uris"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "object": object,
        "oracle_id": oracleId,
        "layout": layout,
        "name": name,
        "mana_cost": manaCost,
        "cmc": cmc,
        "type_line": typeLine,
        "oracle_text": oracleText,
        "colors": colors.map((x) => x).toList(),
        "flavor_text": flavorText,
        "artist": artist,
        "artist_id": artistId,
        "illustration_id": illustrationId,
        "image_uris": imageUris?.toJson(),
      };
}

class ImageUris {
  ImageUris({
    required this.small,
    required this.normal,
    required this.large,
    required this.png,
    required this.artCrop,
    required this.borderCrop,
  });

  final String? small;
  final String? normal;
  final String? large;
  final String? png;
  final String? artCrop;
  final String? borderCrop;

  factory ImageUris.fromJson(Map<String, dynamic> json) {
    return ImageUris(
      small: json["small"],
      normal: json["normal"],
      large: json["large"],
      png: json["png"],
      artCrop: json["art_crop"],
      borderCrop: json["border_crop"],
    );
  }

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

  final String? standard;
  final String? future;
  final String? historic;
  final String? timeless;
  final String? gladiator;
  final String? pioneer;
  final String? explorer;
  final String? modern;
  final String? legacy;
  final String? pauper;
  final String? vintage;
  final String? penny;
  final String? commander;
  final String? oathbreaker;
  final String? standardbrawl;
  final String? brawl;
  final String? alchemy;
  final String? paupercommander;
  final String? duel;
  final String? oldschool;
  final String? premodern;
  final String? predh;

  factory Legalities.fromJson(Map<String, dynamic> json) {
    return Legalities(
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
  }

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

class Preview {
  Preview({
    required this.source,
    required this.sourceUri,
    required this.previewedAt,
  });

  final String? source;
  final String? sourceUri;
  final DateTime? previewedAt;

  factory Preview.fromJson(Map<String, dynamic> json) {
    return Preview(
      source: json["source"],
      sourceUri: json["source_uri"],
      previewedAt: DateTime.tryParse(json["previewed_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "source": source,
        "source_uri": sourceUri,
        "previewed_at": previewedAt?.toIso8601String(),
      };
}

class PurchaseUris {
  PurchaseUris({
    required this.tcgplayer,
    required this.cardmarket,
    required this.cardhoarder,
  });

  final String? tcgplayer;
  final String? cardmarket;
  final String? cardhoarder;

  factory PurchaseUris.fromJson(Map<String, dynamic> json) {
    return PurchaseUris(
      tcgplayer: json["tcgplayer"],
      cardmarket: json["cardmarket"],
      cardhoarder: json["cardhoarder"],
    );
  }

  Map<String, dynamic> toJson() => {
        "tcgplayer": tcgplayer,
        "cardmarket": cardmarket,
        "cardhoarder": cardhoarder,
      };
}

class RelatedUris {
  RelatedUris({
    required this.tcgplayerInfiniteArticles,
    required this.tcgplayerInfiniteDecks,
    required this.edhrec,
    required this.gatherer,
  });

  final String? tcgplayerInfiniteArticles;
  final String? tcgplayerInfiniteDecks;
  final String? edhrec;
  final String? gatherer;

  factory RelatedUris.fromJson(Map<String, dynamic> json) {
    return RelatedUris(
      tcgplayerInfiniteArticles: json["tcgplayer_infinite_articles"],
      tcgplayerInfiniteDecks: json["tcgplayer_infinite_decks"],
      edhrec: json["edhrec"],
      gatherer: json["gatherer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "tcgplayer_infinite_articles": tcgplayerInfiniteArticles,
        "tcgplayer_infinite_decks": tcgplayerInfiniteDecks,
        "edhrec": edhrec,
        "gatherer": gatherer,
      };
}
