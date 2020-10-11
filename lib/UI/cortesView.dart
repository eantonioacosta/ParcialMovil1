import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Cortes extends StatefulWidget {
  final String tittle;
  Cortes(this.tittle,{Key key}) : super(key: key);

  @override
  _CortesState createState() => _CortesState();
}

class _CortesState extends State<Cortes> {
  final box = GetStorage("materias");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         centerTitle: true,
         title: Text(widget.tittle),
       ),
       body: Center(child: 
       Text("")),
    );
  }
}