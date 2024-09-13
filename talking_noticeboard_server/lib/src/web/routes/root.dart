import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../widgets/default_page_widget.dart';

/// The root widget.
class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(
    final Session session,
    final HttpRequest request,
  ) async =>
      DefaultPageWidget();
}
