import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ui_uber/State/state.dart';

import 'carrera_polin.dart';

class DireccionAuto extends StatefulWidget {
  const DireccionAuto(
      {Key key, @required this.locationController, this.currentLocation})
      : super(key: key);
  final LatLng currentLocation;
  final TextEditingController locationController;

  @override
  _DireccionAutoState createState() => _DireccionAutoState();
}

class _DireccionAutoState extends State<DireccionAuto> {
  TextEditingController locationController = TextEditingController();
  LatLng toPoint;
  LatLng fromPoint = LatLng(-2.189083, -79.883490);
  GoogleMapController _mapController;

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(toPoint.latitude, toPoint.longitude);
    locationController.text = placemark[0].name;
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onCameraMove(CameraPosition position) async {
    toPoint = position.target;
  }

  void getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    toPoint = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    _mapController.animateCamera(CameraUpdate.newLatLng(toPoint));
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Searching>(context);
    return Consumer<Searching>(
      builder: (_, snapshot, __) => Scaffold(
          appBar: _appBar(context),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: widget.currentLocation, zoom: 15.0),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onCameraMove: onCameraMove,
                  onMapCreated: onCreated,
                  onCameraIdle: () async {
                    setState(() {});
                    getMoveCamera();
                  },
                ),
                Align(
                    alignment: Alignment.center,
                    //  Un Column para subir el Icon xD,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, size: 38),
                        SizedBox(
                          height: 26,
                        )
                      ],
                    )),
                Positioned(
                  bottom: 21,
                  right: 25,
                  left: 25,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LocationPage(
                            fromPoint: widget.currentLocation,
                            toPoint: toPoint,
                          ),
                        ),
                      );
                    },
                    color: Colors.black,
                    child: Text(
                      "LISTO",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  right: 12,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: getUserLocation,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.gps_fixed, color: Colors.black),
                  ),
                ),
                snapshot.buscando ? Container() : _draggableScrollableSheet(),
              ],
            ),
          )),
    );
  }

  Widget _draggableScrollableSheet() {
    double minimo = 0.17;
    return Consumer<Searching>(
      builder: (_, snapshot, __) => DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: minimo,
          builder: (context, controler) {
            return Container(
              color: Colors.grey[200],
              child: ListView(
                controller: controler,
                children: [
                  ListTitle(
                    "Fijar la ubicación en el mapa",
                    (Icons.location_on),
                    snapshot.buscar,
                  ),
                  ListTitle(
                    "Ubicaciones guardadas",
                    (Icons.star),
                    () {},
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _appBar(context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 150),
          child: Container(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.person, size: 20, color: Colors.black54),
                Text(
                  "Para mí",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 16,
                ),
              ],
            ),
          ),
        )
      ],
      bottom: PreferredSize(
          child: Consumer<Searching>(
            builder: (_, snapshott, __) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 6.5),
              child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        size: 12,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 33,
                          width: MediaQuery.of(context).size.width / 1.4,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(color: Colors.grey[50]),
                          child: TextField(
                            enabled: false,
                            onTap: snapshott.buscar,
                            controller: widget.locationController,
                            decoration: InputDecoration.collapsed(
                                hintText: "punto de partida"),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    children: [
                      Icon(Icons.stop, size: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: EdgeInsets.only(left: 9),
                          height: 31,
                          width: MediaQuery.of(context).size.width / 1.4,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: snapshott.text
                              ? TextField(
                                  onTap: snapshott.nobuscar,
                                  controller: locationController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: " ¿A dónde vas?"),
                                )
                              : TextField(
                                  //  onTap: snapshott.buscar,
                                  //  controller: locationController,
                                  decoration: InputDecoration.collapsed(
                                      hintText: " ¿A dónde vas?"),
                                ),
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 28,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(64)),
    );
  }
}

class ListTitle extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function ontap;

  ListTitle(this.text, this.icon, this.ontap);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(2.0),
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    child: Icon(
                      icon,
                      size: 17,
                      color: Colors.white,
                    ),
                    radius: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      text,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              //  Icon(Icons.keyboard_arrow_right, color: Colors.black)
            ],
          ),
        ),
        onTap: ontap,
      ),
    );
  }
}
