// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notices _$NoticesFromJson(Map<String, dynamic> json) => Notices(
      (json['notices'] as List<dynamic>)
          .map((e) => Notice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NoticesToJson(Notices instance) => <String, dynamic>{
      'notices': instance.notices,
    };
