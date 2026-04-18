import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/api/prefs_helper.dart';
import 'core/firebase/fcm.dart';
import 'core/resources/auto_route.dart';
import 'core/resources/hive_helper.dart';
import 'core/resources/internet_checker.dart';
import 'di.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/analytics/domain/entity/analysis_adapter.dart';
import 'features/home/data/model/order_page_adapter.dart';
import 'features/order_details/data/models/order_adapters.dart';
import 'features/product/data/model/product_adabtor.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(

  );



  await dotenv.load(fileName: ".env.example"); //
  await Hive.initFlutter();
  _registerProductsAdapters();
  _registerOrdersAdapters();
  _registerAnalysisAdapters();



  await configureDependencies();


  getIt<InternetConnectivity>().initialize();


  try {
    if (!Hive.isBoxOpen(HiveCacheHelper.productsBoxName)) {
      await Hive.openBox(HiveCacheHelper.productsBoxName);
    }
    if (!Hive.isBoxOpen(HiveCacheHelper.ordersBoxName)) {
      await Hive.openBox(HiveCacheHelper.ordersBoxName);
    }
  } catch (e) {
    debugPrint('Hive Error: $e');
  }


  final notificationService = NotificationService();
  await notificationService.initNotification();

  runApp(const MyApp());
}
void _registerProductsAdapters() {
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProductResponseAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ResultsAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(CategoriesAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ImagesAdapter());
  if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(ImageDataAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(WeightAdapter());
  if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(RatingAdapter());
  if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(StocksAdapter());
}

void _registerOrdersAdapters() {
  if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(OrderModeldAdapter());
  if (!Hive.isAdapterRegistered(11)) Hive.registerAdapter(CustomerModelAdapter());
  if (!Hive.isAdapterRegistered(12)) Hive.registerAdapter(OrderItemModelAdapter());
  if (!Hive.isAdapterRegistered(13)) Hive.registerAdapter(ShippingAddressModelAdapter());

  if (!Hive.isAdapterRegistered(50)) Hive.registerAdapter(ZidOrdersResponseAdapter());
  if (!Hive.isAdapterRegistered(51)) Hive.registerAdapter(OrderModelAdapter());
  if (!Hive.isAdapterRegistered(52)) Hive.registerAdapter(OrderStatusAdapter());
  if (!Hive.isAdapterRegistered(53)) Hive.registerAdapter(CustomerAdapter());
  if (!Hive.isAdapterRegistered(54)) Hive.registerAdapter(AddressAdapter());
}

void _registerAnalysisAdapters() {
  if (!Hive.isAdapterRegistered(100)) Hive.registerAdapter(AnalysisEntityAdapter());
  if (!Hive.isAdapterRegistered(101)) Hive.registerAdapter(StockLevelItemAdapter());
  if (!Hive.isAdapterRegistered(103)) Hive.registerAdapter(StockDistributionAdapter());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter.config(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
