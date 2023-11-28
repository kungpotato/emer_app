import 'dart:async';

import 'package:emer_app/app/app_home.dart';
import 'package:emer_app/pages/member_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CallProcessPage extends StatefulWidget {
  const CallProcessPage({super.key});

  @override
  State<CallProcessPage> createState() => _CallProcessPageState();
}

class _CallProcessPageState extends State<CallProcessPage> {
  Completer<GoogleMapController>? controller = Completer();
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!mounted) {
        return;
      }
      final base64 = await getBase64Image(context.authStore.profile!.img!);
      final List<LocationItem> markerList = [
        LocationItem(
            longitude:
                context.authStore.profile?.address?.location?.latitude ?? 0,
            latitude:
                context.authStore.profile?.address?.location?.longitude ?? 0,
            imgBase64: base64),
      ];

      if (context.authStore.profile?.members != null) {
        var memberMarkers =
            await Future.wait(context.authStore.profile!.members.map((e) async {
          final b64 = await getBase64Image(e.imgUrl);
          return LocationItem(
              longitude: e.location.longitude,
              latitude: e.location.latitude,
              imgBase64: b64);
        }));

        markerList.addAll(memberMarkers);
      }

      await _createCustomImageMarker(markerList);
      _fitBounds();
      // _goToMarker(markerList);
    });
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

  void _fitBounds() {
    if (_markers.isNotEmpty && controller != null) {
      var bounds = _calculateBounds(_markers);
      var cameraUpdate =
          CameraUpdate.newLatLngBounds(bounds, 50); // 50 is padding
      controller?.future.then((value) {
        value.animateCamera(cameraUpdate);
      });
    }
  }

  LatLngBounds _calculateBounds(Set<Marker> markers) {
    double? southwestLat, southwestLng, northeastLat, northeastLng;

    for (var marker in markers) {
      if (southwestLat == null || marker.position.latitude < southwestLat) {
        southwestLat = marker.position.latitude;
      }
      if (southwestLng == null || marker.position.longitude < southwestLng) {
        southwestLng = marker.position.longitude;
      }
      if (northeastLat == null || marker.position.latitude > northeastLat) {
        northeastLat = marker.position.latitude;
      }
      if (northeastLng == null || marker.position.longitude > northeastLng) {
        northeastLng = marker.position.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(southwestLat!, southwestLng!),
      northeast: LatLng(northeastLat!, northeastLng!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (context) => AppHome(isNoMsg: true),
          ),
          (route) => false,
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => AppHome(isNoMsg: true),
                  ),
                  (route) => false,
                );
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Stack(children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: size.height * 0.65,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(13.8225814763742, 100.559033556751),
                    zoom: 17,
                  ),
                  zoomControlsEnabled: false,
                  markers: _markers,
                  onMapCreated: (control) {
                    controller?.complete(control);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade800,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: size.height * 0.35,
                  child: Container(
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Image.asset(
                                        'assets/images/Ellipse 19.png')),
                                Column(
                                  children: [
                                    SizedBox(height: 80),
                                    ElevatedButton.icon(
                                      style: context
                                          .theme.elevatedButtonTheme.style
                                          ?.copyWith(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.white)),
                                      onPressed: null,
                                      icon: Image.asset(
                                          'assets/images/uis_hospital.png'),
                                      label: Text(
                                        'BANGKOK HOSPITAL',
                                        style: context
                                            .theme.textTheme.labelMedium
                                            ?.copyWith(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      style: context
                                          .theme.elevatedButtonTheme.style
                                          ?.copyWith(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.white)),
                                      onPressed: null,
                                      icon: Image.asset(
                                          'assets/images/mdi_car-emergency.png'),
                                      label: Text(
                                        'ARRIVE IN 10 MINUTES',
                                        style: context
                                            .theme.textTheme.labelMedium
                                            ?.copyWith(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SlideAction(
                            height: 60,
                            outerColor: Colors.white,
                            child: Text('SLIDE TO CANCEL'),
                            onSubmit: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
