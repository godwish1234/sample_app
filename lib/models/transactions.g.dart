// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transactions _$TransactionsFromJson(Map<String, dynamic> json) => Transactions(
      name: json['name'] as String?,
      date: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['date'], const TimestampConvertDatetime().fromJson),
      attempt: (json['attempt'] as num?)?.toInt(),
      brasCount: (json['brasCount'] as num?)?.toInt(),
      clothesCount: (json['clothesCount'] as num?)?.toInt(),
      underpantsCount: (json['underpantsCount'] as num?)?.toInt(),
      socksCount: (json['socksCount'] as num?)?.toInt(),
      othersCount: (json['othersCount'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      initial: json['initial'] == null
          ? null
          : TransactionItem.fromJson(json['initial'] as Map<String, dynamic>),
      dry: json['dry'] == null
          ? null
          : TransactionItem.fromJson(json['dry'] as Map<String, dynamic>),
      pack: json['pack'] == null
          ? null
          : TransactionItem.fromJson(json['pack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionsToJson(Transactions instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.date, const TimestampConvertDatetime().toJson),
      'attempt': instance.attempt,
      'brasCount': instance.brasCount,
      'clothesCount': instance.clothesCount,
      'underpantsCount': instance.underpantsCount,
      'socksCount': instance.socksCount,
      'othersCount': instance.othersCount,
      'status': instance.status,
      'initial': instance.initial?.toJson(),
      'dry': instance.dry?.toJson(),
      'pack': instance.pack?.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
