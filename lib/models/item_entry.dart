// To parse this JSON data, do
//
//     final itemEntry = itemEntryFromJson(jsonString);

import 'dart:convert';

ItemEntry itemEntryFromJson(String str) => ItemEntry.fromJson(json.decode(str));

String itemEntryToJson(ItemEntry data) => json.encode(data.toJson());

class ItemEntry {
  String model;
  String pk;
  Fields fields;

  ItemEntry({required this.model, required this.pk, required this.fields});

  factory ItemEntry.fromJson(Map<String, dynamic> json) => ItemEntry(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  String name;
  int price;
  String description;
  String thumbnail;
  String category;
  bool isFeatured;
  int views;

  Fields({
    required this.name,
    required this.price,
    required this.description,
    required this.thumbnail,
    required this.category,
    required this.isFeatured,
    required this.views,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    name: json["name"],
    price: json["price"],
    description: json["description"],
    thumbnail: json["thumbnail"],
    category: json["category"],
    isFeatured: json["is_featured"],
    views: json["views"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "description": description,
    "thumbnail": thumbnail,
    "category": category,
    "is_featured": isFeatured,
    "views": views,
  };
}
