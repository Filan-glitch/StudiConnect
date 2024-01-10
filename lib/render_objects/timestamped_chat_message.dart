import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class TimestampedChatMessage extends LeafRenderObjectWidget {
  const TimestampedChatMessage({
    super.key,
    required this.sender,
    required this.sentAt,
    required this.text,
    this.brightness = Brightness.light,
  });

  final String sender;
  final String sentAt;
  final String text;
  final Brightness brightness;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimestampedChatMessageRenderObject(
      sender: sender,
      sentAt: sentAt,
      text: text,
      brightness: brightness,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, TimestampedChatMessageRenderObject renderObject) {
    renderObject
      ..sender = sender
      ..sentAt = sentAt
      ..text = text
      ..textDirection = Directionality.of(context);
  }
}

class TimestampedChatMessageRenderObject extends RenderBox {
  TimestampedChatMessageRenderObject({
    required String sender,
    required String sentAt,
    required String text,
    required TextDirection textDirection,
    required Brightness brightness,
  })  : _sender = sender,
        _sentAt = sentAt,
        _text = text,
        _brightness = brightness,
        _textDirection = textDirection {
    _textPainter = TextPainter(
      text: textTextSpan,
      textDirection: textDirection,
    );
    _sentAtTextPainter = TextPainter(
      text: sentAtTextSpan,
      textDirection: textDirection,
    );
    _senderTextPainter = TextPainter(
      text: senderTextSpan,
      textDirection: textDirection,
    );
  }

  late String _sender;
  late String _sentAt;
  late String _text;
  late TextDirection _textDirection;
  late Brightness _brightness;

  late TextPainter _textPainter;
  late TextPainter _sentAtTextPainter;
  late TextPainter _senderTextPainter;

  late bool _sentAtFitsOnLastLine;
  late double _lineHeight;
  late double _lastMessageLineWidth;
  late double _longestLineWidth;
  late double _sentAtLineWidth;
  late int _numMessageLines;

  String get sender => _sender;
  set sender(String value) {
    if (value == _sender) return;
    _sender = value;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  String get text => _text;
  set text(String value) {
    if (value == _text) return;
    _text = value;
    _textPainter.text = textTextSpan;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  String get sentAt => _sentAt;
  set sentAt(String value) {
    if (value == _sentAt) return;
    _sentAt = value;
    _sentAtTextPainter.text = sentAtTextSpan;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  Brightness get brightness => _brightness;
  set brightness(Brightness value) {
    if (value == _brightness) return;
    _brightness = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
    markNeedsPaint();
  }

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    _textPainter.textDirection = value;
    _sentAtTextPainter.textDirection = value;
  }

  TextSpan get textTextSpan => TextSpan(
      text: _text,
      style: TextStyle(
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ));
  TextSpan get sentAtTextSpan =>
      TextSpan(text: _sentAt, style: const TextStyle(color: Colors.grey));
  TextSpan get senderTextSpan => TextSpan(
      text: _sender,
      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold));

  @override
  void performLayout() {
    // Message
    _textPainter.layout(maxWidth: constraints.maxWidth);
    final textLines = _textPainter.computeLineMetrics();

    // Sent at
    _sentAtTextPainter.layout(maxWidth: constraints.maxWidth);
    _sentAtLineWidth = _sentAtTextPainter.computeLineMetrics().first.width;

    // Sender
    _senderTextPainter.layout(maxWidth: constraints.maxWidth);

    _longestLineWidth = 0;
    for (final line in textLines) {
      _longestLineWidth = max(_longestLineWidth, line.width);
    }

    _lastMessageLineWidth = textLines.last.width;
    _lineHeight = textLines.first.height;
    _numMessageLines = textLines.length;

    final sizeOfMessage = Size(_longestLineWidth, _textPainter.height);
    final lastLineWithSentAt = _lastMessageLineWidth + _sentAtLineWidth * 1.1;
    if (textLines.length == 1) {
      _sentAtFitsOnLastLine = lastLineWithSentAt < constraints.maxWidth;
    } else {
      _sentAtFitsOnLastLine =
          lastLineWithSentAt < min(_longestLineWidth, constraints.maxWidth);
    }

    double senderHeight = _sender.isEmpty ? 0 : _senderTextPainter.height;
    late Size computedSize;
    if (!_sentAtFitsOnLastLine) {
      computedSize = Size(
        sizeOfMessage.width,
        sizeOfMessage.height + _sentAtTextPainter.height + senderHeight,
      );
    } else {
      if (textLines.length == 1) {
        computedSize =
            Size(lastLineWithSentAt, sizeOfMessage.height + senderHeight);
      } else {
        computedSize =
            Size(_longestLineWidth, sizeOfMessage.height + senderHeight);
      }
    }
    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _senderTextPainter.paint(context.canvas, offset);

    double senderHeight = _sender.isEmpty ? 0 : _senderTextPainter.height;

    late Offset messageOffset;
    messageOffset = Offset(
      offset.dx,
      offset.dy + senderHeight,
    );

    _textPainter.paint(context.canvas, messageOffset);

    late Offset sentAtOffset;
    if (_sentAtFitsOnLastLine) {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_lineHeight * (_numMessageLines - 1) + senderHeight),
      );
    } else {
      sentAtOffset = Offset(
        offset.dx + (size.width - _sentAtLineWidth),
        offset.dy + (_lineHeight * _numMessageLines + senderHeight) + 3,
      );
    }

    _sentAtTextPainter.paint(context.canvas, sentAtOffset);
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);

    config.isSemanticBoundary = true;
    config.label = '$_sender: $_text, sent at $_sentAt';
    config.textDirection = _textDirection;
  }
}
