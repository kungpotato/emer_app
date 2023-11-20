import 'dart:async';

import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  Completer<GoogleMapController>? controller = Completer();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final base64 = await getBase64Image(context.authStore.profile!.img!);
      final List<LocationItem> markerList = [
        LocationItem(
            longitude:
                context.authStore.profile?.address?.location?.latitude ?? 0,
            latitude:
                context.authStore.profile?.address?.location?.longitude ?? 0,
            imgBase64: base64)
      ];

      _createCustomImageMarker(markerList);
      _goToMarker(markerList);
    });
  }

  void _goToMarker(List<LocationItem> markerList) {
    if (markerList.isNotEmpty) {
      controller?.future.then((con) {
        con.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(markerList.first.latitude, markerList.first.longitude),
          ),
        );
      });
    }
  }

  Future<void> _createCustomImageMarker(List<LocationItem> list) async {
    final newList = <Marker>[];
    for (var i = 0; i < list.length; i++) {
      Uint8List? markerIcon;
      if (list[i].imgBase64?.isNotEmpty ?? false) {
        markerIcon = await getNetworkImageMarker(
          base64Image: list[i].imgBase64,
        );
      }
      final marker = Marker(
        markerId: MarkerId(i.toString()),
        position: LatLng(list[i].latitude, list[i].longitude),
        // New York City coordinates
        icon: markerIcon != null
            ? BitmapDescriptor.fromBytes(markerIcon)
            : BitmapDescriptor.defaultMarker,
        onTap: () {
          //
        },
      );
      newList.add(marker);
    }

    if (mounted) {
      setState(() {
        _markers.addAll(newList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(13.8225814763742, 100.559033556751),
        zoom: 17,
      ),
      zoomControlsEnabled: false,
      markers: _markers,
      onMapCreated: (control) {
        controller?.complete(control);
      },
    );
  }
}

class LocationItem {
  LocationItem({
    required this.latitude,
    required this.longitude,
    this.text,
    this.imgBase64,
  });

  final double latitude;
  final double longitude;
  final String? text;
  final String? imgBase64;
}
