import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wareflow/models/user_model.dart';
import 'package:wareflow/pages/authentication/auth_wrapper.dart';
import 'package:wareflow/pages/authentication/invitation_signup_view.dart';
import 'package:wareflow/pages/home/approval.dart';
// import 'package:wareflow/pages/authentication/signin_view.dart';
// import 'package:wareflow/pages/authentication/signup_view.dart';
import 'package:wareflow/pages/home/base.dart';
import 'package:wareflow/pages/home/create_user_role.dart';
import 'package:wareflow/pages/home/customer.dart';
import 'package:wareflow/pages/home/home_menu/analytics.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_dispatch.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_package.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_purchase_return.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_qc.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_sales_return.dart';
import 'package:wareflow/pages/home/home_menu/dispatch.dart';
import 'package:wareflow/pages/home/home_menu/grn.dart';
import 'package:wareflow/pages/home/home_menu/items.dart';
import 'package:wareflow/pages/home/home_menu/package.dart';
import 'package:wareflow/pages/home/home_menu/purchase_order.dart';
import 'package:wareflow/pages/home/home_menu/purchase_order_pages/create_po.dart';
import 'package:wareflow/pages/home/home_menu/create_pages/create_grn.dart';
import 'package:wareflow/pages/home/home_menu/quality_check.dart';
import 'package:wareflow/pages/home/home_menu/return.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/grn_selection.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/package_item_selection.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/package_selection.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/returnable_grn_selection.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/returnable_item_selection.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/so_selection.dart';
import 'package:wareflow/pages/home/invite_users.dart';
import 'package:wareflow/pages/home/manage_category.dart';
import 'package:wareflow/pages/home/po_items.dart';
import 'package:wareflow/pages/home/home_menu/purchase_order_pages/po_order.dart';
import 'package:wareflow/pages/home/home_menu/sales_order.dart';
import 'package:wareflow/pages/home/home_menu/sales_order_pages/so_items.dart';
import 'package:wareflow/pages/home/home_menu/stockin_pages/customer_view.dart';
import 'package:wareflow/pages/home/inventory_pages/category_view.dart';
import 'package:wareflow/pages/home/home_menu/stock_out.dart';
import 'package:wareflow/pages/home/home_menu/stockin_pages/items_view.dart';
import 'package:wareflow/pages/home/home_menu/stockin_pages/notes_view.dart';
import 'package:wareflow/pages/home/home_menu/stockin_pages/supplier_view.dart';
import 'package:wareflow/pages/home/home_menu/stockin_pages/warehouse_view.dart';
import 'package:wareflow/pages/home/home_view.dart';
import 'package:wareflow/pages/home/inventory_pages/register_item_view.dart';
import 'package:wareflow/pages/home/inventory_view.dart';
import 'package:wareflow/pages/home/home_menu/sales_order_pages/create_so.dart';
import 'package:wareflow/pages/home/home_menu/stockout_pages/inventory_items.dart';
import 'package:wareflow/pages/home/home_menu/sales_order_pages/so_order.dart';
import 'package:wareflow/pages/home/home_menu/selection_pages/po_selection.dart';
import 'package:wareflow/pages/home/supplier.dart';
import 'package:wareflow/pages/home/transactions_view.dart';
import 'package:wareflow/pages/home/more_view.dart';
import 'package:wareflow/pages/home/warehouse.dart';
import 'package:wareflow/pages/welcome_view.dart';
// import 'package:wareflow/pages/splashscreen.dart';
// import 'package:wareflow/pages/welcome_view.dart';
import 'package:wareflow/pages/wrapper.dart';
import 'package:wareflow/providers/category_provider.dart';
import 'package:wareflow/providers/customer_provider.dart';
import 'package:wareflow/providers/dispatch_provider.dart';
import 'package:wareflow/providers/item_provider.dart';
import 'package:wareflow/providers/qc_provider.dart';
import 'package:wareflow/providers/log_provider.dart';
import 'package:wareflow/providers/package_provider.dart';
import 'package:wareflow/providers/permission_provider.dart';
import 'package:wareflow/providers/po_item_provider.dart';
import 'package:wareflow/providers/purchase_order_provider.dart';
import 'package:wareflow/providers/grn_provider.dart';
import 'package:wareflow/providers/return_provider.dart';
import 'package:wareflow/providers/returnable_item_provider.dart';
import 'package:wareflow/providers/sales_order_provider.dart';
import 'package:wareflow/providers/so_item_provider.dart';
import 'package:wareflow/providers/stock_in_item_provider.dart';
import 'package:wareflow/providers/supplier_provider.dart';
import 'package:wareflow/providers/warehouse_provider.dart';
// import 'package:wareflow/providers/app_state.dart';
import 'package:wareflow/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            StreamProvider<UserModel?>.value(
              initialData: UserModel(uid: ""),
              value: AuthService().user,
            ),
            ChangeNotifierProvider(create: (_) => PermissionProvider()),
            ChangeNotifierProvider(create: (_) => StockInItemProvider()),
            ChangeNotifierProvider(create: (_) => SupplierProvider()),
            ChangeNotifierProvider(create: (_) => WarehouseProvider()),
            ChangeNotifierProvider(create: (_) => PurchaseOrderProvider()),
            ChangeNotifierProvider(create: (_) => PoItemProvider()),
            ChangeNotifierProvider(create: (_) => GrnProvider()),
            ChangeNotifierProvider(create: (_) => LogProvider()),
            ChangeNotifierProvider(create: (_) => QcProvider()),
            ChangeNotifierProvider(create: (_) => SalesOrderProvider()),
            ChangeNotifierProvider(create: (_) => CustomerProvider()),
            ChangeNotifierProvider(create: (_) => SoItemProvider()),
            ChangeNotifierProvider(create: (_) => PackageProvider()),
            ChangeNotifierProvider(create: (_) => ReturnableItemProvider()),
            ChangeNotifierProvider(create: (_) => ReturnProvider()),
            ChangeNotifierProvider(create: (_) => DispatchProvider()),
            ChangeNotifierProvider(create: (_) => ItemProvider()),
            ChangeNotifierProvider(create: (_) => CategoryProvider()),
          ],

          //Material app
          child: MaterialApp(
            title: 'WareFlow',
            debugShowCheckedModeBanner: false,

            //Routes
            initialRoute: '/welcome',
            routes: {
              '/welcome': (context) => WelcomeView(),
              '/wrapper': (context) => Wrapper(),
              '/auth_wrapper': (context) => AuthWrapper(),
              '/invitation_signup': (context) => InvitationSignupView(),
              '/base': (context) => Base(),
              '/home': (context) => HomeView(),
              '/inventory': (context) => InventoryView(),
              '/logspage': (context) => LogsPage(),
              '/morepage': (context) => MorePage(),
              '/stockout': (context) => StockOut(),
              '/items': (context) => ItemsAdd(),
              '/purchaseorder': (context) => PurchaseOrder(),
              '/salesorder': (context) => SalesOrder(),
              '/grn': (context) => Grn(),
              '/item': (context) => ItemView(),
              '/supplierSelection': (context) => SupplierView(),
              '/warehouseSelection': (context) => WarehouseView(),
              '/notes': (context) => NotesView(),
              '/category': (context) => CategoryView(),
              '/register': (context) => RegisterItemView(),
              '/createpo': (context) => CreatePo(),
              '/podetails': (context) => PoOrder(),
              '/so': (context) => SoOrder(),
              '/creategrn': (context) => CreateGrn(),
              '/poitems': (context) => PoItems(),
              '/createso': (context) => CreateSo(),
              '/inventoryitems': (context) => InventoryItems(),
              '/customerSelection': (context) => CustomerView(),
              '/soitems': (context) => SoItems(),
              '/analytics': (context) => Analytics(),
              '/poselection': (context) => PoSelection(),
              '/qualitycheck': (context) => QualityCheck(),
              '/createqc': (context) => CreateQc(),
              '/grnselection': (context) => GrnSelection(),
              '/package': (context) => Package(),
              '/createpackage': (context) => CreatePackage(),
              '/soselection': (context) => SoSelection(),
              '/return': (context) => Return(),
              '/createpurchasereturn': (context) => CreatePurchaseReturn(),
              '/createsalesreturn': (context) => CreateSalesReturn(),
              '/returnablegrnselection': (context) => ReturnableGrnSelection(),
              '/returnableitemselection':
                  (context) => ReturnableItemSelection(),
              '/dispatch': (context) => Dispatch(),
              '/createdispatch': (context) => CreateDispatch(),
              '/packageselection': (context) => PackageSelection(),
              '/packageitemselection': (context) => PackageItemSelection(),
              '/itemsview': (context) => ItemView(),
              '/approval': (context) => ApprovalPage(),
              '/managecategory': (context) => ManageCategoryPage(),
              '/inviteusers': (context) => InviteUsers(),
              '/rolepermission': (context) => CreateUserRolePage(),
              '/warehouse': (context) => WarehousePage(),
              '/supplier': (context) => SupplierManagementPage(),
              '/customer': (context) => CustomerManagementPage(),
            },
          ),
        );
      },
    );
  }
}
