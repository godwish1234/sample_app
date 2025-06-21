import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_app/services/interfaces/navigation_service.dart';

class ForumPost {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String title;
  final String content;
  final DateTime postedAt;
  final int likes;
  final int comments;
  final String sportType;

  ForumPost({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.title,
    required this.content,
    required this.postedAt,
    required this.likes,
    required this.comments,
    required this.sportType,
  });
}

class EventItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime eventDate;
  final String location;
  final String sportType;
  final int attendees;
  final bool isAttending;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.eventDate,
    required this.location,
    required this.sportType,
    required this.attendees,
    this.isAttending = false,
  });

  EventItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? eventDate,
    String? location,
    String? sportType,
    int? attendees,
    bool? isAttending,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      eventDate: eventDate ?? this.eventDate,
      location: location ?? this.location,
      sportType: sportType ?? this.sportType,
      attendees: attendees ?? this.attendees,
      isAttending: isAttending ?? this.isAttending,
    );
  }
}

class TeamChallenge {
  final String id;
  final String teamName;
  final String teamLogoUrl;
  final String sportType;
  final DateTime challengeDate;
  final String location;
  final String description;
  final int playersNeeded;

  TeamChallenge({
    required this.id,
    required this.teamName,
    required this.teamLogoUrl,
    required this.sportType,
    required this.challengeDate,
    required this.location,
    required this.description,
    required this.playersNeeded,
  });
}

class EventViewModel extends BaseViewModel {
  final _navigationService = GetIt.instance<NavigationService>();

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void setSelectedTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  List<ForumPost> _forumPosts = [];
  List<ForumPost> get forumPosts => _forumPosts;

  List<EventItem> _events = [];
  List<EventItem> get events => _events;

  List<TeamChallenge> _challenges = [];
  List<TeamChallenge> get challenges => _challenges;

  bool _isLoadingPosts = false;
  bool get isLoadingPosts => _isLoadingPosts;

  bool _isBusy = false;
  bool get isBusy => _isBusy;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    await Future.wait([
      _loadForumPosts(),
      _loadEvents(),
      _loadChallenges(),
    ]);
  }

  Future<void> _loadForumPosts() async {
    _isLoadingPosts = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _forumPosts = _getSampleForumPosts();
    } catch (e) {
      debugPrint('Error loading forum posts: $e');
    } finally {
      _isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<void> _loadEvents() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _events = _getSampleEvents();
    } catch (e) {
      debugPrint('Error loading events: $e');
    }
    notifyListeners();
  }

  Future<void> _loadChallenges() async {
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      _challenges = _getSampleChallenges();
    } catch (e) {
      debugPrint('Error loading challenges: $e');
    }
    notifyListeners();
  }

  Future<void> refreshCommunityData() async {
    setBusy(true);
    await initialize();
    setBusy(false);
  }

  void navigateToForumDetail(String postId) {
    debugPrint('Navigating to forum post: $postId');
    // _navigationService.navigateToForumDetail(postId);
  }

  void navigateToEventDetail(String eventId) {
    debugPrint('Navigating to event: $eventId');
    // _navigationService.navigateToEventDetail(eventId);
  }

  void navigateToChallengeDetail(String challengeId) {
    debugPrint('Navigating to challenge: $challengeId');
    // _navigationService.navigateToChallengeDetail(challengeId);
  }

  void toggleEventAttendance(String eventId) {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index >= 0) {
      final event = _events[index];
      _events[index] = event.copyWith(
        attendees: event.isAttending ? event.attendees - 1 : event.attendees + 1,
        isAttending: !event.isAttending,
      );
      notifyListeners();
    }
  }

  void likeForumPost(String postId) {
    final index = _forumPosts.indexWhere((post) => post.id == postId);
    if (index >= 0) {
      final post = _forumPosts[index];
      _forumPosts[index] = ForumPost(
        id: post.id,
        authorName: post.authorName,
        authorAvatarUrl: post.authorAvatarUrl,
        title: post.title,
        content: post.content,
        postedAt: post.postedAt,
        likes: post.likes + 1,
        comments: post.comments,
        sportType: post.sportType,
      );
      notifyListeners();
    }
  }

  void navigateToCreateForumPost() {
    debugPrint('Navigating to create forum post');
    // _navigationService.navigateToCreateForumPost();
  }

  void navigateToCreateChallenge() {
    debugPrint('Navigating to create challenge');
    // _navigationService.navigateToCreateChallenge();
  }

  List<ForumPost> _getSampleForumPosts() {
    final now = DateTime.now();

    return [
      ForumPost(
        id: '1',
        authorName: 'Michael Jordan',
        authorAvatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        title: 'Any tips for improving my jump shot?',
        content:
            "I've been practicing for weeks but can't seem to get consistent. Any drills or tips from the pros here?",
        postedAt: now.subtract(const Duration(hours: 3)),
        likes: 24,
        comments: 8,
        sportType: 'Basketball',
      ),
      ForumPost(
        id: '2',
        authorName: 'Serena Williams',
        authorAvatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
        title: 'Looking for tennis partner in Downtown area',
        content:
            "Intermediate player available weekday evenings and weekend mornings. Let me know if you're interested!",
        postedAt: now.subtract(const Duration(hours: 5)),
        likes: 15,
        comments: 12,
        sportType: 'Tennis',
      ),
      ForumPost(
        id: '3',
        authorName: 'Carlos Alvarado',
        authorAvatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
        title: 'Best indoor courts during rainy season?',
        content:
            "With the wet weather coming, what are your recommendations for good indoor facilities that don't get too crowded?",
        postedAt: now.subtract(const Duration(hours: 8)),
        likes: 32,
        comments: 17,
        sportType: 'General',
      ),
      ForumPost(
        id: '4',
        authorName: 'Emily Chang',
        authorAvatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
        title: 'Volleyball tournament next month - forming a team!',
        content:
            'Looking for 3-4 more players to join our recreational volleyball team for the city tournament. All skill levels welcome!',
        postedAt: now.subtract(const Duration(days: 1, hours: 2)),
        likes: 41,
        comments: 23,
        sportType: 'Volleyball',
      ),
      ForumPost(
        id: '5',
        authorName: 'James Wilson',
        authorAvatarUrl: 'https://randomuser.me/api/portraits/men/5.jpg',
        title: 'Review of new badminton courts at Westside Recreation Center',
        content:
            'Just played at the newly renovated courts and wanted to share my thoughts. The lighting is excellent and the floors are top quality!',
        postedAt: now.subtract(const Duration(days: 2)),
        likes: 28,
        comments: 9,
        sportType: 'Badminton',
      ),
    ];
  }

  List<EventItem> _getSampleEvents() {
    final now = DateTime.now();

    return [
      EventItem(
        id: '1',
        title: 'Community Basketball Tournament',
        description:
            'Annual 3v3 tournament with prizes for top teams. All skill levels welcome!',
        imageUrl:
            'https://images.unsplash.com/photo-1519861531473-9200262188bf',
        eventDate: now.add(const Duration(days: 12)),
        location: 'Downtown Sports Center',
        sportType: 'Basketball',
        attendees: 42,
      ),
      EventItem(
        id: '2',
        title: 'Tennis Workshop with Pro Coach',
        description:
            'Learn advanced techniques from former national champion Alex Williams.',
        imageUrl:
            'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0',
        eventDate: now.add(const Duration(days: 5)),
        location: 'Eastside Tennis Club',
        sportType: 'Tennis',
        attendees: 18,
      ),
      EventItem(
        id: '3',
        title: 'Family Sports Day',
        description:
            'A day of fun sports activities for the whole family. Food and refreshments provided.',
        imageUrl:
            'https://images.unsplash.com/photo-1517649763962-0c623066013b',
        eventDate: now.add(const Duration(days: 20)),
        location: 'City Park',
        sportType: 'Multiple Sports',
        attendees: 87,
      ),
    ];
  }

  List<TeamChallenge> _getSampleChallenges() {
    final now = DateTime.now();

    return [
      TeamChallenge(
        id: '1',
        teamName: 'Downtown Dribblers',
        teamLogoUrl: 'https://via.placeholder.com/150?text=DD',
        sportType: 'Basketball',
        challengeDate: now.add(const Duration(days: 7)),
        location: 'Central Courts',
        description:
            "Looking for a challenging match! We're an intermediate team with players aged 25-35.",
        playersNeeded: 0,
      ),
      TeamChallenge(
        id: '2',
        teamName: 'Westside Smashers',
        teamLogoUrl: 'https://via.placeholder.com/150?text=WS',
        sportType: 'Volleyball',
        challengeDate: now.add(const Duration(days: 4)),
        location: 'Westside Beach Courts',
        description:
            'Beach volleyball team seeking opponents for friendly matches on weekends.',
        playersNeeded: 0,
      ),
      TeamChallenge(
        id: '3',
        teamName: 'Nighthawks FC',
        teamLogoUrl: 'https://via.placeholder.com/150?text=NFC',
        sportType: 'Soccer',
        challengeDate: now.add(const Duration(days: 14)),
        location: 'Memorial Stadium',
        description:
            'Semi-professional team looking for a practice match. All team levels welcome.',
        playersNeeded: 0,
      ),
      TeamChallenge(
        id: '4',
        teamName: 'The Racqueteers',
        teamLogoUrl: 'https://via.placeholder.com/150?text=TR',
        sportType: 'Badminton',
        challengeDate: now.add(const Duration(days: 10)),
        location: 'Indoor Sports Hall',
        description:
            'Looking for doubles teams for friendly tournament. Intermediate level.',
        playersNeeded: 2,
      ),
    ];
  }
}

extension EventViewModelUpdate on EventViewModel {
  void updateEventAttendance(EventItem updatedEvent) {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }
}