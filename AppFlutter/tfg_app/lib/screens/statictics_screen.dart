import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg_app/delegates/search_match_delegate.dart';
import 'package:tfg_app/delegates/search_date_delegate.dart';

import 'package:tfg_app/services/match_service.dart';
import 'package:tfg_app/widgets/widgets.dart';



class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final matchService = Provider.of<MatchService>(context);
    final equipos = matchService.calcularPorcentajesAcierto();
    final equiposLocal = matchService.calcularPorcentajesAciertoLocal();
    final equiposVisitante = matchService.calcularPorcentajesAciertoVisitante();


    return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    leading: IconButton(
    icon: const Icon(
      Icons.arrow_back,
      color: Colors.black,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: Row(
      children: const [
        Text(
          'Estadísticas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        SizedBox(width: 8),
        Icon(
          Icons.analytics_outlined,
          color: Colors.black,
          size: 30,
        ),
      ],
    ),
  ),
  body:
  Container(
  margin: EdgeInsets.all(10.0),
  color: Colors.white,
  child: Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 2), // Ajusta los valores X e Y según sea necesario para la sombra
      ),
    ],
  ),
    child: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // ignore: prefer_const_constructors
      Text(
        'Equipos con mayores porcentajes de acierto',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16.0),
      DataTable(
        columns: [
          DataColumn(label: Text('Posición', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Equipo', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Predicción', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
        ],
        rows: List<DataRow>.generate(
          equipos.length > 5 ? 5 : equipos.length,
          (index) => DataRow(cells: [
            DataCell(Text((index + 1).toString(), style: TextStyle(fontSize: 17), )),
            DataCell(Text(equipos.keys.toList()[index],  style: TextStyle(fontSize: 17), )),
            DataCell(Text(equipos.values.toList()[index].toString() + '%', style: TextStyle(fontSize: 17))),
          ]),
        ),
      ),
      const SizedBox(height: 15.0),
      const Divider(
                    thickness: 4,
                    height: 50,
                    color: Colors.black,
                  ),
      const SizedBox(height: 15.0),
      const Text(
        'Equipos con menores porcentajes de acierto',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16.0),
      DataTable(
        columns: const [
          DataColumn(label: Text('Posición', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Equipo', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Predicción', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
        ],
        rows: List<DataRow>.generate(
        equipos.length > 5 ? 5 : equipos.length,
        (index) {
          final reversedIndex = equipos.length - 1 - index;
          return DataRow(cells: [
            DataCell(Text((reversedIndex + 1).toString(), style: TextStyle(fontSize: 17))),
            DataCell(Text(equipos.keys.toList()[reversedIndex], style: TextStyle(fontSize: 17))),
            DataCell(Text(equipos.values.toList()[reversedIndex].toString() + '%', style: TextStyle(fontSize: 17))),
            ]
          );
        },
      ),
      ),
      const SizedBox(height: 15.0),
      const Divider(
                    thickness: 4,
                    height: 50,
                    color: Colors.black,
                  ),
      const SizedBox(height: 15.0),
      const Text(
        'Equipos con mayores porcentajes de acierto como LOCAL',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16.0),
      DataTable(
        columns: const [
          DataColumn(label: Text('Posición', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Equipo', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Predicción', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
        ],
        rows: List<DataRow>.generate(
        equiposLocal.length > 5 ? 5 : equiposLocal.length,
        (index) {
          
          return DataRow(cells: [
            DataCell(Text((index + 1).toString(), style: TextStyle(fontSize: 17))),
            DataCell(Text(equiposLocal.keys.toList()[index], style: TextStyle(fontSize: 17))),
            DataCell(Text(equiposLocal.values.toList()[index].toString() + '%', style: TextStyle(fontSize: 17))),
            ]
          );
        },
      ),
      ),
      const SizedBox(height: 15.0),
      const Divider(
                    thickness: 4,
                    height: 50,
                    color: Colors.black,
                  ),
      const SizedBox(height: 15.0),
      const Text(
        'Equipos con mayores porcentajes de acierto como VISITANTE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 16.0),
      DataTable(
        columns: const [
          DataColumn(label: Text('Posición', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Equipo', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
          DataColumn(label: Text('Predicción', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,)),
        ],
        rows: List<DataRow>.generate(
        equiposVisitante.length > 5 ? 5 : equiposVisitante.length,
        (index) {
          
          return DataRow(cells: [
            DataCell(Text((index + 1).toString(), style: TextStyle(fontSize: 17))),
            DataCell(Text(equiposVisitante.keys.toList()[index], style: const TextStyle(fontSize: 17))),
            DataCell(Text(equiposVisitante.values.toList()[index].toString() + '%', style: const TextStyle(fontSize: 17))),
            ]
          );
        },
      ),
      ),
    ],
  ),
))));
}
}


  
