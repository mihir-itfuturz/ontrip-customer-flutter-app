import 'package:video_player/video_player.dart';

import '../../../app_export.dart';

class MediaDisplayScreen extends StatefulWidget {
  final String url;
  final bool isVideo;
  final String? title;

  const MediaDisplayScreen({
    super.key,
    required this.url,
    required this.isVideo,
    this.title,
  });

  @override
  State<MediaDisplayScreen> createState() => _MediaDisplayScreenState();
}

class _MediaDisplayScreenState extends State<MediaDisplayScreen> {
  VideoPlayerController? _videoCtrl;
  bool _isInitializing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    setState(() {
      _isInitializing = true;
      _error = null;
    });

    try {
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await _videoCtrl!.initialize();
      _videoCtrl!.setLooping(false);
    } catch (e) {
      debugPrint("Video init error: $e");
      _error = "Unable to load video";
    } finally {
      if (mounted) setState(() => _isInitializing = false);
    }
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final ctrl = _videoCtrl;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (ctrl.value.isPlaying) {
      ctrl.pause();
    } else {
      ctrl.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title ?? (widget.isVideo ? "Video" : "Photo");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: widget.isVideo ? _buildVideo() : _buildImage(),
    );
  }

  Widget _buildImage() {
    return Center(
      child: InteractiveViewer(
        minScale: 0.8,
        maxScale: 5.0,
        child: CustomNetworkImage(imageUrl: widget.url, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildVideo() {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 60),
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initVideo,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final ctrl = _videoCtrl;
    if (ctrl == null || !ctrl.value.isInitialized) {
      return const Center(child: Text("Video not ready", style: TextStyle(color: Colors.white70)));
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(aspectRatio: ctrl.value.aspectRatio, child: VideoPlayer(ctrl)),
          ),
          if (!ctrl.value.isPlaying)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 56),
            ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(image: AssetImage(Graphics.instance.logo), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "VIDEO",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

