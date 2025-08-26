// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lego_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegoSet _$LegoSetFromJson(Map<String, dynamic> json) => LegoSet(
      setNum: json['set_num'] as String,
      name: json['name'] as String,
      year: json['year'] as int,
      themeId: json['theme_id'] as int,
      numParts: json['num_parts'] as int,
      setImgUrl: json['set_img_url'] as String?,
      setUrl: json['set_url'] as String?,
      lastModifiedDt: json['last_modified_dt'] as String,
    );

Map<String, dynamic> _$LegoSetToJson(LegoSet instance) => <String, dynamic>{
      'set_num': instance.setNum,
      'name': instance.name,
      'year': instance.year,
      'theme_id': instance.themeId,
      'num_parts': instance.numParts,
      'set_img_url': instance.setImgUrl,
      'set_url': instance.setUrl,
      'last_modified_dt': instance.lastModifiedDt,
    };

LegoPart _$LegoPartFromJson(Map<String, dynamic> json) => LegoPart(
      partNum: json['part_num'] as String,
      name: json['name'] as String,
      partCatId: json['part_cat_id'] as int,
      partUrl: json['part_url'] as String?,
      partImgUrl: json['part_img_url'] as String?,
      externalIds: (json['external_ids'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      printOf: json['print_of'] as String?,
    );

Map<String, dynamic> _$LegoPartToJson(LegoPart instance) => <String, dynamic>{
      'part_num': instance.partNum,
      'name': instance.name,
      'part_cat_id': instance.partCatId,
      'part_url': instance.partUrl,
      'part_img_url': instance.partImgUrl,
      'external_ids': instance.externalIds,
      'print_of': instance.printOf,
    };

LegoTheme _$LegoThemeFromJson(Map<String, dynamic> json) => LegoTheme(
      id: json['id'] as int,
      name: json['name'] as String,
      parentId: json['parent_id'] as int?,
    );

Map<String, dynamic> _$LegoThemeToJson(LegoTheme instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
    };

LegoColor _$LegoColorFromJson(Map<String, dynamic> json) => LegoColor(
      id: json['id'] as int,
      name: json['name'] as String,
      rgb: json['rgb'] as String,
      isTrans: json['is_trans'] as bool,
    );

Map<String, dynamic> _$LegoColorToJson(LegoColor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rgb': instance.rgb,
      'is_trans': instance.isTrans,
    };