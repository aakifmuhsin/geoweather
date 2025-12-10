import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'presentation/bindings/home_binding.dart';
import 'presentation/views/home_page.dart';
import 'presentation/controllers/location_controller.dart';
import 'services/notification_service.dart';
import 'services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await NotificationService().init();
  await PermissionService().ensurePermissionsOrExit();
  FlutterForegroundTask.initCommunicationPort();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GeoWeather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialBinding: HomeBinding(),
      home: const PermissionCheckWrapper(),
    );
  }
}

/// Wrapper to perform initial location fetch after permissions are granted
class PermissionCheckWrapper extends StatefulWidget {
  const PermissionCheckWrapper({super.key});

  @override
  State<PermissionCheckWrapper> createState() => _PermissionCheckWrapperState();
}

class _PermissionCheckWrapperState extends State<PermissionCheckWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Get initial location and weather
      final locationController = Get.find<LocationController>();
      await locationController.getCurrentLocation();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error during initialization: $e');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing GeoWeather...'),
            ],
          ),
        ),
      );
    }

    return const HomePage();
  }
}
