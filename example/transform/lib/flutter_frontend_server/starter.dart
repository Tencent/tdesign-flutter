// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.8
library frontend_server;

import 'dart:io';

import 'package:frontend_server/frontend_server.dart';
import 'package:vm/target/flutter.dart';

import '../hook/demo_transformer.dart';

final DemoTransformer typeTransformer = DemoTransformer();

void main(List<String> args) async {
  ///在FlutterTarget中加入Transformer
  if (!FlutterTarget.flutterProgramTransformers.contains(typeTransformer)) {
    FlutterTarget.flutterProgramTransformers.add(typeTransformer);
  }

  final exitCode = await starter(args);
  if (exitCode != 0) {
    exit(exitCode);
  }
}
