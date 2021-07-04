import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();

  // ignore: unused_field
  GoogleMapController _googleMapController;
  Set<Marker> _marcadores = {};
  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(-4.831256, -40.321122),
          zoom: 16,
          //Angulação   45 graus = tilt: 45
          tilt: 45,
          // Bearing é a rotação
          bearing: 270),
    ));
  }

  _carregarMarcadores() {
    Set<Marker> marcadoresLocal = {};
    Marker marcadorShopping = Marker(
        markerId: MarkerId("tamboril-casa"),
        position: LatLng(-4.831256, -40.321122),
        infoWindow: InfoWindow(title: "Casa do lunard"),
        // Icone padrao BitmapDescriptor.defaultMarker ( Icone vermelho marcando o ponto no mapa)
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        //rotation: 45
        onTap: () {
          print("Clicou casa do lunard");
        });

    marcadoresLocal.add(marcadorShopping);
    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _carregarMarcadores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _movimentarCamera,
      ),
      body: Container(
        //Criaçao do mapa parte desse widget
        child: GoogleMap(
          mapType:
              //mapType: MapType.hybrid,
              //mapType: MapType.none,
              //mapType: MapType.satellite,
              //mapType: MapType.terrain,
              MapType.normal,

          //Posição inicial da Camera
          initialCameraPosition:
              CameraPosition(target: LatLng(-4.831256, -40.321122), zoom: 16),
          onMapCreated: _onMapCreated,
          markers: _marcadores,
        ),
      ),
    );
  }
}
