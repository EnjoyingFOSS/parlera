// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version. As an additional permission under
// section 7, you are allowed to distribute the software through an app
// store, even if that store has restrictive terms and conditions that
// are incompatible with the AGPL, provided that the source is also
// available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
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
import 'package:path/path.dart' show join;

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

import '../models/editable_category.dart';
import '../models/language.dart';
import '../store/category.dart';

class ImportExportHelper {
  static Future<void> exportJson(
      Map jsonMap, String fileName, String shareSubject) async {
    final outputContent = json.encode(jsonMap);
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
      await Share.shareFiles([outputPath],
          mimeTypes: const ["application/json"], subject: shareSubject);
    }
  }

  static Future<void> importFile(
      //TODO test on linux
      PlatformFile inputFile,
      CategoryModel model,
      ParleraLanguage lang) async {
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

    final ec = EditableCategory.fromJson(
        jsonDecode(await File(inputPath).readAsString()), lang);
    model.createOrUpdateCustomCategory(ec);
  }
}
