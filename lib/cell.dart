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
