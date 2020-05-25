import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

///Item Position
///
///Represents a position where a checkpoint can be
class ItemPosition extends Equatable {
  ///Column position
  final int col;

  ///Row position
  final int row;

  ///Default constructor
  ItemPosition({@required this.col, @required this.row});

  @override
  List<Object> get props => [col, row];
}
