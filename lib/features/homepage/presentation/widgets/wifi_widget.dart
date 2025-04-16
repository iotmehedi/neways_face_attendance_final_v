// import 'dart:async';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:wifi_scan/wifi_scan.dart';
//
// class AccessPointTile extends StatefulWidget {
//   final WiFiAccessPoint accessPoint;
//
//   const AccessPointTile({Key? key, required this.accessPoint})
//       : super(key: key);
//
//   @override
//   State<AccessPointTile> createState() => _AccessPointTileState();
// }
//
// class _AccessPointTileState extends State<AccessPointTile> {
//   List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
//   StreamSubscription<List<WiFiAccessPoint>>? subscription;
//   bool shouldCheckCan = true;
//
//   bool get isStreaming => subscription != null;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//
//   // build row that can display info, based on label: value pair.
//   Widget _buildInfo(String label, dynamic value) => Container(
//     decoration: const BoxDecoration(
//       border: Border(bottom: BorderSide(color: Colors.grey)),
//     ),
//     child: Row(
//       children: [
//         Text(
//           "$label: ",
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         Expanded(child: Text(value.toString()))
//       ],
//     ),
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final title = widget.accessPoint.ssid.isNotEmpty ? widget.accessPoint.ssid : "**EMPTY**";
//     final signalIcon = widget.accessPoint.level >= -80
//         ? Icons.signal_wifi_4_bar
//         : Icons.signal_wifi_0_bar;
//     return ListTile(
//       visualDensity: VisualDensity.compact,
//       leading: Icon(signalIcon),
//       title: Text(title),
//       subtitle: Text(widget.accessPoint.capabilities),
//       onTap: () => showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildInfo("BSSDI", widget.accessPoint.bssid),
//               // _buildInfo("Capability", widget.accessPoint.capabilities),
//               _buildInfo("frequency", "${widget.accessPoint.frequency}MHz"),
//               // _buildInfo("level", widget.accessPoint.level),
//               // _buildInfo("standard", widget.accessPoint.standard),
//               // _buildInfo(
//               //     "centerFrequency0", "${widget.accessPoint.centerFrequency0}MHz"),
//               // _buildInfo(
//               //     "centerFrequency1", "${widget.accessPoint.centerFrequency1}MHz"),
//               // _buildInfo("channelWidth", widget.accessPoint.channelWidth),
//               // _buildInfo("isPasspoint", widget.accessPoint.isPasspoint),
//               // _buildInfo(
//               //     "operatorFriendlyName", widget.accessPoint.operatorFriendlyName),
//               // _buildInfo("venueName", widget.accessPoint.venueName),
//               // _buildInfo("is80211mcResponder", widget.accessPoint.is80211mcResponder),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Show snackbar.
// void kShowSnackBar(BuildContext context, String message) {
//   if (kDebugMode) print(message);
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(SnackBar(content: Text(message)));
// }