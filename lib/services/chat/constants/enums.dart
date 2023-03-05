/// List of supported chat providers
enum ChatProviders {
  zohoSalesiq;

  @override
  String toString() {
    return name;
  }
}

/// Convert chat provider from string
extension ChatProvidersExtension on String? {
  ChatProviders? toChatProviders() {
    switch (this) {
      case 'zohoSalesiq':
        return ChatProviders.zohoSalesiq;
      default:
        return null;
    }
  }
}
