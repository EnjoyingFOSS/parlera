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
//
// This file is derived from work covered by the following license notice:
//
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/widgets.dart';
import 'package:parlera/store/store.dart';

class GalleryModel extends StoreModel {
  FileSystemEntity? _activeImage;
  FileSystemEntity? get activeImage => _activeImage;

  List<FileSystemEntity> _images = [];
  List<FileSystemEntity> get images => _images;

  void update(List<FileSystemEntity> images) {
    _images = images;
    notifyListeners();
  }

  void setActive(FileSystemEntity? image) {
    _activeImage = image;
    notifyListeners();
  }

  static GalleryModel of(BuildContext context) =>
      ScopedModel.of<GalleryModel>(context);
}
