import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController _ctrl;

  /// This gives you bounds that cover all markers
  LatLngBounds boundsFromMarkers(Set<Marker> markers) {
    Iterable<double> lats = markers.map((e) => e.position.latitude);
    Iterable<double> lngs = markers.map((e) => e.position.longitude);
    return LatLngBounds(
      southwest: LatLng(lats.reduce(min), lngs.reduce(min)),
      northeast: LatLng(lats.reduce(max), lngs.reduce(max)),
    );
  }

  final Set<Marker> markers = {
    Marker(markerId: MarkerId('1'), position: LatLng(52.22979, 21.00466)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.22980, 21.00904)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.23223, 21.00943)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.23327, 21.00716)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.23357, 21.00461)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.23228, 21.00501)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.23166, 21.00616)),
    Marker(markerId: MarkerId('1'), position: LatLng(52.23007, 21.00744)),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Maps example")),
      body: Container(
        height: 500,
        color: Colors.grey,
        child: Stack(
          children: [
            Container(
              height: 400,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(52.2317, 21.0061),
                  zoom: 16,
                ),
                padding: EdgeInsets.only(bottom: 140),
                markers: markers,
                onMapCreated: (ctrl) {
                  _ctrl = ctrl;
                  setCamera() =>
                      _ctrl.animateCamera(CameraUpdate.newLatLngBounds(
                          boundsFromMarkers(markers), 12));

                  // Doesn't care about padding
                  setCamera();

                  // // This doesn't fix anything :/
                  // setState(() {});
                  //
                  // // Nor this
                  // Future.microtask(() {
                  //   setCamera();
                  //   setState(() {});
                  // });
                  //
                  // // THIS FINALLY FIXES STUFF
                  // // You can set the duration to one seconds to see result,
                  // // But it also works with ~1ms
                  // // UPDATE: I tried on emulator, and because it's slow, values
                  // // <1000ms didn't work :c  - so that's not a good solution
                  // Future.delayed(Duration(milliseconds: 1), () {
                  //   setCamera();
                  //   setState(() {});
                  // });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(36),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [BoxShadow(blurRadius: 6)],
                ),
              ),
            ),
          ],
        ),
      ),
      // I added this FAB to test if it works when I press it after the fact
      // IT DOES! But why? Why does it work correctly few seconds after?
      // (I added Future.delayed after I discovered that)
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_on_outlined),
        onPressed: () => _ctrl?.animateCamera(
          CameraUpdate.newLatLngBounds(boundsFromMarkers(markers), 12),
        ),
      ),
    );
  }
}
