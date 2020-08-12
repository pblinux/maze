# maze_game

A simple maze game in Flutter. It also serves as a CustomPainter example.

<img src="https://raw.githubusercontent.com/pblinux/maze/package/img/maze.png" height="350">

## ¿Why?

In another project, I needed to create a "simple" maze game that can be used in low-end devices, so game engine was not an option.

Suddenly, I found a way to do it in pure Android.

[![Maze](https://img.youtube.com/vi/I9lTBTAk5MU/0.jpg)](https://www.youtube.com/watch?v=I9lTBTAk5MU)

So, this is a "port" of that saviour example.

## Maze package

[![pub](https://img.shields.io/badge/pub-1.0.0-blue)](https://pub.dev/packages/maze)
[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/pblinux/end_credits)

You can use it in your project, you only need to add the dependency:

```yaml
dependencies:
  flutter:
    sdk: flutter
  maze_game: 2.0.0
```

Now you can create your Maze:

```dart
Maze(
    player: MazeItem(
        'https://image.flaticon.com/icons/png/512/808/808433.png',
        ImageType.network),
    columns: 6,
    rows: 12,
    wallThickness: 4.0,
    wallColor: Theme.of(context).primaryColor,
    finish: MazeItem(
        'https://image.flaticon.com/icons/png/512/1506/1506339.png',
        ImageType.network),
    onFinish: () => print('Hi from finish line!'))
```


