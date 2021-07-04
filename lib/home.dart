import 'package:flutter/material.dart';

import 'mapa.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listaviagens = [
    ' lugar 1',
    'lugar 2',
    'lugar 3',
  ];

  void _abrirMapa() {}
  void _excluirViagen() {}
  void _adcionarLocal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Mapa()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas viagens"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xff0066cc),
        onPressed: () {
          _adcionarLocal();
        },
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _listaviagens.length,
                itemBuilder: (context, index) {
                  String titulo = _listaviagens[index];
                  return GestureDetector(
                    onTap: () {
                      _abrirMapa();
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(titulo),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _excluirViagen();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
