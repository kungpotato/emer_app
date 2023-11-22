import 'dart:async';

import 'package:emer_app/data/profile_data.dart';
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
            imgBase64: base64),
      ];

      if (context.authStore.profile?.members != null) {
        var memberMarkers =
            await Future.wait(context.authStore.profile!.members.map((e) async {
          final b64 = await getBase64Image(e.imgUrl);
          return LocationItem(
              longitude: e.location.longitude ?? 0,
              latitude: e.location.latitude ?? 0,
              imgBase64: b64);
        }));

        markerList.addAll(memberMarkers);
      }

      await _createCustomImageMarker(markerList);
      _fitBounds();
      // _goToMarker(markerList);
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
    return Column(
      children: [
        Flexible(
          flex: 7,
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
            flex: 4,
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
                      if (context.authStore.profile != null)
                        _cardItem(context.authStore.profile!),
                      if (context.authStore.profile != null)
                        ...context.authStore.profile!.members
                            .map((e) => _cardMemberItem(e))
                            .toList()
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget _cardItem(ProfileData data) {
    return Card(
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
                      backgroundImage: NetworkImage(data.img!),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: context.theme.textTheme.titleLarge?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _cardMemberItem(MemberData data) {
    return Card(
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
                      backgroundImage: NetworkImage(data.imgUrl),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: context.theme.textTheme.titleLarge?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
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
