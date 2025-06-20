// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) => Notice(
  text: json['text'] as String,
  soundPath: json['soundPath'] as String?,
);

Map<String, dynamic> _$NoticeToJson(Notice instance) => <String, dynamic>{
  'text': instance.text,
  'soundPath': instance.soundPath,
};
