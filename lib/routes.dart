import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:my_capital/bindings/add_container_binding.dart';
import 'package:my_capital/bindings/add_shipment_binding.dart';
import 'package:my_capital/bindings/all_shipments_binding.dart';
import 'package:my_capital/bindings/invoice_binding.dart';
import 'package:my_capital/bindings/purchase_demand_binding.dart';
import 'package:my_capital/bindings/supplier_binding.dart';
import 'package:my_capital/controllers/add_container_controller.dart';
import 'package:my_capital/controllers/create_demand_draft_controller.dart';
import 'package:my_capital/controllers/invoice_controller.dart';
import 'package:my_capital/screens/inventory/AddInventoryScreen.dart';
import 'package:my_capital/screens/inventory/SelectInventoryScreen.dart';
import 'package:my_capital/screens/inventory/inventory_main_screen.dart';
import 'package:my_capital/screens/menu_screen.dart';
import 'package:my_capital/screens/purchase_demand/create_invoice_screen.dart';
import 'package:my_capital/screens/purchase_demand/create_purchase_demand.dart';
import 'package:my_capital/screens/purchase_demand/purchase_demand_detail_screen.dart';
import 'package:my_capital/screens/purchase_demand/purchase_demand_screen.dart';
import 'package:my_capital/screens/shipments/add_container_screen.dart';
import 'package:my_capital/screens/shipments/add_shipment_screen.dart';
import 'package:my_capital/screens/shipments/main_shipments_screen.dart';
import 'package:my_capital/screens/supplier/AddSupplier.dart';
import 'package:my_capital/screens/supplier/all_supplier_screen.dart';

import 'bindings/create_demand_draft_binding.dart';
import 'bindings/demand_draft_detail_binding.dart';

final routes = [
  GetPage(name: '/purchase_demand', page: () => const PurchaseDemandScreen(), binding: PurchaseDemandBinding()),
  GetPage(name: '/create_purchase_demand', page: () =>  CreatePurchaseDemand(), binding: CreatePurchaseDemandBinding()),
  GetPage(name: '/purchase_demand_detail', page: () =>  PurchaseDemandDetailScreen(), binding: DemandDraftDetailBinding()),
  GetPage(name: '/create_invoice', page: () =>  CreateInvoiceScreen(), binding: InvoiceBinding()),


  GetPage(name: '/add_supplier', page: () =>  AddSupplierScreen(), binding: SupplierBinding()),
  GetPage(name: '/all_suppliers', page: () =>  AllSuppliersScreen(), binding: SupplierBinding()),

  GetPage(name: '/all_shipments', page: () =>  MainShipmentScreen(), binding: AllShipmentsBinding()),
  GetPage(name: '/add_shipment', page: () =>  AddShipmentScreen(), binding: AddShipmentBinding()),
  GetPage(name: '/add_container', page: () =>  AddContainerScreen(), binding: AddContainerBinding()),

  GetPage(name: '/inventory_main', page: () => InventoryMainScreen()),
  GetPage(name: '/add_inventory', page: () => AddInventoryScreen()),
  GetPage(name: '/select_inventory', page: () => SelectInventoryScreen()),
  //FOR TESTING
  // GetPage(name: '/', page: () =>  CreateInvoiceScreen(), binding: InvoiceBinding()),
  // GetPage(name: '/', page: () => const PurchaseDemandScreen(), binding: PurchaseDemandBinding()),
  GetPage(name: '/', page: () =>  MenuScreen()),
  // GetPage(name: '/', page: () =>  AddShipmentScreen(), binding: AddShipmentBinding()),
];