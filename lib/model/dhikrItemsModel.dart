// To parse this JSON data, do
//
//     final dhikrItems = dhikrItemsFromJson(jsonString);

import 'dart:convert';

DhikrItems dhikrItemsFromJson(String str) => DhikrItems.fromJson(json.decode(str));

String dhikrItemsToJson(DhikrItems data) => json.encode(data.toJson());

class DhikrItems {
  String? title;
  String? description;
  String? dhikr;
  String? image;
  String? id;
  bool? enable;
  int? count;

  DhikrItems({
    this.title,
    this.id,
    this.description,
    this.image,
    this.dhikr,
    this.enable,
    this.count,
  });

  factory DhikrItems.fromJson(Map<String, dynamic> json) => DhikrItems(
    title: json["title"],
    description: json["description"],
    id: json["id"],
    image: json["image"],
    dhikr: json["dhikr"],
    count: json["count"],
    enable: json["enable"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "enable": enable,
    "id": id,
    "image": image,
    "dhikr": dhikr,
    "count": count,
  };
}
