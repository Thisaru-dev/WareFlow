import 'package:flutter/material.dart';

Future<int?> showQuantityDialog(
  BuildContext context,
  String productName, {
  int initialQty = 1,
}) async {
  int quantity = initialQty;

  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter Quantity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(productName, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      quantity--;
                      (context as Element).markNeedsBuild(); // Refresh dialog
                    }
                  },
                ),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('$quantity', style: TextStyle(fontSize: 18)),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    quantity++;
                    (context as Element).markNeedsBuild(); // Refresh dialog
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, quantity), // Confirm
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );
}
