import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Materias extends StatefulWidget {
  final String tittle;
  final int corte, materia;
  Materias(this.tittle, this.corte, this.materia, {Key key}) : super(key: key);

  @override
  _MateriasState createState() => _MateriasState();
}

class _MateriasState extends State<Materias> {
  List<Map> calificaciones;
  final materias = GetStorage("materias");
  final notas = GetStorage("notas");
  List<Map> actividades;
  TextEditingController _name = new TextEditingController();
  TextEditingController _value = new TextEditingController();
  TextEditingController _porcent = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calificaciones = new List<Map>();
    actividades = new List<Map>();
    if (notas != null) {
      for (var element in notas.getValues().toList()) {
        for (var item in element) {
          calificaciones.add(item);
        }
      }
    }
    for (var activity in calificaciones) {
      if (activity["corte"] == widget.corte.toString()) {
        actividades.add(activity);
      }
    }
    Future.delayed(Duration(seconds: 2)).whenComplete(() {
      setState(() {});
    });

    //calificaciones.addAll(notas.getValues());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => deleteAll(),
            child: Icon(
              Icons.delete_forever,
              color: Colors.red[400],
            ),
          ),
          GestureDetector(
            onTap: () => addNota(),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.note_add)),
          )
        ],
        title: Text(widget.tittle),
        centerTitle: true,
      ),
      body: Container(
        child: actividades != null
            ? ListView.builder(
                itemCount: actividades.length,
                itemBuilder: (_, counter) => Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent.withAlpha(40),
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Center(
                            child: Text(actividades[counter]["activity"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Nota'),
                          Expanded(
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                          Text(actividades[counter]["nota"]),
                          SizedBox(
                            width: 10,
                          ),
                          Text(actividades[counter]["porcent"] + "%"),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Text('A;ada notas'),
              ),
      ),
    );
  }

  deleteAll() {
    notas.erase();
    Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
      setState(() {});
    });
  }

  addNota() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("A;adir nota"),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  Card(
                    child: TextField(
                      decoration:
                          InputDecoration(hintText: "Nombre de la actividad"),
                      controller: _name,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Card(
                          child: TextField(
                            maxLength: 1,
                            decoration: InputDecoration(hintText: "Nota"),
                            controller: _value,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: TextField(
                            maxLength: 3,
                            decoration: InputDecoration(hintText: "%"),
                            controller: _porcent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                      child: Text(
                        'A;adir',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        calificaciones = new List<Map>();
                        actividades = new List<Map>();
                        for (var element in notas.getValues().toList()) {
                          for (var item in element) {
                            calificaciones.add(item);
                          }
                        }
                        for (var activity in calificaciones) {
                          if (activity["corte"] == widget.corte.toString()) {
                            actividades.add(activity);
                          }
                        }
                        print(widget.corte);
                        Map<String, String> _notas = {
                          "activity": "",
                          "nota": "",
                          "porcent": "",
                          "corte": ""
                        };
                        _notas["activity"] = _name.text;
                        _notas["nota"] = _value.text;
                        _notas["porcent"] = _porcent.text;
                        _notas["corte"] = widget.corte.toString();
                        calificaciones.add(_notas);
                        //notas.write(materias.read((widget.materia).toString()), calificaciones);
                        // _name.clear();
                        setState(() {});
                      }),
                ],
              ),
            ),
          );
        });
  }
}
