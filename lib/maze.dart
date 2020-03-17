import 'dart:math';
import 'package:flutter/material.dart' hide Stack;
import 'package:stack/stack.dart';

enum Direction { UP, DOWN, LEFT, RIGHT }

class MazePainter extends ChangeNotifier implements CustomPainter {
  final columns = 7;
  final rows = 10;
  final wallThickness = 5.0;

  Cell player, exit;
  List<List<Cell>> _cells;
  Paint _exitPaint = Paint();
  Paint _playerPaint = Paint();
  Paint _wallPaint = Paint();
  Random _randomizer = Random();
  double _cellSize, _hMargin, _vMargin;

  double userX;
  double userY;

  MazePainter() {
    _wallPaint
      ..color = Colors.black
      ..isAntiAlias = true
      ..strokeWidth = wallThickness;

    _playerPaint..color = Colors.red;

    _exitPaint..color = Colors.blue;

    _createMaze();
  }

  void _createMaze() {
    Stack<Cell> stack = Stack();
    Cell current, next;

    _cells =
        List.generate(columns, (c) => List.generate(rows, (r) => Cell(c, r)));

    player = _cells.first.first;
    exit = _cells.last.last;

    current = _cells.first.first;
    current.visited = true;

    do {
      next = _getNext(current);
      if (next != null) {
        _removeWall(current, next);
        stack.push(current);
        current = next;
        current.visited = true;
      } else {
        current = stack.pop();
      }
    } while (stack.isNotEmpty);
  }

  @override
  bool hitTest(Offset position) {
    return null;
  }

  void movePlayer(Direction direction) {
    switch (direction) {
      case Direction.UP:
        {
          if (!player.topWall) player = _cells[player.col][player.row - 1];
          break;
        }
      case Direction.DOWN:
        {
          if (!player.bottomWall) player = _cells[player.col][player.row + 1];
          break;
        }
      case Direction.LEFT:
        {
          if (!player.leftWall) player = _cells[player.col - 1][player.row];
          break;
        }
      case Direction.RIGHT:
        {
          if (!player.rightWall) player = _cells[player.col + 1][player.row];
          break;
        }
    }
  }

  void updatePosition(Offset position) {
    userX = position.dx;
    userY = position.dy;
    notifyListeners();

    double playerCenterX = _hMargin + (player.col + 0.5) * _cellSize;
    double playerCenterY = _vMargin + (player.row + 0.5) * _cellSize;

    double dx = userX - playerCenterX;
    double dy = userY - playerCenterY;

    double absDx = dx.abs();
    double absDy = dy.abs();

    if (absDx > _cellSize || absDy > _cellSize) {
      if (absDx > absDy) {
        // X
        if (dx > 0) {
          movePlayer(Direction.RIGHT);
        } else {
          movePlayer(Direction.LEFT);
        }
      } else {
        // Y
        if (dy > 0) {
          movePlayer(Direction.DOWN);
        } else {
          movePlayer(Direction.UP);
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.greenAccent, BlendMode.src);

    if (size.width / size.height < columns / rows)
      _cellSize = size.width / (columns + 1);
    else
      _cellSize = size.height / (rows + 1);

    _hMargin = (size.width - columns * _cellSize) / 2;
    _vMargin = (size.height - rows * _cellSize) / 2;

    double squareMargin = _cellSize / 10;

    canvas.translate(_hMargin, _vMargin);

    _cells.forEach((v) => v.forEach((cell) {
          if (cell.topWall)
            canvas.drawLine(
                Offset(cell.col * _cellSize, cell.row * _cellSize),
                Offset((cell.col + 1) * _cellSize, cell.row * _cellSize),
                _wallPaint);

          if (cell.leftWall)
            canvas.drawLine(
                Offset(cell.col * _cellSize, cell.row * _cellSize),
                Offset(cell.col * _cellSize, (cell.row + 1) * _cellSize),
                _wallPaint);

          if (cell.bottomWall)
            canvas.drawLine(
                Offset(cell.col * _cellSize, (cell.row + 1) * _cellSize),
                Offset((cell.col + 1) * _cellSize, (cell.row + 1) * _cellSize),
                _wallPaint);

          if (cell.rightWall)
            canvas.drawLine(
                Offset((cell.col + 1) * _cellSize, cell.row * _cellSize),
                Offset((cell.col + 1) * _cellSize, (cell.row + 1) * _cellSize),
                _wallPaint);
        }));

    canvas.drawRect(
        Rect.fromPoints(
            Offset(player.col * _cellSize + squareMargin,
                player.row * _cellSize + squareMargin),
            Offset((player.col + 1) * _cellSize - squareMargin,
                (player.row + 1) * _cellSize - squareMargin)),
        _playerPaint);

    canvas.drawRect(
        Rect.fromPoints(
            Offset(exit.col * _cellSize + squareMargin,
                exit.row * _cellSize + squareMargin),
            Offset((exit.col + 1) * _cellSize - squareMargin,
                (exit.row + 1) * _cellSize - squareMargin)),
        _exitPaint);
  }

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return null;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Cell _getNext(Cell cell) {
    List<Cell> neighbours = [];

    //Left
    if (cell.col > 0) {
      if (!_cells[cell.col - 1][cell.row].visited)
        neighbours.add(_cells[cell.col - 1][cell.row]);
    }

    //Right
    if (cell.col < columns - 1) {
      if (!_cells[cell.col + 1][cell.row].visited)
        neighbours.add(_cells[cell.col + 1][cell.row]);
    }

    //Top
    if (cell.row > 0) {
      if (!_cells[cell.col][cell.row - 1].visited)
        neighbours.add(_cells[cell.col][cell.row - 1]);
    }

    //Bottom
    if (cell.row < rows - 1) {
      if (!_cells[cell.col][cell.row + 1].visited)
        neighbours.add(_cells[cell.col][cell.row + 1]);
    }
    if (neighbours.length > 0) {
      final index = _randomizer.nextInt(neighbours.length);
      return neighbours[index];
    }
    return null;
  }

  void _removeWall(Cell current, Cell next) {
    //Below
    if (current.col == next.col && current.row == next.row + 1) {
      current.topWall = false;
      next.bottomWall = false;
    }

    //Above
    if (current.col == next.col && current.row == next.row - 1) {
      current.bottomWall = false;
      next.topWall = false;
    }

    //Right
    if (current.col == next.col + 1 && current.row == next.row) {
      current.leftWall = false;
      next.rightWall = false;
    }

    //Left
    if (current.col == next.col - 1 && current.row == next.row) {
      current.rightWall = false;
      next.leftWall = false;
    }
  }
}

// class MazePainter extends CustomPainter {
//   final columns = 7;
//   final rows = 10;
//   final wallThickness = 5.0;

//   Cell player, exit;
//   List<List<Cell>> _cells;
//   Paint _exitPaint = Paint();
//   Paint _playerPaint = Paint();
//   Paint _wallPaint = Paint();
//   Random _randomizer = Random();
//   double _cellSize, _hMargin, _vMargin;

//   double userX;
//   double userY;

//   MazePainter({this.userX, this.userY}) {
//     print('${this.userX}, ${this.userY}');

//     _wallPaint
//       ..color = Colors.black
//       ..isAntiAlias = true
//       ..strokeWidth = wallThickness;

//     _playerPaint..color = Colors.red;

//     _exitPaint..color = Colors.blue;

//     _createMaze();
//   }

//   void _createMaze() {
//     Stack<Cell> stack = Stack();
//     Cell current, next;

//     _cells =
//         List.generate(columns, (c) => List.generate(rows, (r) => Cell(c, r)));

//     player = _cells.first.first;
//     exit = _cells.last.last;

//     current = _cells.first.first;
//     current.visited = true;

//     do {
//       next = _getNext(current);
//       if (next != null) {
//         _removeWall(current, next);
//         stack.push(current);
//         current = next;
//         current.visited = true;
//       } else {
//         current = stack.pop();
//       }
//     } while (stack.isNotEmpty);
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawColor(Colors.greenAccent, BlendMode.src);

//     if (size.width / size.height < columns / rows)
//       _cellSize = size.width / (columns + 1);
//     else
//       _cellSize = size.height / (rows + 1);

//     _hMargin = (size.width - columns * _cellSize) / 2;
//     _vMargin = (size.height - rows * _cellSize) / 2;

//     double squareMargin = _cellSize / 10;

//     canvas.translate(_hMargin, _vMargin);

//     _cells.forEach((v) => v.forEach((cell) {
//           if (cell.topWall)
//             canvas.drawLine(
//                 Offset(cell.col * _cellSize, cell.row * _cellSize),
//                 Offset((cell.col + 1) * _cellSize, cell.row * _cellSize),
//                 _wallPaint);

//           if (cell.leftWall)
//             canvas.drawLine(
//                 Offset(cell.col * _cellSize, cell.row * _cellSize),
//                 Offset(cell.col * _cellSize, (cell.row + 1) * _cellSize),
//                 _wallPaint);

//           if (cell.bottomWall)
//             canvas.drawLine(
//                 Offset(cell.col * _cellSize, (cell.row + 1) * _cellSize),
//                 Offset((cell.col + 1) * _cellSize, (cell.row + 1) * _cellSize),
//                 _wallPaint);

//           if (cell.rightWall)
//             canvas.drawLine(
//                 Offset((cell.col + 1) * _cellSize, cell.row * _cellSize),
//                 Offset((cell.col + 1) * _cellSize, (cell.row + 1) * _cellSize),
//                 _wallPaint);
//         }));

//     canvas.drawRect(
//         Rect.fromPoints(
//             Offset(player.col * _cellSize + squareMargin,
//                 player.row * _cellSize + squareMargin),
//             Offset((player.col + 1) * _cellSize - squareMargin,
//                 (player.row + 1) * _cellSize - squareMargin)),
//         _playerPaint);

//     canvas.drawRect(
//         Rect.fromPoints(
//             Offset(exit.col * _cellSize + squareMargin,
//                 exit.row * _cellSize + squareMargin),
//             Offset((exit.col + 1) * _cellSize - squareMargin,
//                 (exit.row + 1) * _cellSize - squareMargin)),
//         _exitPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }

//   Cell _getNext(Cell cell) {
//     List<Cell> neighbours = [];

//     //Left
//     if (cell.col > 0) {
//       if (!_cells[cell.col - 1][cell.row].visited)
//         neighbours.add(_cells[cell.col - 1][cell.row]);
//     }

//     //Right
//     if (cell.col < columns - 1) {
//       if (!_cells[cell.col + 1][cell.row].visited)
//         neighbours.add(_cells[cell.col + 1][cell.row]);
//     }

//     //Top
//     if (cell.row > 0) {
//       if (!_cells[cell.col][cell.row - 1].visited)
//         neighbours.add(_cells[cell.col][cell.row - 1]);
//     }

//     //Bottom
//     if (cell.row < rows - 1) {
//       if (!_cells[cell.col][cell.row + 1].visited)
//         neighbours.add(_cells[cell.col][cell.row + 1]);
//     }
//     if (neighbours.length > 0) {
//       final index = _randomizer.nextInt(neighbours.length);
//       return neighbours[index];
//     }
//     return null;
//   }

//   void _removeWall(Cell current, Cell next) {
//     //Below
//     if (current.col == next.col && current.row == next.row + 1) {
//       current.topWall = false;
//       next.bottomWall = false;
//     }

//     //Above
//     if (current.col == next.col && current.row == next.row - 1) {
//       current.bottomWall = false;
//       next.topWall = false;
//     }

//     //Right
//     if (current.col == next.col + 1 && current.row == next.row) {
//       current.leftWall = false;
//       next.rightWall = false;
//     }

//     //Left
//     if (current.col == next.col - 1 && current.row == next.row) {
//       current.rightWall = false;
//       next.leftWall = false;
//     }
//   }
// }

class Cell {
  bool bottomWall = true;
  bool leftWall = true;
  bool rightWall = true;
  bool topWall = true;
  bool visited = false;

  int col;
  int row;

  Cell(this.col, this.row);
}