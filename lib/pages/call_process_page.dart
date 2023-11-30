import 'dart:async';
import 'dart:convert';

import 'package:emer_app/app/app_home.dart';
import 'package:emer_app/app/services/firestore_ref.dart';
import 'package:emer_app/pages/member_page.dart';
import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:emer_app/shared/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:slide_to_act/slide_to_act.dart';

class CallProcessPage extends StatefulWidget {
  const CallProcessPage(
      {super.key, required this.data, required this.pallPerson});

  final Map<String, dynamic> data;
  final String pallPerson;

  @override
  State<CallProcessPage> createState() => _CallProcessPageState();
}

class _CallProcessPageState extends State<CallProcessPage> {
  Completer<GoogleMapController>? controller = Completer();
  final Set<Marker> _markers = {};
  String? callId;

  Future<void> makeCall(
      {required String toNumber,
      required String fromNumber,
      required String mp3Url}) async {
    try {
      var url = Uri.parse(
          'https://us-central1-emerapp-59c53.cloudfunctions.net/makeCall');
      var response = await http.post(url,
          body: {'to': toNumber, 'from': fromNumber, 'mp3Url': mp3Url});
      if (response.statusCode == 200) {
        print('Call initiated: ${response.body}');
        setState(() {
          callId = jsonDecode(response.body) as String;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error making call: $e');
    }
  }

  Future<void> cancelCall(String callSid) async {
    try {
      var url = Uri.parse('https://your-firebase-function-url/cancelCall');
      var response = await http.post(url, body: {'callSid': callSid});
      if (response.statusCode == 200) {
        print('Call cancelled: ${response.body}');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error cancelling call: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.data['status'] != 'start') {
        final ref = FsRef.profileRef
            .doc(widget.pallPerson)
            .collection('falling')
            .doc('1234');
        await ref.update({'status': 'end'});
        makeCall(
            toNumber: '+66974259796',
            fromNumber: '+12107626092',
            mp3Url:
                'https://potato1234.000webhostapp.com/wp-content/uploads/detect%20name.mp3');
      }
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
            title: Text('PHONE CALL PROCESS'),
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
                                      icon: Icon(
                                        Icons.phone,
                                        color: Colors.black87,
                                      ),
                                      label: Text(
                                        widget.data['status'] != 'end'
                                            ? 'CALLING....'
                                            : 'CALLED',
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
                            reversed: false,
                            onSubmit: () async {
                              final ref = FsRef.profileRef
                                  .doc(widget.pallPerson)
                                  .collection('falling')
                                  .doc('1234');
                              await ref.update({'status': 'cancel'});
                              if (callId != null) {
                                await cancelCall(callId!);
                              }
                              Navigator.pop(context);
                            },
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
