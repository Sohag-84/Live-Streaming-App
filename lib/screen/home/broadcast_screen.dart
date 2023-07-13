// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/config/app_id.dart';
import 'package:twitch_clone/models/user.dart';
import 'package:twitch_clone/provider/user_provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/widgets/chat.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class BroadcastScreen extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  const BroadcastScreen({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
  }) : super(key: key);

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  String baseUrl = "http://172.26.0.1:8000";
  Future<void> getToken() async {
    http.Response response = await http.get(
      Uri.parse(
        "$baseUrl/rtc/${widget.channelId}/publisher/userAccount/${Provider.of<UserProvider>(context, listen: false).user.uid}/",
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        token = response.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint("Failed to fetch the token");
    }
  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  void _addListeners() {
    _engine.setEventHandler(
      RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
        debugPrint('joinChannelSuccess $channel $uid $elapsed');
      }, userJoined: (uid, elapsed) {
        debugPrint('userJoined $uid $elapsed');
        setState(() {
          remoteUid.add(uid);
        });
      }, userOffline: (uid, reason) {
        debugPrint('userOffline $uid $reason');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      }, leaveChannel: (stats) {
        debugPrint('leaveChannel $stats');
        setState(() {
          remoteUid.clear();
        });
      }, tokenPrivilegeWillExpire: (token) async {
        //when token will expire
        //new token will be create
        await getToken();
        await _engine.renewToken(token);
      }),
    );
  }

  void _joinChannel() async {
    await getToken(); //when run this method first we get token
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannelWithUserAccount(
      token,
      widget.channelId,
      Provider.of<UserProvider>(context, listen: false).user.uid,
    );
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint("Switch camera $err");
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if ('${Provider.of<UserProvider>(context, listen: false).user.uid}${Provider.of<UserProvider>(context, listen: false).user.username}' ==
        widget.channelId) {
      await FireStoreMethods().endLiveStream(
        channelId: widget.channelId,
      );
    } else {
      await FireStoreMethods()
          .updateViewCount(id: widget.channelId, isIncrease: false);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              _renderVideo(user: user),
              if ("${user.uid}${user.username}" == widget.channelId)
                Column(
                  children: [
                    InkWell(
                      onTap: _switchCamera,
                      child: Text("Switch Camera"),
                    ),
                    InkWell(
                      onTap: onToggleMute,
                      child: Text(isMuted ? "Unmute" : "Mute"),
                    ),
                  ],
                ),
              Expanded(
                child: Chat(channelId: widget.channelId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderVideo({required User user}) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: "${user.uid}${user.username}" == widget.channelId
          ? RtcLocalView.SurfaceView(
              zOrderMediaOverlay: true,
              zOrderOnTop: true,
            )
          : remoteUid.isNotEmpty
              ? kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
              : Container(),
    );
  }
}
