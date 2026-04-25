import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart';

import '../../app_export.dart';

class SocketService extends GetxService {
  final AuthenticationController authService = Get.find();
  String socketURL = 'https://nh422t96-5001.inc1.devtunnels.ms';
  late Socket socket;
  Map<String, dynamic> profileData = {};
  AudioPlayer player = AudioPlayer();
  final _messageStream = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onNewMessage => _messageStream.stream;

  Future<void> _whistle(String sound) async {
    await player.setSource(AssetSource(sound)).then((value) {
      player.play(AssetSource(sound));
    });
    player.onPlayerStateChanged.listen((PlayerState s) async {
      if (s == PlayerState.completed) {
        await player.pause();
      }
    });
  }

  void connectToServer() {
    try {
      socket = io(socketURL, OptionBuilder().setTransports(['websocket']).enableAutoConnect().build());
      socket.connect();
      socket.onConnect((_) async {
        log("Connected with socket channel");
        profileData = authService.userAuthData;
      });

      // socket.on('new_message', (data) {
      //   log("New chat message: $data");
      //   _messageStream.add(data);
      // });

      socket.on('new_message', (data) {
        log('Socket service message');

        print(data);
        bool isNotificationEnabled = GetStorage().read(StringConstants.notificationEnabled) ?? true;
        if (isNotificationEnabled && !Get.isRegistered<CommunityChatCtrl>()) {
          final messageJson = data;
          final message = messageJson['content'] ?? "";
          final senderName = (messageJson['sender'] is Map ? messageJson['sender']['name'] : (messageJson['customerName'] ?? 'Traveler'));

          _whistle("slow_spring_board.mp3");
          notificationService.createNotificationOrder(
            "New message from $senderName",
            message.length > 50 ? "${message.substring(0, 50)}..." : message,
            messageJson,
          );
        }
        _messageStream.add(data);
      });

      socket.onDisconnect((_) async {
        profileData = authService.userAuthData;
        socket.emit('leaveRoom', {"userType": "driver", "userId": profileData["_id"].toString()});
        log('disconnect');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void emitEvent(String communityId) async {
    try {
      socket.emit('join_community', communityId);
      log("Community Joined: $communityId");
    } catch (e) {
      log("Error emitting event: connecting community, Error: $e");
    }
  }

  // void emitEvent(String event, List data) async {
  //   profileData = authService.userAuthData;
  //   try {
  //     socket.emit(event, {"userType": "driver", "userId": profileData["_id"].toString(), "coordinates": data});
  //   } catch (e) {
  //     log("Error emitting event: $event, Error: $e");
  //   }
  // }
}

class SocketEvents {
  static const String updateLocation = 'updateLocation';
}

SocketService socketService = SocketService();
