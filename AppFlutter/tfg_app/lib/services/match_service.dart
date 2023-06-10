import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MatchService extends ChangeNotifier {
  
  // PONER LA IP DE LA MÁQUINA PARA QUE FUNCIONE CORRECTAMENTE EN EL EMULADOR  172.20.10.2
  final String _baseUrl = '192.168.1.128:3000'; 
 
 
  List<Match> _matches = [];

  bool sorted = true;

  List<Match> get matches => _matches;
  set matches(List<Match> val) {
    _matches = val;
    notifyListeners();
  }

  void sort() {
    _matches.sort((a, b) {
      final splitDateA = a.fecha.split('-');
      final dateAstr = splitDateA[0] + splitDateA[1] + splitDateA[2];
      final splitDateB = b.fecha.split('-');
      final dateBstr = splitDateB[0] + splitDateB[1] + splitDateB[2];
      final dateA = DateTime.parse(dateAstr);
      final dateB = DateTime.parse(dateBstr);
      return sorted ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    sorted = !sorted;
    notifyListeners();
    print(calcularPorcentajesAcierto());

    
  }

  Future<bool> getItems() async {
    if (matches.isNotEmpty) return true;
    final url = Uri.http(_baseUrl, '/partidos');
    
    try {
      final resp = await http.get(url);
      
      List<dynamic> rawdata = jsonDecode(resp.body);

      List<Match> aux = [];

      rawdata.forEach((element) {
        final matchResult = Match.fromJson(element);
        aux.add(matchResult);
      });

      matches = aux;
      
      return true;
    } catch (e) {
      print('Error al obtener los datos: $e');
      return false;
    }
  }


  List<Match> findByName(String name) {
    return matches
        .where((element) =>
            element.equipoLocal
                .trim()
                .toLowerCase()
                .contains(name.trim().toLowerCase()) ||
            element.equipoVisitante
                .trim()
                .toLowerCase()
                .contains(name.trim().toLowerCase()))
        .toList();
  }


  List<Match> findByDate(String date) {
    return matches
    .where((match) => match.fecha.contains(date)).toList();
  }


List<Map<String, dynamic>> obtenerRegistros(List<Match> matches) {
  List<Map<String, dynamic>> registros = [];

  for (var match in matches) {
    Map<String, dynamic> registro = {
      'equipo_local': match.equipoLocal,
      'equipo_visitante': match.equipoVisitante,
      'porcentaje_victoria_local': match.porcentajeVictoriaLocal,
      'porcentaje_victoria_visitante': match.porcentajeVictoriaVisitante,
      'porcentaje_empate': match.porcentajeEmpate,
      'ganador': match.ganador
    };
    registros.add(registro);
  }
  return registros;
}

Map<String, int> calcularPorcentajesAcierto(){
  List<Map<String, dynamic>> registros = obtenerRegistros(matches);
  Map<String, int> numeroAciertos = {};
  for (Map<String,dynamic> registro in registros){
    String equipoLocal = registro['equipo_local'];
    String equipoVisitante = registro['equipo_visitante'];
    int porcentajeVictoriaLocal = registro['porcentaje_victoria_local'];
    int porcentajeVictoriaVisitante = registro['porcentaje_victoria_visitante'];
    int porcentajeEmpate = registro['porcentaje_empate'];
    String ganador = registro['ganador'];

    String ganadorPredicho;
    if((porcentajeVictoriaLocal>=porcentajeEmpate) & (porcentajeVictoriaLocal>=porcentajeVictoriaVisitante)){
      ganadorPredicho = 'H';
    }else if((porcentajeVictoriaVisitante>=porcentajeEmpate) & (porcentajeVictoriaLocal<=porcentajeVictoriaVisitante)){
      ganadorPredicho = 'A';
    }else{
      ganadorPredicho = 'ANY';
    }
    if (ganadorPredicho == ganador) {
        // El algoritmo predijo correctamente
        numeroAciertos[equipoLocal] = (numeroAciertos[equipoLocal] ?? 0) + 1;
        numeroAciertos[equipoVisitante] = (numeroAciertos[equipoVisitante] ?? 0) + 1;
      }
    }
    for (String key in  numeroAciertos.keys){
      int? valor = numeroAciertos[key];
      int aux = ((valor!/38)*100.0).round();
      numeroAciertos[key] = aux;
    }
  List<MapEntry<String, int>> listaOrdenada = numeroAciertos.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));

  numeroAciertos = Map.fromEntries(listaOrdenada);
  return numeroAciertos;
}

Map<String, int> calcularPorcentajesAciertoLocal(){
  List<Map<String, dynamic>> registros = obtenerRegistros(matches);
  Map<String, int> numeroAciertos = {};
  for (Map<String,dynamic> registro in registros){
    String equipoLocal = registro['equipo_local'];
    int porcentajeVictoriaLocal = registro['porcentaje_victoria_local'];
    int porcentajeVictoriaVisitante = registro['porcentaje_victoria_visitante'];
    int porcentajeEmpate = registro['porcentaje_empate'];
    String ganador = registro['ganador'];

    String ganadorPredicho;
    if((porcentajeVictoriaLocal>=porcentajeEmpate) & (porcentajeVictoriaLocal>=porcentajeVictoriaVisitante)){
      ganadorPredicho = 'H';
    }else if((porcentajeVictoriaLocal<=porcentajeEmpate) & (porcentajeVictoriaLocal<=porcentajeVictoriaVisitante)){
      ganadorPredicho = 'A';
    }else{
      ganadorPredicho = 'ANY';
    }

    if (ganadorPredicho == ganador) {
        
      numeroAciertos[equipoLocal] = (numeroAciertos[equipoLocal] ?? 0) + 1;
        
    }
  }
    
    for (String key in  numeroAciertos.keys){
      int? valor = numeroAciertos[key];
      int aux = ((valor!/19)*100.0).round();
      numeroAciertos[key] = aux;
    }

  List<MapEntry<String, int>> listaOrdenada = numeroAciertos.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));

  numeroAciertos = Map.fromEntries(listaOrdenada);
  return numeroAciertos;

}

Map<String, int> calcularPorcentajesAciertoVisitante(){
  List<Map<String, dynamic>> registros = obtenerRegistros(matches);
  Map<String, int> numeroAciertos = {};
  for (Map<String,dynamic> registro in registros){
    String equipoVisitante = registro['equipo_visitante'];
    int porcentajeVictoriaLocal = registro['porcentaje_victoria_local'];
    int porcentajeVictoriaVisitante = registro['porcentaje_victoria_visitante'];
    int porcentajeEmpate = registro['porcentaje_empate'];
    String ganador = registro['ganador'];

    String ganadorPredicho;
    if((porcentajeVictoriaVisitante>=porcentajeEmpate) & (porcentajeVictoriaLocal<=porcentajeVictoriaVisitante)){
      ganadorPredicho = 'A';
    }else if((porcentajeVictoriaVisitante<=porcentajeEmpate) & (porcentajeVictoriaLocal>=porcentajeVictoriaVisitante)){
      ganadorPredicho = 'H';
    }else{
      ganadorPredicho = 'ANY';
    }

    if (ganadorPredicho == ganador) {
        
        numeroAciertos[equipoVisitante] = (numeroAciertos[equipoVisitante] ?? 0) + 1;
        
    }
  }
    
  for (String key in  numeroAciertos.keys){
    int? valor = numeroAciertos[key];
    int aux = ((valor!/19)*100.0).round();
    numeroAciertos[key] = aux;
  }

  List<MapEntry<String, int>> listaOrdenada = numeroAciertos.entries.toList()
  ..sort((a, b) => b.value.compareTo(a.value));

  numeroAciertos = Map.fromEntries(listaOrdenada);
  return numeroAciertos;

  }

  
}