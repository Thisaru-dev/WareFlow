import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:wareflow/models/item_model.dart';
import 'package:wareflow/pdf/save_and_open_pdf.dart';

class SalesOrderPdf {
  static Future<File> generateInvoicePdf({
    required String soId,
    required String organizationName,
    required String organizationEmail,
    required String customerName,
    required DateTime dueDate,
    required List<ItemModel> items,
    required double taxRate,
  }) async {
    final pdf = Document();

    // calculate totals
    double subtotal = items.fold(
      0,
      (sum, item) => sum + item.quantity * item.price,
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
                                organizationName,
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
                                organizationEmail,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          SizedBox(width: 2.9 * PdfPageFormat.inch),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('INVOICE', style: TextStyle(fontSize: 24)),
                              SizedBox(height: .5 * PdfPageFormat.mm),
                              Text(
                                soId,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 1 * PdfPageFormat.cm),
                              Text(
                                'Invoice date: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}',
                              ),
                              SizedBox(height: .5 * PdfPageFormat.mm),
                              Text(
                                'Due date: ${DateFormat('MMMM d, yyyy').format(dueDate)}',
                              ),
                            ],
                          ),
                        ],
                      ),

                      // vendor address
                      SizedBox(height: 1 * PdfPageFormat.cm),
                      Text('Bill To', style: TextStyle(fontSize: 14)),
                      SizedBox(height: .5 * PdfPageFormat.mm),
                      Text(customerName, style: TextStyle(fontSize: 12)),
                      SizedBox(height: 5 * PdfPageFormat.mm),
                      //table
                      Table(
                        tableWidth: TableWidth.max,
                        border: TableBorder.all(),
                        columnWidths: {
                          0: FixedColumnWidth(30),
                          1: FixedColumnWidth(100),
                          2: FixedColumnWidth(150),
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
                            final itemTotal = item.quantity * item.price;
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.id),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.name),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.description),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.quantity.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(item.price.toString()),
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
    return SaveAndOpenPDF.savePdf(name: "invoice_$timestamp.pdf", pdf: pdf);
  }
}
