import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/events.dart';
import 'constants/enums.dart';
import 'models/chat_view_model.dart';
import 'repos/firestore_chat_repository.dart';
import 'ui/pages/chat_dashboard/widgets/chat_list.dart';
import 'ui/pages/chat_dashboard/widgets/message_list.dart';

export 'constants/enums.dart';
export 'ui/pages/chat_rooms/chat_auth.dart';

class RealtimeChat extends StatefulWidget {
  final RealtimeChatType type;
  final String? vendorName;
  final String? vendorEmail;
  final String userEmail;

  /// If the [type] is [RealtimeChatType.customerToVendor],
  /// the [vendorName] and [vendorEmail] must be provided.
  /// For other [type], the [vendorName] and [vendorEmail] will be ignored.
  const RealtimeChat({
    super.key,
    required this.type,
    required this.userEmail,
    this.vendorName,
    this.vendorEmail,
  }) : assert(
          type != RealtimeChatType.customerToVendor ||
              (type == RealtimeChatType.customerToVendor &&
                  vendorName != null &&
                  vendorEmail != null),
        );

  @override
  State<RealtimeChat> createState() => _RealtimeChatState();
}

class _RealtimeChatState extends State<RealtimeChat> {
  late final ChatViewModel _viewModel;

  StreamSubscription? _subscription;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      _init();
      _subscription = eventBus.on<EventExpiredCookie>().listen((event) {
        _isInitialized = false;
        if (mounted) {
          setState(() {});
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    if (_isInitialized) {
      return;
    }

    if (widget.type == RealtimeChatType.customerToVendor) {
      _viewModel = ChatViewModel(
        widget.type,
        widget.vendorName!,
        widget.vendorEmail!,
      );
    } else {
      _viewModel = ChatViewModel(
        widget.type,
        Configurations.adminName,
        Configurations.adminEmail,
      );
    }

    final repo = FirestoreChatRepository(
      widget.userEmail,
    );
    await _viewModel.init(repo);

    _isInitialized = true;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kConfigChat['UseRealtimeChat'] != true) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Feature not available',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (!_isInitialized) {
      return Center(
        child: kLoadingWidget(context),
      );
    }
    return Scaffold(
      body: ChangeNotifierProvider<ChatViewModel>(
        create: (BuildContext context) => _viewModel,
        builder: (BuildContext context, Widget? child) {
          switch (widget.type) {
            case RealtimeChatType.adminToCustomers:
            case RealtimeChatType.vendorToCustomers:
              return const ChatList();
            case RealtimeChatType.customerToAdmin:
            case RealtimeChatType.customerToVendor:
            default:
              return const MessageList();
          }
        },
      ),
    );
  }
}
