import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../common/extensions/extensions.dart';
import '../../../../../../common/tools/gravatar.dart';
import '../../../../../../generated/l10n.dart';
import '../../../models/chat_view_model.dart';
import '../../../models/entities/chat_room.dart';
import '../../../models/entities/chat_user.dart';

class ChatRoomItem extends StatefulWidget {
  final ChatRoom chatRoom;
  final ChatUser? chatUser;

  final VoidCallback onTap;

  const ChatRoomItem({
    super.key,
    required this.chatRoom,
    this.chatUser,
    required this.onTap,
  });

  @override
  State<ChatRoomItem> createState() => _ChatRoomItemState();
}

class _ChatRoomItemState extends State<ChatRoomItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final model = context.read<ChatViewModel>();
    final isAdmin = model.isAdminOrVendor;
    final currentUserEmail = widget.chatUser?.email ?? '';
    if (currentUserEmail.isEmpty) {
      /// Hide invalid chat.
      return const SizedBox.shrink();
    }
    final unread = widget.chatRoom.getOtherUser(currentUserEmail)?.unread ?? 0;
    return MouseRegion(
      onExit: (_) => setState(() => isHovered = false),
      onEnter: (_) => setState(() => isHovered = true),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: context.select((ChatViewModel _) =>
                        _.selectedChatRoomId == widget.chatRoom.id) ||
                    isHovered
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.select((ChatViewModel _) =>
                      _.selectedChatRoomId == widget.chatRoom.id)
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.chatUser?.isActive == true
                      ? Colors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: widget.chatUser?.isActive == true
                        ? Colors.green
                        : Colors.grey,
                    width: 1,
                  ),
                ),
                child: const SizedBox(
                  width: 8,
                  height: 8,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox.square(
                dimension: 32.0,
                child: CircleAvatar(
                  foregroundImage: NetworkImage(
                    getGravatarUrl(widget.chatUser?.email ?? ''),
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Tooltip(
                      message: widget.chatUser?.email ?? '',
                      waitDuration: const Duration(milliseconds: 500),
                      child: Text(
                        widget.chatUser?.email ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: unread > 0 ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (isAdmin
                            ? widget.chatRoom.userTyping
                            : widget.chatRoom.adminTyping)
                          Flexible(
                            child: Text(
                              S.of(context).typing,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else if (widget.chatRoom.latestMessage.isNotEmpty)
                          Flexible(
                            child: Tooltip(
                              waitDuration: const Duration(milliseconds: 500),
                              message: widget.chatRoom.latestMessage,
                              child: Text(
                                widget.chatRoom.latestMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight:
                                      unread > 0 ? FontWeight.w500 : null,
                                  color: unread > 0
                                      ? null
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (widget.chatUser?.email != null && unread > 0) ...[
                const SizedBox(width: 16),
                Container(
                  height: 24,
                  width: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
              const SizedBox(width: 16),
              Text(
                timeago.format(widget.chatRoom.createdAt.toLocal()),
                style: context.theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
