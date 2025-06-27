import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wareflow/models/po_item_model.dart';
import 'package:wareflow/pdf/save_and_open_pdf.dart';

class PurchaseOrderPdf {
  static Future<File> generatePurchaseOrderPdf(
    String poId,
    String warehouseName,
    String warehouseEmail,
    String supplierName,
    DateTime date,
    String supplierAddress,
    List<PoItemModel> items,
    double taxRate,
  ) async {
    final pdf = Document();

    // calculate totals
    double subtotal = items.fold(
      0,
      (sum, item) => sum + item.orderedQty * item.unitPrice,
    );
    double tax = subtotal * taxRate;
    double total = subtotal + tax;

    // final headers = [
    //   '#',
    //   'Item',
    //   'Description',
    //   'Quantity',
    //   'Unit Price',
    //   'Amount',
    // ];
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        footer: (Context context) {
          return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: TextStyle(fontSize: 12, color: PdfColors.grey),
            ),
          );
        },
        build:
            (context) => [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                warehouseName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1 * PdfPageFormat.mm),
                              Text(
                                'Western Province',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: .5 * PdfPageFormat.mm),
                              Text('Sri Lanka', style: TextStyle(fontSize: 12)),
                              SizedBox(height: .5 * PdfPageFormat.mm),
                              Text(
                                warehouseEmail,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          SizedBox(width: 3 * PdfPageFormat.cm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'PURCHASE ORDER',
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(height: .5 * PdfPageFormat.mm),
                              Text(
                                poId,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: .5 * PdfPageFormat.mm),
                              Text(
                                'Date: ${DateFormat('MMMM d, yyyy').format(date)}',
                              ),
                            ],
                          ),
                        ],
                      ),

                      // vendor address
                      SizedBox(height: 1 * PdfPageFormat.cm),
                      Text('Vendor Details', style: TextStyle(fontSize: 14)),
                      SizedBox(height: .5 * PdfPageFormat.mm),
                      Text(supplierName, style: TextStyle(fontSize: 12)),
                      SizedBox(height: .5 * PdfPageFormat.mm),
                      Text(
                        supplierAddress,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // deliver to
                      SizedBox(height: 1 * PdfPageFormat.cm),
                      Text('Deliver To', style: TextStyle(fontSize: 14)),
                      SizedBox(height: .5 * PdfPageFormat.mm),
                      Text('Western Province', style: TextStyle(fontSize: 12)),
                      SizedBox(height: .5 * PdfPageFormat.mm),
                      Text('Sri Lanka', style: TextStyle(fontSize: 12)),
                      SizedBox(height: .5 * PdfPageFormat.mm),
                      Text(warehouseEmail, style: TextStyle(fontSize: 12)),
                      SizedBox(height: 1 * PdfPageFormat.cm),
                      //table
                      Table(
                        tableWidth: TableWidth.max,
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FixedColumnWidth(50),
                          1: FixedColumnWidth(100),
                          2: FixedColumnWidth(100),
                          3: FixedColumnWidth(50),
                          4: FixedColumnWidth(80),
                          5: FixedColumnWidth(60),
                        },

                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: PdfColors.black),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '#',
                                  style: TextStyle(color: PdfColors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Item',
                                  style: TextStyle(color: PdfColors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Description',
                                  style: TextStyle(color: PdfColors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Qty',
                                  style: TextStyle(color: PdfColors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Unit Price',
                                  style: TextStyle(color: PdfColors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Amount',
                                  style: TextStyle(color: PdfColors.white),
                                ),
                              ),
                            ],
                          ),
                          // data rows
                          ...items.map((item) {
                            final itemTotal = item.orderedQty * item.unitPrice;
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.itemId),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.itemName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.itemName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.orderedQty.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.unitPrice.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(itemTotal.toString()),
                                ),
                              ],
                            );
                          }),

                          //sub total row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('Sub Total'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(subtotal.toStringAsFixed(2)),
                              ),
                            ],
                          ),
                          //Total row
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  total.toStringAsFixed(2),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
      ),
    );
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return SaveAndOpenPDF.savePdf(
      name: "purchase_order_$timestamp.pdf",
      pdf: pdf,
    );
  }
}
