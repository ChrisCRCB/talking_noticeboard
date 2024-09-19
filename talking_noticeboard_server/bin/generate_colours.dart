// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';

/// The URL where colours can be found.
const url = 'https://api.flutter.dev/flutter/material/Colors-class.html';

/// A script to generate colours files.
Future<void> main() async {
  final dio = Dio();
  final response = await dio.get<String>(url);
  final document = parse(response.data);
  final section = document.getElementById('constants')!;
  final elements = section.getElementsByTagName('dl');
  if (elements.length != 1) {
    return print('Expected 1 dl, found ${elements.length}.');
  }
  final dl = elements.single;
  final colourNames = <String>[];
  final colourDescriptions = <String>[];
  for (final dt in dl.getElementsByTagName('dt')) {
    final a = dt.getElementsByTagName('a')[1];
    final colorName = dt.text.trim().split('\n').first;
    final href = a.attributes['href'] as String;
    if (!href.startsWith('dart-ui/Color-class.html')) {
      print('Skipping $colorName.');
      continue;
    }
    colourNames.add(colorName);
    final dd = dt.nextElementSibling!;
    colourDescriptions.add(dd.text.trim());
  }
  if (colourNames.length != colourDescriptions.length) {
    print(
      'Colour names: ${colourNames.length}.',
    );
    return print(
      'Colour descriptions: ${colourDescriptions.length}.',
    );
  }
  final enumBuffer = StringBuffer()
    ..writeln('### Possible colours.')
    ..writeln('enum: Colours')
    ..writeln('values:');
  for (var i = 0; i < colourNames.length; i++) {
    final colourName = colourNames[i];
    final colourDescription = colourDescriptions[i];
    enumBuffer
      ..writeln('  ### $colourDescription')
      ..writeln('  - $colourName');
  }
  File('lib/src/models/colours.spy.yaml').writeAsStringSync(
    enumBuffer.toString(),
  );
  final extensionStringBuffer = StringBuffer()
    ..writeln('// ignore_for_file: prefer_single_quotes')
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln(
      "import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';",
    )
    ..writeln()
    ..writeln("import 'friendly_colour.dart';")
    ..writeln()
    ..writeln('/// Convert [Colours] to [Colors].')
    ..writeln('extension ColoursX on Colours {')
    ..writeln('  /// Return a Flutter-friendly color.')
    ..writeln('  Color get color => switch(this) {');
  for (final colourName in colourNames) {
    extensionStringBuffer.writeln(
      '    Colours.$colourName => Colors.$colourName,',
    );
  }
  extensionStringBuffer
    ..writeln('  };')
    ..writeln()
    ..writeln(' /// Returns a list of friendly colours.')
    ..writeln('List<FriendlyColour> get friendlyColours => const [');
  for (var i = 0; i < colourNames.length; i++) {
    final colourName = colourNames[i];
    final colourDescription = colourDescriptions[i];
    extensionStringBuffer
      ..writeln('    FriendlyColour(')
      ..writeln(
        '      serverColour: Colours.$colourName,',
      )
      ..writeln('      flutterColour: Colors.$colourName,')
      ..writeln('      description: ${jsonEncode(colourDescription)},')
      ..writeln('    ),');
  }
  extensionStringBuffer
    ..writeln('  ];')
    ..writeln('}');
  File('../talking_noticeboard_flutter/lib/src/colours_extension.dart')
      .writeAsStringSync(
    extensionStringBuffer.toString(),
  );
}
