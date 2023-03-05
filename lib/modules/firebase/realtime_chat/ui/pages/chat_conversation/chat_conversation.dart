import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chat_view_model.dart';
import '../../../models/entities/chat_message.dart';
import '../chat_rooms/chat_auth.dart';
import 'chat_message_bubble.dart';
import 'chat_typing_status.dart';

class ChatConversation extends StatefulWidget {
  const ChatConversation({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get isTyping =>
      _textEditingController.text.isNotEmpty && _focusNode.hasFocus;

  int _lastReceiverMessageIndex = 0;
  int _lastSenderMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        _focusNode.requestFocus();
        _focusNode.addListener(_updateTypingStatus);
      }
    });
  }

  void _updateTypingStatus() {
    if (!mounted) {
      return;
    }
    final model = context.read<ChatViewModel>();
    final chatRoomId = model.selectedChatRoomId;
    if (chatRoomId == null) {
      return;
    }
    model.updateTypingStatus(chatRoomId, isTyping);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_updateTypingStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Selector<ChatViewModel, String?>(
        selector: (BuildContext __, ChatViewModel _) => _.selectedChatRoomId,
        builder: (BuildContext context, String? chatRoomId, __) {
          if (chatRoomId == null) {
            // Not used.
            return const SizedBox();
          }
          return GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: Column(
              children: [
                Expanded(
                  child: Selector<ChatViewModel, Stream<List<ChatMessage>>>(
                    selector: (BuildContext __, ChatViewModel _) =>
                        _.getChatConversation(chatRoomId),
                    builder:
                        (BuildContext _, Stream<List<ChatMessage>> stream, __) {
                      return StreamBuilder<List<ChatMessage>>(
                        stream: stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ChatMessage>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.active:
                              if (snapshot.hasError) {
                                if ('${snapshot.error}'
                                    .contains('permission-denied')) {
                                  return const ChatAuth();
                                }
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }
                              if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                final chatMessages = snapshot.data!;
                                final model = context.read<ChatViewModel>();
                                final senderEmail = model.senderEmail;
                                final receiverEmail = model.receiverEmail;
                                _lastReceiverMessageIndex =
                                    chatMessages.indexWhere(
                                  (ChatMessage message) =>
                                      message.sender == receiverEmail,
                                );
                                _lastSenderMessageIndex =
                                    chatMessages.indexWhere(
                                  (ChatMessage message) =>
                                      message.sender == senderEmail,
                                );
                                return ListView.builder(
                                  key: ValueKey(chatRoomId),
                                  reverse: true,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 16.0,
                                  ),
                                  itemCount: chatMessages.length + 1,
                                  itemBuilder: (context, fakeIndex) {
                                    if (fakeIndex == 0) {
                                      return const ChatTypingStatus();
                                    }
                                    final index = fakeIndex - 1;
                                    final msg = chatMessages[index];
                                    final shouldShowInfo =
                                        (index + 1) == chatMessages.length ||
                                            chatMessages[index + 1].sender !=
                                                msg.sender;
                                    final isLastMessage =
                                        index == _lastSenderMessageIndex ||
                                            index == _lastReceiverMessageIndex;
                                    var diffWithNextInMin =
                                        (index + 1) != chatMessages.length
                                            ? (chatMessages[index + 1]
                                                    .createdAt
                                                    .difference(msg.createdAt)
                                                    .inMinutes)
                                                .abs()
                                            : 0;

                                    var diffWithPrevInMin = index != 0
                                        ? (chatMessages[index - 1]
                                                .createdAt
                                                .difference(msg.createdAt)
                                                .inMinutes)
                                            .abs()
                                        : 0;

                                    if (diffWithNextInMin <
                                        Duration.minutesPerHour / 4) {
                                      diffWithNextInMin = 0;
                                    }
                                    if (diffWithPrevInMin <
                                        Duration.minutesPerHour / 4) {
                                      diffWithPrevInMin = 0;
                                    }

                                    final isNextMessageFromSameSender =
                                        (index + 1) != chatMessages.length &&
                                            chatMessages[index + 1].sender ==
                                                msg.sender;

                                    final isPrevMessageFromSameSender =
                                        index != 0 &&
                                            chatMessages[index - 1].sender ==
                                                msg.sender;

                                    return ChatMessageBubble(
                                      key: ValueKey(
                                        '$chatRoomId-${msg.toJson()}',
                                      ),
                                      shouldShowInfo: shouldShowInfo,
                                      isFirstMessage:
                                          index + 1 == chatMessages.length,
                                      isLastMessage: isLastMessage,
                                      chatMessage: msg,
                                      diffWithNextInMin: diffWithNextInMin,
                                      diffWithPrevInMin: diffWithPrevInMin,
                                      isPrevMessageFromSameSender:
                                          isPrevMessageFromSameSender,
                                      isNextMessageFromSameSender:
                                          isNextMessageFromSameSender,
                                    );
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            default:
                              return const SizedBox.shrink();
                          }
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            textInputAction: TextInputAction.send,
                            controller: _textEditingController,
                            onChanged: (_) => EasyDebounce.debounce(
                              'chat-message-update-typing-status',
                              const Duration(milliseconds: 1000),
                              () => _updateTypingStatus(),
                            ),
                            onSubmitted: (String text) {
                              _sendMessage(chatRoomId);
                            },
                            onEditingComplete: () {
                              _sendMessage(chatRoomId);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => _sendMessage(chatRoomId),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(String chatRoomId) {
    if (_textEditingController.text.isNotEmpty) {
      final model = context.read<ChatViewModel>();
      model.sendChatMessage(
        chatRoomId,
        '',
        _textEditingController.text,
      );
      _textEditingController.clear();
    }
  }
}
