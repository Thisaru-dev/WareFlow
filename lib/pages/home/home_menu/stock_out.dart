import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wareflow/constants/constants.dart';
import 'package:wareflow/data/stockouttile_data.dart';
import 'package:wareflow/models/tile_model.dart';

class StockOut extends StatefulWidget {
  const StockOut({super.key});

  @override
  State<StockOut> createState() => _StockOutState();
}

class _StockOutState extends State<StockOut> {
  List<Tile> _tiles = StockouttileData.getTileData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tiles = StockouttileData.getTileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: Text("Stock Out", style: kTitleTextStyle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      "Stock Out",
                      style: kPrimaryTextStyle.copyWith(
                        fontSize: 23,
                        color: Colors.red,
                      ),
                    ),
                    Spacer(),
                    Text(
                      DateFormat('MMMM d, yyyy').format(DateTime.now()),
                      style: kSecondaryTextStyle,
                    ),
                  ],
                ),
              ),
              Divider(thickness: 5, color: Colors.red),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _tiles.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print(index);
                      },
                      child: Text("data"),
                    );
                  },
                ),
              ),
              Spacer(),
              //draft button
              SizedBox(
                width: 350,
                height: 50,
                child: FilledButton(
                  onPressed: () {},
                  style: kButtonStyle.copyWith(
                    backgroundColor: WidgetStatePropertyAll(Colors.blueGrey),
                  ),
                  child: Text(
                    "Draft",
                    style: kButtonTextStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: 3),
              //submit button
              SizedBox(
                width: 350,
                height: 50,
                child: FilledButton(
                  onPressed: () {},
                  style: kButtonStyle,
                  child: Text(
                    "Submit",
                    style: kButtonTextStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
