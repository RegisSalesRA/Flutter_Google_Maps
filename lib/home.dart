import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'mapa.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore _db = Firestore.instance;
  void _abrirMapa(String idViagem) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => Mapa(idViagem: idViagem)));
  }

  void _excluirViagen(String idViagem) {
    _db.collection("viagens").document(idViagem).delete();
  }

  void _adcionarLocal() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Mapa()));
  }

  _adicionarListenerViagens() {
    final stream = _db.collection("viagens").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerViagens();
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
          child: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data;
              List<DocumentSnapshot> viagens = querySnapshot.documents.toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: viagens.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot item = viagens[index];
                        String titulo = item["titulo"];
                        String idViagem = item.documentID;
                        return GestureDetector(
                          onTap: () {
                            _abrirMapa(idViagem);
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(titulo),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _excluirViagen(idViagem);
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
              );
              break;
          }
        },
      )),
    );
  }
}
