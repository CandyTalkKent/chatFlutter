import 'dart:convert';
import 'dart:typed_data';

import 'package:ui_with_fluttrer/models/Serializable.dart';

class PacketEncode {

  /**
   * requestType 1: login 2: message
   * algorithm 1: json
   */
  static Uint8List encode(Serializable msg, int requestType, int algorithm) {
    var jsonMap = msg.toJson();
    String res = json.encode(jsonMap);

    List<int> byteslist = new List<int>();
    List<int> packetbytes = utf8.encode(res);

    // request Type
    byteslist.add(requestType);

    //serialize algorithm
    byteslist.add(algorithm);

    byteslist.addAll(packetbytes);

    var uint8list = Uint8List.fromList(byteslist);

    return uint8list;
  }
}
