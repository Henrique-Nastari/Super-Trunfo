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

  factory Hero.fromJson(Map<String, dynamic> json) => Hero(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
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

  factory Appearance.fromJson(Map<String, dynamic> json) => Appearance(
    gender: json["gender"],
    race: json["race"],
    height: List<String>.from(json["height"].map((x) => x)),
    weight: List<String>.from(json["weight"].map((x) => x)),
    eyeColor: json["eyeColor"],
    hairColor: json["hairColor"],
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

  factory Biography.fromJson(Map<String, dynamic> json) => Biography(
    fullName: json["fullName"],
    alterEgos: json["alterEgos"],
    aliases: List<String>.from(json["aliases"].map((x) => x)),
    placeOfBirth: json["placeOfBirth"],
    firstAppearance: json["firstAppearance"],
    publisher: json["publisher"],
    alignment: json["alignment"],
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

  factory Connections.fromJson(Map<String, dynamic> json) => Connections(
    groupAffiliation: json["groupAffiliation"],
    relatives: json["relatives"],
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

  factory Images.fromJson(Map<String, dynamic> json) => Images(
    xs: json["xs"],
    sm: json["sm"],
    md: json["md"],
    lg: json["lg"],
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

  factory Powerstats.fromJson(Map<String, dynamic> json) => Powerstats(
    intelligence: json["intelligence"],
    strength: json["strength"],
    speed: json["speed"],
    durability: json["durability"],
    power: json["power"],
    combat: json["combat"],
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

  factory Work.fromJson(Map<String, dynamic> json) => Work(
    occupation: json["occupation"],
    base: json["base"],
  );

  Map<String, dynamic> toJson() => {
    "occupation": occupation,
    "base": base,
  };
}
