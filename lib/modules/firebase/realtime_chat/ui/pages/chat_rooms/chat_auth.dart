import 'package:flutter/material.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../common/events.dart';
import '../../../../../../generated/l10n.dart';

class ChatAuth extends StatefulWidget {
  const ChatAuth({super.key});

  @override
  State<ChatAuth> createState() => _ChatAuthState();
}

class _ChatAuthState extends State<ChatAuth> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 450.0,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 48.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              Text(
                S.of(context).sessionExpired,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                S.of(context).loginToContinue,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _handleLogin,
                child: Text(S.of(context).signIn),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  context.navigator.pop();
                },
                child: Text(S.of(context).goBack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    eventBus.fire(
      const EventExpiredCookie(
        isRequiredLogin: true,
        skipDuplicateCheck: true,
      ),
    );
  }
}
