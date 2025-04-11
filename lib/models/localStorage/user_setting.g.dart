// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'user_setting.dart';

// // **************************************************************************
// // IsarCollectionGenerator
// // **************************************************************************

// // coverage:ignore-file
// // ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// extension GetUserSettingCollection on Isar {
//   IsarCollection<UserSetting> get userSettings => this.collection();
// }

// const UserSettingSchema = CollectionSchema(
//   name: r'UserSetting',
//   id: -4374868905468663165,
//   properties: {
//     r'isDarkMode': PropertySchema(
//       id: 0,
//       name: r'isDarkMode',
//       type: IsarType.bool,
//     ),
//     r'isNewUser': PropertySchema(
//       id: 1,
//       name: r'isNewUser',
//       type: IsarType.bool,
//     ),
//     r'languageId': PropertySchema(
//       id: 2,
//       name: r'languageId',
//       type: IsarType.string,
//     ),
//     r'name': PropertySchema(
//       id: 3,
//       name: r'name',
//       type: IsarType.string,
//     ),
//     r'phoneno': PropertySchema(
//       id: 4,
//       name: r'phoneno',
//       type: IsarType.string,
//     ),
//     r'utcLastUpdated': PropertySchema(
//       id: 5,
//       name: r'utcLastUpdated',
//       type: IsarType.dateTime,
//     )
//   },
//   estimateSize: _userSettingEstimateSize,
//   serialize: _userSettingSerialize,
//   deserialize: _userSettingDeserialize,
//   deserializeProp: _userSettingDeserializeProp,
//   idName: r'id',
//   indexes: {
//     r'utcLastUpdated': IndexSchema(
//       id: 6393560469717219350,
//       name: r'utcLastUpdated',
//       unique: false,
//       replace: false,
//       properties: [
//         IndexPropertySchema(
//           name: r'utcLastUpdated',
//           type: IndexType.value,
//           caseSensitive: false,
//         )
//       ],
//     )
//   },
//   links: {},
//   embeddedSchemas: {},
//   getId: _userSettingGetId,
//   getLinks: _userSettingGetLinks,
//   attach: _userSettingAttach,
//   version: '3.1.0+1',
// );

// int _userSettingEstimateSize(
//   UserSetting object,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   var bytesCount = offsets.last;
//   {
//     final value = object.languageId;
//     if (value != null) {
//       bytesCount += 3 + value.length * 3;
//     }
//   }
//   {
//     final value = object.name;
//     if (value != null) {
//       bytesCount += 3 + value.length * 3;
//     }
//   }
//   {
//     final value = object.phoneno;
//     if (value != null) {
//       bytesCount += 3 + value.length * 3;
//     }
//   }
//   return bytesCount;
// }

// void _userSettingSerialize(
//   UserSetting object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   writer.writeBool(offsets[0], object.isDarkMode);
//   writer.writeBool(offsets[1], object.isNewUser);
//   writer.writeString(offsets[2], object.languageId);
//   writer.writeString(offsets[3], object.name);
//   writer.writeString(offsets[4], object.phoneno);
//   writer.writeDateTime(offsets[5], object.utcLastUpdated);
// }

// UserSetting _userSettingDeserialize(
//   Id id,
//   IsarReader reader,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   final object = UserSetting(
//     isDarkMode: reader.readBoolOrNull(offsets[0]),
//     isNewUser: reader.readBoolOrNull(offsets[1]) ?? false,
//     languageId: reader.readStringOrNull(offsets[2]),
//     name: reader.readStringOrNull(offsets[3]),
//     phoneno: reader.readStringOrNull(offsets[4]),
//     utcLastUpdated: reader.readDateTime(offsets[5]),
//   );
//   object.id = id;
//   return object;
// }

// P _userSettingDeserializeProp<P>(
//   IsarReader reader,
//   int propertyId,
//   int offset,
//   Map<Type, List<int>> allOffsets,
// ) {
//   switch (propertyId) {
//     case 0:
//       return (reader.readBoolOrNull(offset)) as P;
//     case 1:
//       return (reader.readBoolOrNull(offset) ?? false) as P;
//     case 2:
//       return (reader.readStringOrNull(offset)) as P;
//     case 3:
//       return (reader.readStringOrNull(offset)) as P;
//     case 4:
//       return (reader.readStringOrNull(offset)) as P;
//     case 5:
//       return (reader.readDateTime(offset)) as P;
//     default:
//       throw IsarError('Unknown property with id $propertyId');
//   }
// }

// Id _userSettingGetId(UserSetting object) {
//   return object.id;
// }

// List<IsarLinkBase<dynamic>> _userSettingGetLinks(UserSetting object) {
//   return [];
// }

// void _userSettingAttach(
//     IsarCollection<dynamic> col, Id id, UserSetting object) {
//   object.id = id;
// }

// extension UserSettingQueryWhereSort
//     on QueryBuilder<UserSetting, UserSetting, QWhere> {
//   QueryBuilder<UserSetting, UserSetting, QAfterWhere> anyId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(const IdWhereClause.any());
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhere> anyUtcLastUpdated() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         const IndexWhereClause.any(indexName: r'utcLastUpdated'),
//       );
//     });
//   }
// }

// extension UserSettingQueryWhere
//     on QueryBuilder<UserSetting, UserSetting, QWhereClause> {
//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: id,
//         upper: id,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idNotEqualTo(
//       Id id) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             )
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             );
//       } else {
//         return query
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             )
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             );
//       }
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idGreaterThan(Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.greaterThan(lower: id, includeLower: include),
//       );
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idLessThan(Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.lessThan(upper: id, includeUpper: include),
//       );
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idBetween(
//     Id lowerId,
//     Id upperId, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: lowerId,
//         includeLower: includeLower,
//         upper: upperId,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause>
//       utcLastUpdatedEqualTo(DateTime utcLastUpdated) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.equalTo(
//         indexName: r'utcLastUpdated',
//         value: [utcLastUpdated],
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause>
//       utcLastUpdatedNotEqualTo(DateTime utcLastUpdated) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'utcLastUpdated',
//               lower: [],
//               upper: [utcLastUpdated],
//               includeUpper: false,
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'utcLastUpdated',
//               lower: [utcLastUpdated],
//               includeLower: false,
//               upper: [],
//             ));
//       } else {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'utcLastUpdated',
//               lower: [utcLastUpdated],
//               includeLower: false,
//               upper: [],
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'utcLastUpdated',
//               lower: [],
//               upper: [utcLastUpdated],
//               includeUpper: false,
//             ));
//       }
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause>
//       utcLastUpdatedGreaterThan(
//     DateTime utcLastUpdated, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'utcLastUpdated',
//         lower: [utcLastUpdated],
//         includeLower: include,
//         upper: [],
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause>
//       utcLastUpdatedLessThan(
//     DateTime utcLastUpdated, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'utcLastUpdated',
//         lower: [],
//         upper: [utcLastUpdated],
//         includeUpper: include,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterWhereClause>
//       utcLastUpdatedBetween(
//     DateTime lowerUtcLastUpdated,
//     DateTime upperUtcLastUpdated, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'utcLastUpdated',
//         lower: [lowerUtcLastUpdated],
//         includeLower: includeLower,
//         upper: [upperUtcLastUpdated],
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension UserSettingQueryFilter
//     on QueryBuilder<UserSetting, UserSetting, QFilterCondition> {
//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idEqualTo(
//       Id value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idGreaterThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idLessThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idBetween(
//     Id lower,
//     Id upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'id',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       isDarkModeIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'isDarkMode',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       isDarkModeIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'isDarkMode',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       isDarkModeEqualTo(bool? value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'isDarkMode',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       isNewUserEqualTo(bool value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'isNewUser',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'languageId',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'languageId',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdEqualTo(
//     String? value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'languageId',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdGreaterThan(
//     String? value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'languageId',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdLessThan(
//     String? value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'languageId',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdBetween(
//     String? lower,
//     String? upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'languageId',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'languageId',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'languageId',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdContains(String value, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'languageId',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdMatches(String pattern, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'languageId',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'languageId',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       languageIdIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'languageId',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'name',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       nameIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'name',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameEqualTo(
//     String? value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'name',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameGreaterThan(
//     String? value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'name',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameLessThan(
//     String? value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'name',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameBetween(
//     String? lower,
//     String? upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'name',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'name',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'name',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'name',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'name',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'name',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       nameIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'name',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       phonenoIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNull(
//         property: r'phoneno',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       phonenoIsNotNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(const FilterCondition.isNotNull(
//         property: r'phoneno',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoEqualTo(
//     String? value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'phoneno',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       phonenoGreaterThan(
//     String? value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'phoneno',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoLessThan(
//     String? value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'phoneno',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoBetween(
//     String? lower,
//     String? upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'phoneno',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       phonenoStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'phoneno',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'phoneno',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'phoneno',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'phoneno',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       phonenoIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'phoneno',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       phonenoIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'phoneno',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       utcLastUpdatedEqualTo(DateTime value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'utcLastUpdated',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       utcLastUpdatedGreaterThan(
//     DateTime value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'utcLastUpdated',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       utcLastUpdatedLessThan(
//     DateTime value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'utcLastUpdated',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
//       utcLastUpdatedBetween(
//     DateTime lower,
//     DateTime upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'utcLastUpdated',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension UserSettingQueryObject
//     on QueryBuilder<UserSetting, UserSetting, QFilterCondition> {}

// extension UserSettingQueryLinks
//     on QueryBuilder<UserSetting, UserSetting, QFilterCondition> {}

// extension UserSettingQuerySortBy
//     on QueryBuilder<UserSetting, UserSetting, QSortBy> {
//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsDarkMode() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isDarkMode', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsDarkModeDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isDarkMode', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsNewUser() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isNewUser', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsNewUserDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isNewUser', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByLanguageId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'languageId', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByLanguageIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'languageId', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByName() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'name', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByNameDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'name', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByPhoneno() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'phoneno', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByPhonenoDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'phoneno', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByUtcLastUpdated() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'utcLastUpdated', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy>
//       sortByUtcLastUpdatedDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'utcLastUpdated', Sort.desc);
//     });
//   }
// }

// extension UserSettingQuerySortThenBy
//     on QueryBuilder<UserSetting, UserSetting, QSortThenBy> {
//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenById() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsDarkMode() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isDarkMode', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsDarkModeDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isDarkMode', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsNewUser() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isNewUser', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsNewUserDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'isNewUser', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByLanguageId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'languageId', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByLanguageIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'languageId', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByName() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'name', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByNameDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'name', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByPhoneno() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'phoneno', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByPhonenoDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'phoneno', Sort.desc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByUtcLastUpdated() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'utcLastUpdated', Sort.asc);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QAfterSortBy>
//       thenByUtcLastUpdatedDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'utcLastUpdated', Sort.desc);
//     });
//   }
// }

// extension UserSettingQueryWhereDistinct
//     on QueryBuilder<UserSetting, UserSetting, QDistinct> {
//   QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByIsDarkMode() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'isDarkMode');
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByIsNewUser() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'isNewUser');
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByLanguageId(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'languageId', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByName(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByPhoneno(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'phoneno', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByUtcLastUpdated() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'utcLastUpdated');
//     });
//   }
// }

// extension UserSettingQueryProperty
//     on QueryBuilder<UserSetting, UserSetting, QQueryProperty> {
//   QueryBuilder<UserSetting, int, QQueryOperations> idProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'id');
//     });
//   }

//   QueryBuilder<UserSetting, bool?, QQueryOperations> isDarkModeProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'isDarkMode');
//     });
//   }

//   QueryBuilder<UserSetting, bool, QQueryOperations> isNewUserProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'isNewUser');
//     });
//   }

//   QueryBuilder<UserSetting, String?, QQueryOperations> languageIdProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'languageId');
//     });
//   }

//   QueryBuilder<UserSetting, String?, QQueryOperations> nameProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'name');
//     });
//   }

//   QueryBuilder<UserSetting, String?, QQueryOperations> phonenoProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'phoneno');
//     });
//   }

//   QueryBuilder<UserSetting, DateTime, QQueryOperations>
//       utcLastUpdatedProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'utcLastUpdated');
//     });
//   }
// }
