import 'package:flutter/material.dart';
import 'package:wareflow/models/tile_model.dart';

class StockouttileData {
  static List<Tile> getTileData() {
    return [
      Tile(
        icon: Icons.location_on,
        title: "Location",
        subtitle: "Default Location",
        txtcolor: Colors.black,
      ),
      Tile(
        icon: Icons.person,
        title: "Customer",
        subtitle: "3q international",
        txtcolor: Colors.black,
      ),
      Tile(
        icon: Icons.add_box,
        title: "Item",
        subtitle: "4 items",
        txtcolor: Colors.black,
      ),
      Tile(
        icon: Icons.note,
        title: "Notes",
        subtitle: "this is the sample one",
        txtcolor: Colors.black,
      ),
    ];
  }
}
