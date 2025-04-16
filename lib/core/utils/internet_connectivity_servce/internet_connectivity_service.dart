import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../main.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final ValueNotifier<bool> isConnected = ValueNotifier(false);

  ConnectivityService() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      return;
    }

    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    // bool isConnected = _connectionStatus != ConnectivityResult.none;
    // ignore: avoid_print
    bool hasInternet = false;
// bool connectionStatus = false;
//      connectionStatus = result.first != ConnectivityResult.none;
//

    if (result.first != ConnectivityResult.none) {
      // Check if the network has internet access
      hasInternet = await InternetConnection().hasInternetAccess;
    }
    isConnected.value = hasInternet;
    box.write("internet", hasInternet);
    print('Connectivity changed: ${result.first}');
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}

