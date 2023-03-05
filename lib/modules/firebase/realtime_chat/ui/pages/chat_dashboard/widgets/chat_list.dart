import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat_view_model.dart';
import '../../chat_rooms/chat_auth.dart';
import '../../chat_rooms/chat_rooms.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: context.select((ChatViewModel _) => _.isInitialized)
          ? (context.select((ChatViewModel _) => _.isAuthenticated)
              ? const ChatRooms()
              : const ChatAuth())
          : const SizedBox(),
    );
  }
}
