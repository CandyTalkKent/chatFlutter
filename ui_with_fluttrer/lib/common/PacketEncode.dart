import 'dart:convert';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

class PacketEncode {


  static void _sendMessage(WebSocketChannel channel,Object msg, int requestType , int algotithm) {
      var messagePacket = new MessagePacket(command: "1", message: _controller.text);
      var packet = messagePacket.toJson();
      String res = json.encode(packet);

      List<int> byteslist = new List<int>();
      List<int> packetbytes = utf8.encode(res);

      // request Type
      byteslist.add(2);

      //serialize algorithm
      byteslist.add(1);

      byteslist.addAll(packetbytes);

      var uint8list = Uint8List.fromList(byteslist);

//      widget.channel.sink.add(res);
      channel.sink.add(uint8list);
  }
}