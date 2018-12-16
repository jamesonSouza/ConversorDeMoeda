import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=7b9afe60";
//https://api.hgbrasil.com/finance?key=7b9afe60
void main() async {
  runApp(MaterialApp(
    title: "Conversor de moeda",
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realCrtl = TextEditingController();
  final dolalCrtl = TextEditingController();
  final euroCrtl = TextEditingController();
  final bitcoinCrtl = TextEditingController();


  double dolar;
  double euro;
  double bitcoin;


  void _realChanged(String text){


      double real = double.parse(text);
      dolalCrtl.text = (real/dolar).toStringAsFixed(2);
      euroCrtl.text = (real/euro).toStringAsFixed(2);
     bitcoinCrtl.text = (real/bitcoin).toStringAsFixed(6);

  }
  void _dolaChanged(String text){
    double dolar = double.parse(text);
    realCrtl.text= (dolar * this.dolar).toStringAsFixed(2);
    euroCrtl.text = (dolar * this.dolar /euro).toStringAsFixed(2);
    bitcoinCrtl.text = (dolar * this.dolar / bitcoin).toStringAsFixed(6);

  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    realCrtl.text= (euro * this.euro).toStringAsFixed(2);
    dolalCrtl.text = (euro * this.euro /dolar).toStringAsFixed(2);
    bitcoinCrtl.text = (euro * this.euro / bitcoin).toStringAsFixed(6);
  }

  void _bitcoinChanged(String text){
    double bitcoin = double.parse(text);
    if(bitcoinCrtl.text==null || bitcoinCrtl.text=="0" ||  bitcoinCrtl.text=="0."){
      euroCrtl.text ="0.00";
    }else {
      realCrtl.text = (bitcoin * this.bitcoin).toStringAsFixed(2);
      dolalCrtl.text = (bitcoin * this.bitcoin / dolar).toStringAsFixed(2);
      euroCrtl.text =
          (bitcoin * this.bitcoin / euro / bitcoin).toStringAsFixed(2);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        title: Text(
          "\$ Conversor de moedas",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados...",
                    style:TextStyle(color:Colors.amber,) ,
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "Erro ao carregar dados...",
                      style:TextStyle(color:Colors.amber,
                      fontSize: 25.0) ,
                      textAlign: TextAlign.center,
                    ),
                  );
                }else{
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  bitcoin = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,

                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150, color: Colors.amber,),
                        Divider(),
                        buildTextField("Reais", "R\$ " , realCrtl, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$ ", dolalCrtl, _dolaChanged),
                        Divider(),
                        buildTextField("Euros", "€ ", euroCrtl, _euroChanged),
                        Divider(),
                        buildTextField("Bitcoin", "₿ ",bitcoinCrtl , _bitcoinChanged)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
//"€"
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

Widget buildTextField(String _label, String _prefix, TextEditingController c, Function f){

  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: _label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: _prefix ,
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
