  import 'package:flutter/material.dart';

  class MarqueeText extends StatefulWidget {
    final String text;
    final TextStyle? style;
    final double velocity;
    final Duration pauseDuration;
    final bool showScrollHint;

    const MarqueeText({
      super.key,
      required this.text,
      this.style,
      this.velocity = 50.0,
      this.pauseDuration = const Duration(seconds: 1),
      this.showScrollHint = true,
    });

    @override
    State<MarqueeText> createState() => _AdvancedMarqueeTextState();
  }

  class _AdvancedMarqueeTextState extends State<MarqueeText> {
    late ScrollController _scrollController;
    bool _needsScrolling = false;
    bool _userInteracting = false;
    bool _showHint = true;

    @override
    void initState() {
      super.initState();
      _scrollController = ScrollController();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkIfScrollingNeeded();
      });

      // Hide hint after 3 seconds
      if (widget.showScrollHint) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showHint = false;
            });
          }
        });
      }
    }

    void _checkIfScrollingNeeded() {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        if (maxScrollExtent > 0) {
          setState(() {
            _needsScrolling = true;
          });
          _startAutoScroll();
        }
      }
    }

    void _startAutoScroll() async {
      if (!_needsScrolling || _userInteracting) return;

      await Future.delayed(widget.pauseDuration);

      while (mounted && _needsScrolling && !_userInteracting) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final duration = Duration(
          milliseconds: (maxScrollExtent / widget.velocity * 1000).round(),
        );

        await _scrollController.animateTo(
          maxScrollExtent,
          duration: duration,
          curve: Curves.linear,
        );

        if (!mounted || _userInteracting) break;
        await Future.delayed(widget.pauseDuration);

        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        if (!mounted || _userInteracting) break;
        await Future.delayed(widget.pauseDuration);
      }
    }

    @override
    void dispose() {
      _scrollController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollStartNotification) {
                setState(() {
                  _userInteracting = true;
                  _showHint = false;
                });
              } else if (notification is ScrollEndNotification) {
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _userInteracting = false;
                    });
                    _startAutoScroll();
                  }
                });
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: [
                  Text(
                    widget.text,
                    style: widget.style,
                    maxLines: 1,
                  ),
                  if (_needsScrolling) const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          // Scroll hint
          if (_needsScrolling && _showHint && widget.showScrollHint)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }