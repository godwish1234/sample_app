import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sample_app/models/converter/timestamp_convert_datetime.dart';

part 'transaction_item.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionItem {
  String? count;
  @TimestampConvertDatetime()
  DateTime? timestamp;

  TransactionItem({this.count, this.timestamp});

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}
