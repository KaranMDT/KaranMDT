import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/Provider/cart.dart';
import 'package:shop_app/Provider/orders.dart';
import 'package:shop_app/Provider/products.dart';
import 'package:shop_app/Screens/auth_screen.dart';
import 'package:shop_app/Screens/product_overview_screen.dart';
import 'package:shop_app/Screens/splash_screen.dart';
import 'package:shop_app/helpers/custome_route.dart';

import 'Provider/auth.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products('', '', []),
          update: (context, auth, prevProducts) => Products(
            auth.token.toString(),
            auth.userid,
            prevProducts == null ? [] : prevProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: ((context) => Order("", '', [])),
          update: (context, auth, prevorders) => Order(
            auth.token.toString(),
            auth.userid,
            prevorders == null ? [] : prevorders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
                TargetPlatform.android: CustomPageTransitionBuilder(),
              })),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(context),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
        ),
      ),
    ),
  );
}
