// ignore_for_file: avoid_catching_errors
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide an HTTP client.
final dioProvider = Provider((final ref) => Dio());
