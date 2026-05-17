import 'package:app_links/app_links.dart';

/// Step 7: QR Deep Link Check-in Service
/// 
/// Deep link format:
///   appda://checkin?school=DPS492&drill=drill_20240601
/// 
/// When the app opens via a QR code scan, this service parses
/// the URI and triggers a Firestore check-in record.

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();

  /// Callback fired when a check-in deep link is received
  void Function(String schoolCode, String drillId)? onCheckinLink;

  /// Call once in main.dart after Firebase init.
  /// Handles both cold-start URIs and in-app link events.
  Future<void> initialize() async {
    // Handle link that launched the app (cold start)
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }

    // Listen for links received while app is open / in background
    _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (err) {
        // ignore malformed URIs
      },
    );
  }

  void _handleUri(Uri uri) {
    // Expected: appda://checkin?school=DPS492&drill=drill_20240601
    if (uri.host == 'checkin') {
      final school = uri.queryParameters['school'];
      final drill = uri.queryParameters['drill'];
      if (school != null && drill != null) {
        onCheckinLink?.call(school, drill);
      }
    }
  }

  /// Build a check-in URI for a given school + drill
  static Uri buildCheckinUri({
    required String schoolCode,
    required String drillId,
  }) {
    return Uri(
      scheme: 'appda',
      host: 'checkin',
      queryParameters: {
        'school': schoolCode,
        'drill': drillId,
      },
    );
  }
}
