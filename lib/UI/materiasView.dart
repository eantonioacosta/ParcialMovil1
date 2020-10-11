import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class Materias extends StatefulWidget {
  final String tittle;
  final int corte, materia;
  Materias(this.tittle, this.corte, this.materia, {Key key}) : super(key: key);

  @override
  _MateriasState createState() => _MateriasState();
}

class _MateriasState extends State<Materias> {
  double def = 0;
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
    if (notas.read(materias.read(widget.materia.toString())) != null) {
      for (var element
          in notas.read(materias.read(widget.materia.toString()))) {
            if(element["corte"]==widget.corte.toString()){
              calificaciones.add(element);
              def += calculateTotal(element["nota"], element["porcent"]);
            }
      }
    }
    Future.delayed(Duration(seconds: 2)).whenComplete(() {
      setState(() {
        print('update');
      });
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
            onTap: () {
              actualizar();
              Future.delayed(Duration(seconds: 1)).whenComplete(() => Navigator.pop(context));

              setState(() {});
            },
            child: Icon(
              Icons.update,
              color: Colors.green[400],
            ),
          ),
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
        title: Text(widget.tittle+ "  definitiva: "+def.toString()),
        centerTitle: true,
      ),
      body: Container(
        child: calificaciones.length > 0
            ? ListView.builder(
                itemCount: calificaciones.length,
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
                            child: Text(calificaciones[counter]["activity"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(calculateTotal(calificaciones[counter]["nota"],
                                  calificaciones[counter]["porcent"])
                              .toString()),
                          Expanded(
                            child: SizedBox(
                              height: 10,
                            ),
                          ),
                          Text(calificaciones[counter]["nota"]),
                          SizedBox(
                            width: 10,
                          ),
                          Text(calificaciones[counter]["porcent"] + "%"),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Text('Añada notas'),
              ),
      ),
    );
  }

  double calculateTotal(String value, String porcent) {
    return double.parse(value) * (double.parse(porcent) / 100);
  }

  deleteAll() {
    notas.erase();
    Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
      setState(() {});
      Navigator.pop(context);
    });
  }

  actualizar() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                height: 500,
                width: 500,
                child: Center(child: CircularProgressIndicator())),
          );
        });
  }

  dialogError() async {
    setState(() {
      notas.read('IA');
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Error en los datos de entrada, verifique'),
          );
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
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(hintText: "Nota"),
                            controller: _value,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
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
                        'Add',
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
                        try {
                          double.tryParse(_notas["porcent"]);
                          double.tryParse(_notas["nota"]);
                          notas.write(
                              materias.read((widget.materia).toString()),
                              calificaciones);
                        } catch (e) {
                          dialogError();
                        }

                        // _name.clear();
                        setState(() {
                          print('updatenote');
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }
}
