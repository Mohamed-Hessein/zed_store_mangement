import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_ic_images.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/di.dart';
import 'package:zed_store_mangent/features/auth/login/presentation/cubit/login_cunit.dart';
import 'package:zed_store_mangent/features/auth/login/presentation/cubit/login_state.dart';
import 'package:zed_store_mangent/features/auth/login/presentation/widgets/custom_btn.dart';
import '../../../../../core/firebase/fcm.dart';
import '../../../../../core/resources/auto_route.gr.dart';

@RoutePage()@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final _appLinks = AppLinks();
  late final LoginCubit _loginCubit;


  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loginCubit = getIt<LoginCubit>();
    _initDeepLinks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed && !_isProcessing) {
      print("📱 App Resumed - Checking for links...");
      _checkInitialLink();
    }
  }

  void _initDeepLinks() {
    _appLinks.uriLinkStream.listen((uri) {
      print("🔥 Stream Caught URI: $uri");
      _handleIncomingLink(uri);
    });

    _checkInitialLink();
  }

  Future<void> _checkInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        print("🚀 Found Link: $initialUri");
        _handleIncomingLink(initialUri);
      }
    } catch (e) {
      print("❌ Failed to get initial link: $e");
    }
  }

  void _handleIncomingLink(Uri uri) {

    if (_isProcessing) {
      print("⏳ Already processing a link, ignoring this one.");
      return;
    }

    String? code = uri.queryParameters['code'];

    if (code == null && uri.hasFragment) {
      final fragmentUri = Uri.parse('?${uri.fragment}');
      code = fragmentUri.queryParameters['code'];
    }

    if (code != null && code.isNotEmpty) {
      print('✅ Success! Code found, starting login...');


      setState(() {
        _isProcessing = true;
      });

      _loginCubit.login(code: code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _loginCubit,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSucess) {
            print("🎯 Success State! Navigating to Token Screen...");

            getIt<NotificationService>().initNotification();
            setState(() {
              _isProcessing = false;
            });

            AutoRouter.of(context).replace( HomeBottomNavRoute());
          }
          if (state is LoginError) {
            print('❌ Login Error: ${state.errorMassge}');

            setState(() {
              _isProcessing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('التطبيق مثبت بالفعل على متجرك. إذا قمت بحذفه مؤخراً، يرجى تسجيل الدخول أو المحاولة بعد دقائق.')),
            );
          }
        },
        builder: (context, state) {

          if (state is LoginLoading || _isProcessing) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.purple),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImageApp.zedImage, width: 120.w),
                    SizedBox(height: 40.h),
                    Text(
                      "مرحباً بك في لوحة تحكم متجرك",
                      textAlign: TextAlign.center,
                      style: AppStyles.text32purple,
                    ),
                    SizedBox(height: 50.h),
                    CutstomBtn(
                      text: "ربط المتجر بـ زد",
                      onPressed: () {
                        print("🌐 Opening Zid Auth URL...");
                        _loginCubit.startZidAuth();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
