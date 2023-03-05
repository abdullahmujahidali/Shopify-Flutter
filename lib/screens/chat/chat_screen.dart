import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart' as config;
import '../../models/user_model.dart';
import '../../services/services.dart';

class ChatScreen extends StatefulWidget {
  final bool? isVendor;

  const ChatScreen({
    this.isVendor,
  });

  @override
  State<ChatScreen> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return ListenableProvider.value(
      value: userModel,
      child: Consumer<UserModel>(
        builder: (context, value, child) {
          final user = value.user;
          if (user == null) {
            return Services().firebase.renderChatAuthScreen();
          }
          if (user.email == config.adminEmail) {
            return Services().firebase.renderListChatScreen();
          }
          if (widget.isVendor == true) {
            return Services().firebase.renderVendorListChatScreen(
                  email: user.email,
                );
          }
          return Services().firebase.renderChatScreen(senderUser: value.user);
        },
      ),
    );
  }
}
