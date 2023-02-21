import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//para manejar los stados del service
enum ServerStatus { Online, Offline, Connecting }

//ayuda a provider a decirle cuando debe refrescar
class SocketService with ChangeNotifier {
  ServerStatus _serverStatus =
      ServerStatus.Connecting; //siempre voy a estar conectandome

  late IO.Socket _socket; //yo le agregue ese late
  Function get emit => this._socket.emit;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    //constructor
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://192.168.0.106:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    ///para escuchar eventos personalizados
    /* socket.on('nuevo-mensaje', (payload) {
      print('nuevo_mensaje : ');
      print('nombre: ' + payload['nombre']);
      print('mensaje: ' + payload['mensaje']);
      //para cuando viene una variable que no siempre se manda
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'nohay');
    });*/

    /* socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));*/
  }
}
