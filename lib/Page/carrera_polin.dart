import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatefulWidget {
  LocationPage({Key key, @required this.toPoint, this.fromPoint})
      : super(key: key);

  final LatLng toPoint;
  final LatLng fromPoint;

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  GoogleMapController _mapController;

  @override
  void initState() {
    _centerView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.fromPoint,
              zoom: 10.0,
            ),
            zoomControlsEnabled: false,
            markers: _createMarkers(),
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 50.0,
            right: 12,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.gps_fixed,
                color: Colors.black,
                size: 28,
              ),
              onPressed: _centerView,
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.31,
              minChildSize: 0.31,
              maxChildSize: 0.97,
              builder: (context, controler) {
                return Container(
                  color: Colors.white,
                  child: ListView(
                    controller: controler,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 12.5),
                        child: Center(
                          child: Text(
                            "Tarifas un poco elevadas por el aumento de demanda",
                            style: TextStyle(fontSize: 13.5),
                          ),
                        ),
                      ),
                      Container(
                          color: Colors.grey[200],
                          child: ViajeListTile(
                              "UberX", "assets/1.png", '\$2.37', () {})),
                      ViajeListTile("Flash", "assets/2.png", '\$2.05', () {}),
                      ViajeListTile("Comfort", "assets/3.png", '\$2.30', () {}),
                    ],
                  ),
                );
              }),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              color: Colors.white,
              child: RaisedButton(
                onPressed: () {},
                color: Colors.black,
                child: Text(
                  "Confirmar",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(Marker(
        markerId: MarkerId("fromPoint"),
        position: widget.fromPoint,
        infoWindow: InfoWindow(title: "Origen")));

    tmp.add(Marker(
        markerId: MarkerId("toPoint"),
        position: widget.toPoint,
        //  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: "Destino")));

    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _centerView();
  }

  _centerView() async {
    await _mapController.getVisibleRegion();

    var left = min(widget.fromPoint.latitude, widget.toPoint.latitude);
    var right = max(widget.fromPoint.latitude, widget.toPoint.latitude);
    var top = max(widget.fromPoint.longitude, widget.toPoint.longitude);
    var botton = min(widget.fromPoint.longitude, widget.toPoint.longitude);

    var bounds = LatLngBounds(
      southwest: LatLng(left - 0.01, botton),
      northeast: LatLng(right, top),
    );
    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
    _mapController.animateCamera(cameraUpdate);
  }
}

class ViajeListTile extends StatelessWidget {
  final String text;
  final String precio;
  final String name;
  final Function ontap;

  ViajeListTile(this.text, this.name, this.precio, this.ontap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(11.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset(
                    name,
                    width: 65,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20), // separacion entre icono y letras
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(text,
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w500)),
                        Text(
                          "15:45",
                          style: TextStyle(fontSize: 13.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                precio,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        onTap: ontap);
  }
}
