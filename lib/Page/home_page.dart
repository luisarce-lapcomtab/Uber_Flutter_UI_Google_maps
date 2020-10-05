import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'direccion_auto_page.dart';
import 'travel_time_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController locationController = TextEditingController();
  LatLng currentLocation = LatLng(-2.142869, -79.923845);
  GoogleMapController _mapController;

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  void getMoveCamera() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    locationController.text = placemark[0].name;
  }

  void onCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onCameraMove(CameraPosition position) async {
    currentLocation = position.target;
  }

  void getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    currentLocation = LatLng(position.latitude, position.longitude);
    locationController.text = placemark[0].name;
    _mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: currentLocation, zoom: 15.0),
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
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4.5,
            right: 12,
            child: FloatingActionButton(
              mini: true,
              onPressed: getUserLocation,
              backgroundColor: Colors.white,
              child: Icon(Icons.gps_fixed, color: Colors.black),
            ),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.22,
              maxChildSize: 0.22,
              minChildSize: 0.22,
              builder: (context, controler) {
                return Container(
                  color: Colors.grey[100],
                  child: ListView(
                    controller: controler,
                    children: [
                      _bottomdireccion(),
                      _addressList(),
                    ],
                  ),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          selectedIconTheme: IconThemeData(color: Colors.black, size: 21),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.drive_eta),
                title: Text(
                  "Viajar",
                  style: TextStyle(fontSize: 12),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant), title: Text("Pedir comida"))
          ]),
    );
  }

  Widget _bottomdireccion() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DireccionAuto(
                      locationController: locationController,
                      currentLocation: currentLocation),
                ),
              );
            },
            highlightElevation: 0,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 13, bottom: 13, right: 40),
              child: Text(
                "¿A dónde vas?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(33.0),
              ),
              child: OutlineButton.icon(
                onPressed: () {
                  _showModalBottomSheet(context);
                },
                icon: Icon(Icons.access_time),
                label: Text("Ahora "),
                shape: StadiumBorder(),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addressList() {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.black,
                  ),
                  radius: 17,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Text(
                    "Elegir ubicación guardada",
                    style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Icon(Icons.keyboard_arrow_right, color: Colors.grey)
          ],
        ),
      ),
      onTap: () {},
    );
  }

  _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return TravelTime();
        });
  }
}
