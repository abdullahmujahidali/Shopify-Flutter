import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/tools/gravatar.dart';
import '../../../../../../generated/l10n.dart';
import '../../../models/chat_view_model.dart';
import '../../../models/entities/chat_room.dart';

class ChatTypingStatus extends StatefulWidget {
  const ChatTypingStatus({super.key});

  @override
  State<ChatTypingStatus> createState() => _ChatTypingStatusState();
}

class _ChatTypingStatusState extends State<ChatTypingStatus>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final model = context.read<ChatViewModel>();
    final isAdminOrVendor = model.isAdminOrVendor;
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: StreamBuilder<ChatRoom>(
        stream: model.selectedChatRoomStream,
        builder: (context, snapshot) {
          final chatRoom = snapshot.data;

          if (chatRoom?.userTyping == null || chatRoom?.adminTyping == null) {
            return const SizedBox(width: double.infinity);
          }

          if (isAdminOrVendor && (chatRoom?.userTyping ?? false) ||
              !isAdminOrVendor && (chatRoom?.adminTyping ?? false)) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 10.0,
                    backgroundImage: NetworkImage(
                      getGravatarUrl(
                        context.select<ChatViewModel, String>(
                          (ChatViewModel _) => _.receiverEmail,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      S.of(context).isTyping,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox(width: double.infinity);
        },
      ),
    );
  }
}
