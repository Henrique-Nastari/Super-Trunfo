part of 'hero.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HeroAdapter extends TypeAdapter<Hero> {
  @override
  final int typeId = 1;

  @override
  Hero read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hero(
      id: fields[1] as int,
      name: fields[2] as String,
      slug: fields[3] as String,
      powerstats: fields[4] as Powerstats,
      appearance: fields[5] as Appearance,
      biography: fields[6] as Biography,
      work: fields[7] as Work,
      connections: fields[8] as Connections,
      images: fields[9] as Images,
    );
  }

  @override
  void write(BinaryWriter writer, Hero obj) {
    writer
      ..writeByte(9)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.slug)
      ..writeByte(4)
      ..write(obj.powerstats)
      ..writeByte(5)
      ..write(obj.appearance)
      ..writeByte(6)
      ..write(obj.biography)
      ..writeByte(7)
      ..write(obj.work)
      ..writeByte(8)
      ..write(obj.connections)
      ..writeByte(9)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppearanceAdapter extends TypeAdapter<Appearance> {
  @override
  final int typeId = 2;

  @override
  Appearance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appearance(
      gender: fields[1] as String,
      race: fields[2] as String,
      height: (fields[3] as List).cast<String>(),
      weight: (fields[4] as List).cast<String>(),
      eyeColor: fields[5] as String,
      hairColor: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Appearance obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.race)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.eyeColor)
      ..writeByte(6)
      ..write(obj.hairColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppearanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BiographyAdapter extends TypeAdapter<Biography> {
  @override
  final int typeId = 3;

  @override
  Biography read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Biography(
      fullName: fields[1] as String,
      alterEgos: fields[2] as String,
      aliases: (fields[3] as List).cast<String>(),
      placeOfBirth: fields[4] as String,
      firstAppearance: fields[5] as String,
      publisher: fields[6] as String,
      alignment: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Biography obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.alterEgos)
      ..writeByte(3)
      ..write(obj.aliases)
      ..writeByte(4)
      ..write(obj.placeOfBirth)
      ..writeByte(5)
      ..write(obj.firstAppearance)
      ..writeByte(6)
      ..write(obj.publisher)
      ..writeByte(7)
      ..write(obj.alignment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiographyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConnectionsAdapter extends TypeAdapter<Connections> {
  @override
  final int typeId = 4;

  @override
  Connections read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Connections(
      groupAffiliation: fields[1] as String,
      relatives: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Connections obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.groupAffiliation)
      ..writeByte(2)
      ..write(obj.relatives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImagesAdapter extends TypeAdapter<Images> {
  @override
  final int typeId = 5;

  @override
  Images read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Images(
      xs: fields[1] as String,
      sm: fields[2] as String,
      md: fields[3] as String,
      lg: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Images obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.xs)
      ..writeByte(2)
      ..write(obj.sm)
      ..writeByte(3)
      ..write(obj.md)
      ..writeByte(4)
      ..write(obj.lg);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PowerstatsAdapter extends TypeAdapter<Powerstats> {
  @override
  final int typeId = 6;

  @override
  Powerstats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Powerstats(
      intelligence: fields[1] as int,
      strength: fields[2] as int,
      speed: fields[3] as int,
      durability: fields[4] as int,
      power: fields[5] as int,
      combat: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Powerstats obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.intelligence)
      ..writeByte(2)
      ..write(obj.strength)
      ..writeByte(3)
      ..write(obj.speed)
      ..writeByte(4)
      ..write(obj.durability)
      ..writeByte(5)
      ..write(obj.power)
      ..writeByte(6)
      ..write(obj.combat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PowerstatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkAdapter extends TypeAdapter<Work> {
  @override
  final int typeId = 7;

  @override
  Work read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Work(
      occupation: fields[1] as String,
      base: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Work obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.occupation)
      ..writeByte(2)
      ..write(obj.base);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
