import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrayerCountdownWidget extends StatefulWidget {
  final Map<String, DateTime> prayers;

  const PrayerCountdownWidget({super.key, required this.prayers});

  @override
  State<PrayerCountdownWidget> createState() => _PrayerCountdownWidgetState();
}

class _PrayerCountdownWidgetState extends State<PrayerCountdownWidget> {
  late Timer _timer;
  late String _nextPrayer;
  late Duration _remaining;

  bool _isPrayerNow = false;

  @override
  void initState() {
    super.initState();
    _calculateNextPrayer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _calculateNextPrayer() {
    final now = DateTime.now();
    final upcoming =
        widget.prayers.entries
            .where((entry) => entry.value.isAfter(now))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    if (upcoming.isNotEmpty) {
      _nextPrayer = upcoming.first.key;
      _remaining = upcoming.first.value.difference(now);
    } else {
      // if no prayers left today → pick the first one tomorrow
      final first = widget.prayers.entries.first;
      _nextPrayer = first.key;
      _remaining = first.value.add(const Duration(days: 1)).difference(now);
    }
  }

  void _tick() {
    final now = DateTime.now();
    final target = widget.prayers[_nextPrayer]!;

    if (!_isPrayerNow &&
        now.isAfter(target) &&
        now.isBefore(target.add(const Duration(minutes: 1)))) {
      setState(() {
        _isPrayerNow = true;
      });
    } else if (_isPrayerNow &&
        now.isAfter(target.add(const Duration(minutes: 1)))) {
      setState(() {
        _isPrayerNow = false;
        _calculateNextPrayer();
      });
    } else if (!_isPrayerNow) {
      if (now.isAfter(widget.prayers.entries.last.value)) {
        setState(() {
          _remaining = target.add(const Duration(days: 1)).difference(now);
        });
      } else {
        setState(() {
          _remaining = target.difference(now);
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: _isPrayerNow
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.alarm, size: 60, color: Colors.tealAccent),
                  Text(
                    "${'it_is_time_for'.tr()} $_nextPrayer!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$_nextPrayer ${'will_start_in'.tr()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${_remaining.inHours.toString().padLeft(2, '0')}:"
                    "${(_remaining.inMinutes % 60).toString().padLeft(2, '0')}:"
                    "${(_remaining.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
