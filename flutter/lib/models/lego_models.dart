import 'package:json_annotation/json_annotation.dart';

part 'lego_models.g.dart';

/// LEGO Set data model from Rebrickable API
@JsonSerializable()
class LegoSet {
  @JsonKey(name: 'set_num')
  final String setNum;
  final String name;
  final int year;
  @JsonKey(name: 'theme_id')
  final int themeId;
  @JsonKey(name: 'num_parts')
  final int numParts;
  @JsonKey(name: 'set_img_url')
  final String? setImgUrl;
  @JsonKey(name: 'set_url')
  final String? setUrl;
  @JsonKey(name: 'last_modified_dt')
  final String lastModifiedDt;

  LegoSet({
    required this.setNum,
    required this.name,
    required this.year,
    required this.themeId,
    required this.numParts,
    this.setImgUrl,
    this.setUrl,
    required this.lastModifiedDt,
  });

  factory LegoSet.fromJson(Map<String, dynamic> json) => _$LegoSetFromJson(json);
  Map<String, dynamic> toJson() => _$LegoSetToJson(this);
}

/// LEGO Part data model from Rebrickable API
@JsonSerializable()
class LegoPart {
  @JsonKey(name: 'part_num')
  final String partNum;
  final String name;
  @JsonKey(name: 'part_cat_id')
  final int partCatId;
  @JsonKey(name: 'part_url')
  final String? partUrl;
  @JsonKey(name: 'part_img_url')
  final String? partImgUrl;
  @JsonKey(name: 'external_ids')
  final Map<String, List<String>>? externalIds;
  @JsonKey(name: 'print_of')
  final String? printOf;

  LegoPart({
    required this.partNum,
    required this.name,
    required this.partCatId,
    this.partUrl,
    this.partImgUrl,
    this.externalIds,
    this.printOf,
  });

  factory LegoPart.fromJson(Map<String, dynamic> json) => _$LegoPartFromJson(json);
  Map<String, dynamic> toJson() => _$LegoPartToJson(this);
}

/// LEGO Theme data model from Rebrickable API
@JsonSerializable()
class LegoTheme {
  final int id;
  final String name;
  @JsonKey(name: 'parent_id')
  final int? parentId;

  LegoTheme({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory LegoTheme.fromJson(Map<String, dynamic> json) => _$LegoThemeFromJson(json);
  Map<String, dynamic> toJson() => _$LegoThemeToJson(this);
}

/// Color data model from Rebrickable API
@JsonSerializable()
class LegoColor {
  final int id;
  final String name;
  final String rgb;
  @JsonKey(name: 'is_trans')
  final bool isTrans;

  LegoColor({
    required this.id,
    required this.name,
    required this.rgb,
    required this.isTrans,
  });

  factory LegoColor.fromJson(Map<String, dynamic> json) => _$LegoColorFromJson(json);
  Map<String, dynamic> toJson() => _$LegoColorToJson(this);
}