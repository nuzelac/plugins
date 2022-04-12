// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';

import 'shared_preferences_platform_interface.dart';

const MethodChannel _kChannel =
    MethodChannel('plugins.flutter.io/shared_preferences');

/// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing
/// a persistent store for simple data.
///
/// Data is persisted to disk asynchronously.
class MethodChannelSharedPreferencesStore
    extends SharedPreferencesStorePlatform {
  @override
  Future<bool> remove(String key) async {
    return (await _kChannel.invokeMethod<bool>(
      'remove',
      <String, dynamic>{'key': key},
    ))!;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    return (await _kChannel.invokeMethod<bool>(
      'set$valueType',
      <String, dynamic>{'key': key, 'value': value},
    ))!;
  }

  @override
  Future<bool> clear(Map<String, dynamic> params) async {
    return (await _kChannel.invokeMethod<bool>(
      'clear',
      params,
    ))!;
  }

  @override
  Future<Map<String, Object>> getAll(Map<String, dynamic> params) async {
    final Map<String, Object>? preferences =
        await _kChannel.invokeMapMethod<String, Object>(
      'getAll',
      params,
    );

    if (preferences == null) return <String, Object>{};
    return preferences;
  }
}
