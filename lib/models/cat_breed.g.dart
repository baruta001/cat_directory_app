// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cat_breed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatBreed _$CatBreedFromJson(Map<String, dynamic> json) => _CatBreed(
  breed: json['breed'] as String,
  country: json['country'] as String,
  origin: json['origin'] as String? ?? '',
  coat: json['coat'] as String? ?? '',
  pattern: json['pattern'] as String? ?? '',
);

Map<String, dynamic> _$CatBreedToJson(_CatBreed instance) => <String, dynamic>{
  'breed': instance.breed,
  'country': instance.country,
  'origin': instance.origin,
  'coat': instance.coat,
  'pattern': instance.pattern,
};
