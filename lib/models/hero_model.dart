class Powerstats {
  final String? intelligence;
  final String? strength;
  final String? speed;
  final String? durability;
  final String? power;
  final String? combat;

  Powerstats(
    this.intelligence,
    this.strength,
    this.speed,
    this.durability,
    this.power,
    this.combat,
  );
}

class Biography {
  final String? fullName;
  final String? alterEgos;
  final List<String>? aliases;
  final String? placeOfBirth;
  final String? firstAppearance;
  final String? publisher;
  final String? alignment;

  Biography(
    this.fullName,
    this.alterEgos,
    this.aliases,
    this.placeOfBirth,
    this.firstAppearance,
    this.publisher,
    this.alignment,
  );
}

class Appearance {
  final String? gender;
  final String? race;
  final List<String>? height;
  final List<String>? weight;
  final String? eyeColor;
  final String? hairColor;

  Appearance(
    this.gender,
    this.race,
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
  );
}

class Work {
  final String? occupation;
  final String? base;

  Work(this.occupation, this.base);
}

class Connections {
  final String? groupAffiliation;
  final String? relatives;

  Connections(this.groupAffiliation, this.relatives);
}

class Image {
  final String url;
  String? asciiArt;

  Image(this.url, [this.asciiArt]);
}

class HeroModel {
  final String id;
  final String name;
  final Powerstats? powerstats;
  final Biography? biography;
  final Appearance? appearance;
  final Work? work;
  final Connections? connections;
  final Image? image;

  HeroModel(
    this.id,
    this.name,
    this.powerstats,
    this.biography,
    this.appearance,
    this.work,
    this.connections,
    this.image,
  );

  // Generated from chatGPT
  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      json['id'],
      json['name'],
      json['powerstats'] != null
          ? Powerstats(
              json['powerstats']['intelligence'] ?? '0',
              json['powerstats']['strength'] ?? '0',
              json['powerstats']['speed'] ?? '0',
              json['powerstats']['durability'] ?? '0',
              json['powerstats']['power'] ?? '0',
              json['powerstats']['combat'] ?? '0',
            )
          : null,
      json['biography'] != null
          ? Biography(
              json['biography']['fullName'] ?? '',
              json['biography']['alterEgos'] ?? '',
              List<String>.from(json['biography']['aliases'] ?? []),
              json['biography']['placeOfBirth'] ?? '',
              json['biography']['firstAppearance'] ?? '',
              json['biography']['publisher'] ?? '',
              json['biography']['alignment'] ?? '',
            )
          : null,
      json['appearance'] != null
          ? Appearance(
              json['appearance']['gender'] ?? '',
              json['appearance']['race'] ?? '',
              List<String>.from(json['appearance']['height'] ?? []),
              List<String>.from(json['appearance']['weight'] ?? []),
              json['appearance']['eyeColor'] ?? '',
              json['appearance']['hairColor'] ?? '',
            )
          : null,
      json['work'] != null
          ? Work(json['work']['occupation'] ?? '', json['work']['base'] ?? '')
          : null,
      json['connections'] != null
          ? Connections(
              json['connections']['groupAffiliation'] ?? '',
              json['connections']['relatives'] ?? '',
            )
          : null,
      json['image'] != null
          ? Image(json['image']['url'] ?? '', json['image']['asciiArt'] ?? '')
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'powerstats': powerstats != null
          ? {
              'intelligence': powerstats!.intelligence,
              'strength': powerstats!.strength,
              'speed': powerstats!.speed,
              'durability': powerstats!.durability,
              'power': powerstats!.power,
              'combat': powerstats!.combat,
            }
          : null,
      'biography': biography != null
          ? {
              'fullName': biography!.fullName,
              'alterEgos': biography!.alterEgos,
              'aliases': biography!.aliases,
              'placeOfBirth': biography!.placeOfBirth,
              'firstAppearance': biography!.firstAppearance,
              'publisher': biography!.publisher,
              'alignment': biography!.alignment,
            }
          : null,
      'appearance': appearance != null
          ? {
              'gender': appearance!.gender,
              'race': appearance!.race,
              'height': appearance!.height,
              'weight': appearance!.weight,
              'eyeColor': appearance!.eyeColor,
              'hairColor': appearance!.hairColor,
            }
          : null,
      'work': work != null
          ? {'occupation': work!.occupation, 'base': work!.base}
          : null,
      'connections': connections != null
          ? {
              'groupAffiliation': connections!.groupAffiliation,
              'relatives': connections!.relatives,
            }
          : null,
      'image': image != null
          ? {'url': image!.url, 'asciiArt': image!.asciiArt}
          : null,
    };
  }
}
