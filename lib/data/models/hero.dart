import 'package:hive/hive.dart';
import 'dart:convert';

part 'hero.g.dart';

Hero heroFromJson(String str) => Hero.fromJson(json.decode(str));

String heroToJson(Hero data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class Hero {
  @HiveField(1)
  int id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String slug;
  @HiveField(4)
  Powerstats powerstats;
  @HiveField(5)
  Appearance appearance;
  @HiveField(6)
  Biography biography;
  @HiveField(7)
  Work work;
  @HiveField(8)
  Connections connections;
  @HiveField(9)
  Images images;

  Hero({
    required this.id,
    required this.name,
    required this.slug,
    required this.powerstats,
    required this.appearance,
    required this.biography,
    required this.work,
    required this.connections,
    required this.images,
  });

  // FÁBRICA DO 'HERO' ATUALIZADA
  factory Hero.fromJson(Map<String, dynamic> json) => Hero(
    // Correção para 'id' (que já fizemos)
    id: int.tryParse(json["id"].toString()) ?? 0,
    // Correção para Strings nulas
    name: json["name"] as String? ?? 'Nome Desconhecido',
    slug: json["slug"] as String? ?? '',
    // As classes filhas agora também serão corrigidas
    powerstats: Powerstats.fromJson(json["powerstats"]),
    appearance: Appearance.fromJson(json["appearance"]),
    biography: Biography.fromJson(json["biography"]),
    work: Work.fromJson(json["work"]),
    connections: Connections.fromJson(json["connections"]),
    images: Images.fromJson(json["images"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "powerstats": powerstats.toJson(),
    "appearance": appearance.toJson(),
    "biography": biography.toJson(),
    "work": work.toJson(),
    "connections": connections.toJson(),
    "images": images.toJson(),
  };
}

@HiveType(typeId: 2)
class Appearance {
  @HiveField(1)
  String gender;
  @HiveField(2)
  String race;
  @HiveField(3)
  List<String> height;
  @HiveField(4)
  List<String> weight;
  @HiveField(5)
  String eyeColor;
  @HiveField(6)
  String hairColor;

  Appearance({
    required this.gender,
    required this.race,
    required this.height,
    required this.weight,
    required this.eyeColor,
    required this.hairColor,
  });

  // FÁBRICA 'APPEARANCE' ATUALIZADA
  factory Appearance.fromJson(Map<String, dynamic> json) => Appearance(
    gender: json["gender"] as String? ?? 'N/A',
    race: json["race"] as String? ?? 'N/A',
    // Correção para Listas nulas
    height: List<String>.from(json["height"]?.map((x) => x) ?? []),
    weight: List<String>.from(json["weight"]?.map((x) => x) ?? []),
    eyeColor: json["eyeColor"] as String? ?? 'N/A',
    hairColor: json["hairColor"] as String? ?? 'N/A',
  );

  Map<String, dynamic> toJson() => {
    "gender": gender,
    "race": race,
    "height": List<dynamic>.from(height.map((x) => x)),
    "weight": List<dynamic>.from(weight.map((x) => x)),
    "eyeColor": eyeColor,
    "hairColor": hairColor,
  };
}

@HiveType(typeId: 3)
class Biography {
  @HiveField(1)
  String fullName;
  @HiveField(2)
  String alterEgos;
  @HiveField(3)
  List<String> aliases;
  @HiveField(4)
  String placeOfBirth;
  @HiveField(5)
  String firstAppearance;
  @HiveField(6)
  String publisher;
  @HiveField(7)
  String alignment;

  Biography({
    required this.fullName,
    required this.alterEgos,
    required this.aliases,
    required this.placeOfBirth,
    required this.firstAppearance,
    required this.publisher,
    required this.alignment,
  });

  // FÁBRICA 'BIOGRAPHY' ATUALIZADA
  factory Biography.fromJson(Map<String, dynamic> json) => Biography(
    fullName: json["fullName"] as String? ?? '',
    alterEgos: json["alterEgos"] as String? ?? 'N/A',
    aliases: List<String>.from(json["aliases"]?.map((x) => x) ?? []),
    placeOfBirth: json["placeOfBirth"] as String? ?? 'N/A',
    firstAppearance: json["firstAppearance"] as String? ?? 'N/A',
    publisher: json["publisher"] as String? ?? 'N/A',
    alignment: json["alignment"] as String? ?? 'N/A',
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "alterEgos": alterEgos,
    "aliases": List<dynamic>.from(aliases.map((x) => x)),
    "placeOfBirth": placeOfBirth,
    "firstAppearance": firstAppearance,
    "publisher": publisher,
    "alignment": alignment,
  };
}

@HiveType(typeId: 4)
class Connections {
  @HiveField(1)
  String groupAffiliation;
  @HiveField(2)
  String relatives;

  Connections({
    required this.groupAffiliation,
    required this.relatives,
  });

  // FÁBRICA 'CONNECTIONS' ATUALIZADA
  factory Connections.fromJson(Map<String, dynamic> json) => Connections(
    groupAffiliation: json["groupAffiliation"] as String? ?? 'N/A',
    relatives: json["relatives"] as String? ?? 'N/A',
  );

  Map<String, dynamic> toJson() => {
    "groupAffiliation": groupAffiliation,
    "relatives": relatives,
  };
}

@HiveType(typeId: 5)
class Images {
  @HiveField(1)
  String xs;
  @HiveField(2)
  String sm;
  @HiveField(3)
  String md;
  @HiveField(4)
  String lg;

  Images({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
  });

  // URL Padrão caso a imagem não exista
  static const String _placeholder = 'https://via.placeholder.com/150';

  // FÁBRICA 'IMAGES' ATUALIZADA
  factory Images.fromJson(Map<String, dynamic> json) => Images(
    xs: json["xs"] as String? ?? _placeholder,
    sm: json["sm"] as String? ?? _placeholder,
    md: json["md"] as String? ?? _placeholder,
    lg: json["lg"] as String? ?? _placeholder,
  );

  Map<String, dynamic> toJson() => {
    "xs": xs,
    "sm": sm,
    "md": md,
    "lg": lg,
  };
}

@HiveType(typeId: 6)
class Powerstats {
  @HiveField(1)
  int intelligence;
  @HiveField(2)
  int strength;
  @HiveField(3)
  int speed;
  @HiveField(4)
  int durability;
  @HiveField(5)
  int power;
  @HiveField(6)
  int combat;

  Powerstats({
    required this.intelligence,
    required this.strength,
    required this.speed,
    required this.durability,
    required this.power,
    required this.combat,
  });

  // FÁBRICA 'POWERSTATS' ATUALIZADA (que já fizemos)
  factory Powerstats.fromJson(Map<String, dynamic> json) => Powerstats(
    intelligence: int.tryParse(json["intelligence"].toString()) ?? 0,
    strength: int.tryParse(json["strength"].toString()) ?? 0,
    speed: int.tryParse(json["speed"].toString()) ?? 0,
    durability: int.tryParse(json["durability"].toString()) ?? 0,
    power: int.tryParse(json["power"].toString()) ?? 0,
    combat: int.tryParse(json["combat"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "intelligence": intelligence,
    "strength": strength,
    "speed": speed,
    "durability": durability,
    "power": power,
    "combat": combat,
  };
}

@HiveType(typeId: 7)
class Work {
  @HiveField(1)
  String occupation;
  @HiveField(2)
  String base;

  Work({
    required this.occupation,
    required this.base,
  });

  // FÁBRICA 'WORK' ATUALIZADA
  factory Work.fromJson(Map<String, dynamic> json) => Work(
    occupation: json["occupation"] as String? ?? 'N/A',
    base: json["base"] as String? ?? 'N/A',
  );

  Map<String, dynamic> toJson() => {
    "occupation": occupation,
    "base": base,
  };
}