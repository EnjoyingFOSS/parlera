// Copyright Miroslav Mazel
//
// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// As an additional permission under section 7, you are allowed to distribute
// the software through an app store, even if that store has restrictive terms
// and conditions that are incompatible with the AGPL, provided that the source
// is also available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// As a limitation under section 7, all unofficial builds and forks of the app
// must be clearly labeled as unofficial in the app's name (e.g. "Parlera
// UNOFFICIAL", never just "Parlera") or use a different name altogether.
// If any code changes are made, the fork should use a completely different name
// and app icon. All unofficial builds and forks MUST use a different
// application ID, in order to not conflict with a potential official release.
//
// Parlera is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Parlera.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlera/models/full_deck_companion.dart';
import 'package:parlera/models/parlera_locale.dart';
import 'package:parlera/providers/deck_list_provider.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImportExportHelper {
  static Future<void> exportAndShareJson(
      Map jsonMap, String fileName, String shareSubject) async {
    final outputContent = jsonEncode(jsonMap);
    if (Platform.isMacOS || Platform.isLinux) {
      final outputFile = await FilePicker.platform.saveFile(
        dialogTitle: "",
        fileName: fileName,
      );

      if (outputFile != null) {
        await File(outputFile).writeAsString(outputContent, flush: true);
      }
    } else {
      final outputDir = Platform.isAndroid
          ? await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory()
          : await getApplicationDocumentsDirectory();
      final String outputPath = join(outputDir.path, fileName);

      final outputFile = File(outputPath);
      await outputFile.writeAsString(outputContent, flush: true);
      await Share.shareXFiles([XFile(outputPath, mimeType: "application/json")],
          subject: shareSubject);
    }
  }

  static Future<void> importFile(
      //TODO allow importing entire ZIPs
      //TODO test on linux
      PlatformFile inputFile,
      WidgetRef ref,
      ParleraLocale lang) async {
    late final String inputPath;

    if (Platform.isLinux) {
      //duplicate to temporary directory if on Linux

      final inputBytes = inputFile.bytes;

      if (inputBytes == null) {
        throw const FormatException("Empty input bytes");
      }

      final tempDir = await getTemporaryDirectory();

      inputPath = join(tempDir.path, 'tempParlera.parlera');

      await File(inputPath).writeAsBytes(inputBytes);
    } else {
      inputPath = inputFile.path!;
    }

    final fdc = FullDeckCompanion.fromJson(
        jsonDecode(await File(inputPath).readAsString())
            as Map<String, dynamic>,
        lang);

    await ref
        .read(deckListProvider.notifier)
        .createOrUpdateCustomDeck(fdc);
  }
}
