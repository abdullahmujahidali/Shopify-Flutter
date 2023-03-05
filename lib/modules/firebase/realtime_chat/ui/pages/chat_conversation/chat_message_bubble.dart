import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../common/tools/gravatar.dart';
import '../../../../../../models/index.dart';
import '../../../models/chat_view_model.dart';
import '../../../models/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage chatMessage;

  final bool shouldShowInfo;
  final bool isFirstMessage;
  final bool isLastMessage;

  final bool isPrevMessageFromSameSender;
  final bool isNextMessageFromSameSender;

  final int diffWithNextInMin;
  final int diffWithPrevInMin;

  final bool shouldShowTimeSeparator;

  const ChatMessageBubble({
    Key? key,
    required this.chatMessage,
    this.shouldShowInfo = true,
    this.isFirstMessage = false,
    this.isLastMessage = false,
    this.isPrevMessageFromSameSender = false,
    this.isNextMessageFromSameSender = false,
    this.diffWithNextInMin = 0,
    this.diffWithPrevInMin = 0,
  })  : shouldShowTimeSeparator =
            isFirstMessage || diffWithNextInMin > Duration.minutesPerDay,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ChatViewModel>();
    final isMe = chatMessage.sender.isNotEmpty &&
        chatMessage.sender == model.senderEmail;
    return Padding(
      padding: EdgeInsets.only(
        top: 24.0 *
                (min(diffWithNextInMin, Duration.minutesPerHour) /
                    Duration.minutesPerHour) +
            (shouldShowInfo ? 24.0 : 0.0),
      ),
      child: Column(
        children: [
          if (shouldShowTimeSeparator)
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy')
                        .format(chatMessage.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!shouldShowInfo)
                const SizedBox(
                  width: 36.0,
                )
              else if (!isMe)
                SizedBox.square(
                  key: ValueKey('avatar-${chatMessage.sender}'),
                  dimension: 36.0,
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(
                      getGravatarUrl(chatMessage.sender),
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (shouldShowInfo && !isMe)
                      Text(
                        model.receiverEmail == chatMessage.sender
                            ? model.receiverName
                            : chatMessage.sender,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4.0),
                    Tooltip(
                      message: DateFormat().format(
                        chatMessage.createdAt.toLocal(),
                      ),
                      waitDuration: const Duration(milliseconds: 500),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? context.read<AppModel>().darkTheme
                                  ? Colors.white12
                                  : Colors.black12
                              : Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.12),
                          borderRadius: _getBorderRadius(isMe),
                        ),
                        child: Text(
                          chatMessage.text,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    if (isLastMessage)
                      Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 16.0,
                          ),
                          child: Text(
                            timeago.format(
                              chatMessage.createdAt.toLocal(),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BorderRadius _getBorderRadius(bool isMe) {
    const outerRadius = Radius.circular(20.0);
    const radius = Radius.circular(10.0);
    const zero = Radius.zero;

    final isNextAndPrevFromSameSender =
        isNextMessageFromSameSender && isPrevMessageFromSameSender;
    final defaultRadius =
        !isPrevMessageFromSameSender && !isNextMessageFromSameSender
            ? outerRadius
            : radius;

    var topLeft = isMe ? defaultRadius : zero;
    var topRight = isMe ? zero : defaultRadius;
    var bottomLeft = defaultRadius;
    var bottomRight = defaultRadius;

    final isFar = diffWithNextInMin > 15 || diffWithPrevInMin > 15;
    if (diffWithNextInMin > 15 ||
        diffWithNextInMin < 15 && !isNextMessageFromSameSender) {
      topLeft = isMe ? outerRadius : zero;
      topRight = isMe ? zero : outerRadius;
    }

    if (diffWithPrevInMin > 15 ||
        diffWithPrevInMin < 15 && !isPrevMessageFromSameSender) {
      bottomLeft = outerRadius;
      bottomRight = outerRadius;
    }

    if (isLastMessage) {
      bottomLeft = outerRadius;
      bottomRight = outerRadius;
    }

    if (!isFar && isNextAndPrevFromSameSender) {
      bottomLeft = isMe ? bottomLeft : radius;
      bottomRight = isMe ? radius : bottomRight;
      topLeft = isMe ? topLeft : radius;
      topRight = isMe ? radius : topRight;
    }

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }
}
