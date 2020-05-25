///Cell
///
///Holds a position in the maze.
///Have `walls` and a [col][row] position
class Cell {
  ///Bottom wall
  bool bottomWall = true;

  ///Left wall
  bool leftWall = true;

  ///Right wall
  bool rightWall = true;

  ///Top wall
  bool topWall = true;

  ///The player has been passed in this cell?
  bool visited = false;

  ///Column position
  int col;

  ///Row position
  int row;

  ///Default constructor
  Cell(this.col, this.row);
}
