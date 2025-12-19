import 'package:stacked/stacked.dart';

class ChatItem {
  final String id;
  final String friendId;
  final String friendName;
  final String friendAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatItem({
    required this.id,
    required this.friendId,
    required this.friendName,
    required this.friendAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class FriendRequest {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String phoneNumber;
  final DateTime requestTime;
  final String status; // 'pending', 'accepted', 'rejected'

  FriendRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.phoneNumber,
    required this.requestTime,
    this.status = 'pending',
  });
}

class ChatViewModel extends BaseViewModel {
  List<ChatItem> _chats = [];
  List<FriendRequest> _friendRequests = [];

  List<ChatItem> get chats => _chats;
  List<FriendRequest> get pendingRequests =>
      _friendRequests.where((r) => r.status == 'pending').toList();

  bool get hasChats => _chats.isNotEmpty;
  bool get hasPendingRequests => pendingRequests.isNotEmpty;

  String? _searchError;
  String? get searchError => _searchError;

  void initialize() {
    setBusy(true);
    // TODO: Fetch chats and friend requests from API
    // For now, using empty list as mentioned by user
    _chats = [];
    _friendRequests = [];
    setBusy(false);
  }

  Future<void> searchFriendByPhone(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      _searchError = 'Please enter a phone number';
      notifyListeners();
      return;
    }

    setBusy(true);
    _searchError = null;
    notifyListeners();

    try {
      // TODO: Search user by phone number in database
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // For now, simulate not found
      _searchError = 'User not found with this phone number';

      // TODO: If user found, show dialog to send friend request
      // await sendFriendRequest(userId);
    } catch (e) {
      _searchError = 'Error searching for user';
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> sendFriendRequest(String userId) async {
    setBusy(true);
    try {
      // TODO: Send friend request to backend
      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: Show success message
      notifyListeners();
    } catch (e) {
      // TODO: Show error message
    } finally {
      setBusy(false);
    }
  }

  Future<void> acceptFriendRequest(String requestId) async {
    // TODO: Accept friend request in backend
    final index = _friendRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      // Update status locally
      notifyListeners();
    }
  }

  Future<void> rejectFriendRequest(String requestId) async {
    // TODO: Reject friend request in backend
    _friendRequests.removeWhere((r) => r.id == requestId);
    notifyListeners();
  }

  void openChat(String chatId) {
    // TODO: Navigate to chat detail page
  }

  void deleteChat(String chatId) {
    _chats.removeWhere((c) => c.id == chatId);
    // TODO: Delete from backend
    notifyListeners();
  }
}
