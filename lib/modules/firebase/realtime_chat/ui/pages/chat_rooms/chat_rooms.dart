import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../generated/l10n.dart';
import '../../../models/chat_view_model.dart';
import '../../../models/entities/chat_room.dart';
import '../chat_dashboard/widgets/message_list.dart';
import 'chat_auth.dart';
import 'chat_room_item.dart';

class ChatRooms extends StatelessWidget {
  final ScrollController? scrollController;

  const ChatRooms({
    super.key,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = context.select((ChatViewModel _) => _.senderEmail);
    return Selector<ChatViewModel, Stream<List<ChatRoom>>>(
      selector: (BuildContext __, ChatViewModel _) => _.chatRooms,
      builder: (BuildContext _, Stream<List<ChatRoom>> stream, __) {
        return StreamBuilder<List<ChatRoom>>(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<ChatRoom>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                if (snapshot.hasError) {
                  if ('${snapshot.error}'.contains('permission-denied')) {
                    return const ChatAuth();
                  }
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.hasData) {
                  final chatRooms = snapshot.data!;
                  if (chatRooms.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).noConversation,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            S.of(context).noConversationDescription,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: (context.select(
                            (ChatViewModel _) => _.selectedChatRoomId != null))
                        ? const MessageList()
                        : Scaffold(
                            appBar: AppBar(
                              backgroundColor: Theme.of(context).cardColor,
                              titleSpacing: 0.0,
                              title: Text(S.of(context).conversations),
                            ),
                            body: ListView.builder(
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                final chatRoom = chatRooms[index];
                                if (currentUserEmail.isEmpty) {
                                  /// Hide invalid chat.
                                  return const SizedBox();
                                }
                                final chatUser = chatRoom.getOtherUser(
                                  currentUserEmail,
                                );
                                return ChatRoomItem(
                                  chatRoom: chatRoom,
                                  chatUser: chatUser,
                                  onTap: () => _handleChatRoomTap(
                                    context,
                                    chatRoom,
                                  ),
                                );
                              },
                              itemCount: chatRooms.length,
                            ),
                          ),
                  );
                }
                return const SizedBox.shrink();
              default:
                return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  void _handleChatRoomTap(BuildContext context, ChatRoom chatRoom) {
    final model = context.read<ChatViewModel>();
    if (chatRoom.id == model.selectedChatRoomId) {
      return;
    }
    model.selectedChatRoomId = chatRoom.id;
  }
}
