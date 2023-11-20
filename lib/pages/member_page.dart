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
    return Column(
      children: [
        Flexible(
          flex: 6,
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
        Flexible(
            flex: 3,
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.background,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Member',
                        style: context.theme.textTheme.titleLarge
                            ?.copyWith(color: context.theme.primaryColor),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: context.theme.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            context.authStore.profile!.img!),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.authStore.profile!.name,
                                          style: context
                                              .theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            ClipOval(
                                                child: Container(
                                              color: Colors.green,
                                              width: 8,
                                              height: 8,
                                            )),
                                            SizedBox(width: 4),
                                            Text('Online')
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: context.theme.primaryColor,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
      ],
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
