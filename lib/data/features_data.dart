import 'package:wareflow/models/feature_model.dart';
import 'package:wareflow/pages/home/home_menu/dispatch.dart';
import 'package:wareflow/pages/home/home_menu/dummy.dart';
import 'package:wareflow/pages/home/home_menu/grn.dart';
import 'package:wareflow/pages/home/home_menu/items.dart';
import 'package:wareflow/pages/home/home_menu/package.dart';
import 'package:wareflow/pages/home/home_menu/purchase_order.dart';
import 'package:wareflow/pages/home/home_menu/quality_check.dart';
import 'package:wareflow/pages/home/home_menu/return.dart';
import 'package:wareflow/pages/home/home_menu/sales_order.dart';

class FeaturesData {
  final List<FeatureModel> allFeatures = [
    FeatureModel(
      img: 'images/add-product.png',
      title: 'Purchase Order',
      subtitle: 'subtitle',
      route: PurchaseOrder(),
      permissionKey: "manage_po",
    ),
    FeatureModel(
      img: 'images/delete-product.png',
      title: 'Sales Order',
      subtitle: 'subtitle',
      route: SalesOrder(),
      permissionKey: 'manage_so',
    ),
    FeatureModel(
      img: 'images/grn.ico',
      title: 'GRN',
      subtitle: 'subtitle',
      route: Grn(),
      permissionKey: 'manage_po',
    ),
    FeatureModel(
      img: 'images/quality.ico',
      title: 'Quality Check',
      subtitle: 'subtitle',
      route: QualityCheck(),
      permissionKey: 'manage_po',
    ),
    FeatureModel(
      img: 'images/package.ico',
      title: 'Package',
      subtitle: 'subtitle',
      route: Package(),
      permissionKey: 'manage_po',
    ),
    FeatureModel(
      img: 'images/dispatch.ico',
      title: 'Dispatch',
      subtitle: 'subtitle',
      route: Dispatch(),
      permissionKey: 'manage_po',
    ),
    FeatureModel(
      img: 'images/return.ico',
      title: 'Return',
      subtitle: 'subtitle',
      route: Return(),
      permissionKey: 'manage_po',
    ),

    FeatureModel(
      img: 'images/report.png',
      title: 'Report',
      subtitle: 'subtitle',
      route: Dummy(),
      permissionKey: 'view_reports',
    ),
    FeatureModel(
      img: 'images/report.png',
      title: 'Test',
      subtitle: 'subtitle',
      route: ItemsAdd(),
      permissionKey: 'view_reports',
    ),
  ];
}
