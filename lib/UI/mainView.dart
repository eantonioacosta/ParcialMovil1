import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mis_calificaciones/UI/cortesView.dart';
import 'package:mis_calificaciones/UI/materiasView.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final materias = GetStorage("materias");
  bool exist = false;

  TextEditingController _nuevaMateria = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1)).whenComplete((){
      valideData().then((value) {
        if(!value){
          setState(() {
            
          });
        }
      });
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () => addMat(),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.library_add)),
          )
        ],
        centerTitle: true,
        title: Text('Mis materias'),
      ),
      body: Container(
          child: !materias.getKeys().isEmpty
              ? ListView.builder(
                  itemCount: int.parse(materias.getKeys().last),
                  itemBuilder: (_, counter) => Container(
                    decoration: BoxDecoration(
                            color: Colors.blueAccent.withAlpha(40),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                          Center(
                            child: Text(materias.read((counter + 1).toString()).toString().toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,)),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Colors.blue.withAlpha(100),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Text('Corte 1'),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Materias(materias.read((counter + 1).toString()),1, counter+1)));
                                }
                              ),
                              SizedBox(width: 10,),
                              RaisedButton(
                                color: Colors.blue.withAlpha(100),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Text('Corte 2'),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Materias(materias.read((counter + 1).toString()),2, counter+1)));
                                }
                              ),
                              SizedBox(width: 10,),
                              RaisedButton(
                                color: Colors.blue.withAlpha(100),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Text('Corte 3'),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Materias(materias.read((counter + 1).toString()),3, counter+1)));
                                }
                              ),
                              SizedBox(width: 10,),
                            ],
                          )
                      ],
                    ),
                  ),
                  )
              : Center(
                  child: Text('A;ada Materias'),
                )),
    );
  }

  Future<bool> valideData() async{
    return await materias.getKeys().isEmpty;
  }
  String calculateKey() {
    return materias.getKeys().isEmpty == true
        ? '1'
        : (int.parse(materias.getKeys().last) + 1).toString();
  }

  addMat() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("A;adir materia"),
            content: Container(
              height: MediaQuery.of(context).size.height*0.2,
              child: Column(
                children: [
                  Card(
                    child: TextField(
                      controller: _nuevaMateria,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text('A;adir', style: TextStyle(color: Colors.white),),
                    color: Colors.blue,
                    onPressed: () {
                    materias.write(calculateKey(), _nuevaMateria.text);
                    _nuevaMateria.clear();
                    //print(materias.getValues());
                    setState(() {});
                  }),
                ],
              ),
            ),
          );
        });
  }
}
