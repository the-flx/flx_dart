[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/github/tag/the-flx/flx_dart.svg?label=release&logo=github)](https://github.com/the-flx/flx_dart/releases/latest)
![Pub Publisher](https://img.shields.io/pub/publisher/the_flx?logo=dart&logoColor=29B6F6)
[![pub package](https://img.shields.io/pub/v/the_flx.svg?logo=dart&logoColor=29B6F6)](https://pub.dev/packages/the_flx)

# flx_dart
> Rewrite emacs-flx in Dart

[![CI](https://github.com/the-flx/flx_dart/actions/workflows/test.yml/badge.svg)](https://github.com/the-flx/flx_dart/actions/workflows/test.yml)

## 🔨 Usage

```dart
Result? result = Flx.score("switch-to-buffer", "stb");
print(result?.score); // 237
```

## ⚜️ License

`flx_dart` is distributed under the terms of the MIT license.

See [`LICENSE`](./LICENSE) for details.


<!-- Links -->

[flx]: https://github.com/lewang/flx
[Emacs]: https://www.gnu.org/software/emacs/
