import 'package:wareflow/models/pr_log_model.dart';

class PrLogSampleData {
  static List<PrLogModel> getPrLogSampleData() {
    return [
      PrLogModel(
        title: "Purchase Order Created for LKR 20000",
        createdBy: "Thisaru Kalpana",
        date: DateTime(2025, 6, 1),
      ),
      PrLogModel(
        title: "Recieve po001 created",
        createdBy: "Thisaru Kalpana",
        date: DateTime(2025, 6, 1),
      ),
    ];
  }
}
