import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sample_app/models/converter/timestamp_convert_datetime.dart';
import 'package:sample_app/models/transaction_item.dart';

part 'transactions.g.dart';

@JsonSerializable(explicitToJson: true)
class Transactions {
  String? name;
  @TimestampConvertDatetime()
  DateTime? date;
  int? attempt;
  int? brasCount;
  int? clothesCount;
  int? underpantsCount;
  int? socksCount;
  int? othersCount;
  int? status;
  TransactionItem? initial;
  TransactionItem? dry;
  TransactionItem? pack;

  Transactions(
      {this.name,
      this.date,
      this.attempt,
      this.brasCount,
      this.clothesCount,
      this.underpantsCount,
      this.socksCount,
      this.othersCount,
      this.status,
      this.initial,
      this.dry,
      this.pack});

  factory Transactions.fromJson(Map<String, dynamic> json) =>
      _$TransactionsFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsToJson(this);
}
