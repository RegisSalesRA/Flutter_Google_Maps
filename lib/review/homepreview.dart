import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera =
      CameraPosition(target: LatLng(-4.831256, -40.321122), zoom: 16);

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

  // ignore: unused_element
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

    // ignore: unused_element
    _recuperarLocalizacaoAtual() async {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("Localização atual é: " + position.toString());

      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 16);
        _movimentarCamera();
      });
    }

    marcadoresLocal.add(marcadorShopping);
    setState(() {
      _marcadores = marcadoresLocal;
    });
  }

  // ignore: unused_element
  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 16);
        _movimentarCamera();
      });
    });
  }

  // ignore: unused_element
  _recuperarLocalParaEndereco() async {
    List<Placemark> listaEnderecos =
        await Geolocator().placemarkFromAddress("");

    print("total: " + listaEnderecos.length.toString());
    if (listaEnderecos != null && listaEnderecos.length > 0) {
      Placemark endereco = listaEnderecos[0];
      String resultado;
      resultado = "\n administrativeArea" + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea" + endereco.subAdministrativeArea;
      resultado += "\n locality" + endereco.locality;
      resultado += "\n subLocality" + endereco.subLocality;
      resultado += "\n subThoroughfare" + endereco.subThoroughfare;
      resultado += "\n postalCode" + endereco.postalCode;
      resultado += "\n country" + endereco.country;
      resultado += "\n isoCountryCode" + endereco.isoCountryCode;
      resultado += "\n endereco.position" + endereco.position.toString();

      print("resultado: " + resultado);
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
//    _carregarMarcadores();
//  _adicionarListenerLocalizacao();
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
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: _marcadores,
        ),
      ),
    );
  }
}
