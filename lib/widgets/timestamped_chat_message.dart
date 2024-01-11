/// A chat message with a timestamp.
///
/// {@category WIDGETS}
library widgets.timestamped_chat_message;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// A widget that represents a chat message with a timestamp.
///
/// This widget is a [LeafRenderObjectWidget] that takes the sender, the time the message was sent,
/// the text of the message, and the brightness as input.
///
/// The [sender], [sentAt], and [text] parameters are required.
/// The [brightness] parameter is optional and defaults to [Brightness.light].
class TimestampedChatMessage extends LeafRenderObjectWidget {

  /// The const constructor of the [TimestampedChatMessage] widget.
  const TimestampedChatMessage({
    super.key,
    required this.sender,
    required this.sentAt,
    required this.text,
    this.brightness = Brightness.light,
  });

  /// The sender of the message.
  final String sender;

  /// The time the message was sent.
  final String sentAt;

  /// The text of the message.
  final String text;

  /// The brightness of the message.
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


/// A class that represents the render object for a [TimestampedChatMessage].
///
/// This class is a [RenderBox] that takes the sender, the time the message was sent,
/// the text of the message, the text direction, and the brightness as input.
///
/// The [sender], [sentAt], [text], [textDirection], and [brightness] parameters are required.
class TimestampedChatMessageRenderObject extends RenderBox {

  /// Creates a new instance of [TimestampedChatMessageRenderObject].
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

  /// A getter of the sender of the message.
  String get sender => _sender;

  /// A setter of the sender of the message.
  set sender(String value) {
    if (value == _sender) return;
    _sender = value;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// A getter of the text of the message.
  String get text => _text;

  /// A setter of the text of the message.
  set text(String value) {
    if (value == _text) return;
    _text = value;
    _textPainter.text = textTextSpan;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// A getter of the time the message was sent.
  String get sentAt => _sentAt;

  /// A setter of the time the message was sent.
  set sentAt(String value) {
    if (value == _sentAt) return;
    _sentAt = value;
    _sentAtTextPainter.text = sentAtTextSpan;
    markNeedsLayout();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  /// A getter of the brightness of the message.
  Brightness get brightness => _brightness;

  /// A setter of the brightness of the message.
  set brightness(Brightness value) {
    if (value == _brightness) return;
    _brightness = value;
    markNeedsLayout();
    markNeedsSemanticsUpdate();
    markNeedsPaint();
  }

  /// A getter of the text direction of the message.
  TextDirection get textDirection => _textDirection;

  /// A setter of the text direction of the message.
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    _textPainter.textDirection = value;
    _sentAtTextPainter.textDirection = value;
  }

  /// A getter of the text span of the message.
  TextSpan get textTextSpan => TextSpan(
      text: _text,
      style: TextStyle(
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ));

  /// A getter of the text span of the time the message was sent.
  TextSpan get sentAtTextSpan =>
      TextSpan(text: _sentAt, style: const TextStyle(color: Colors.grey));

  /// A getter of the text span of the sender of the message.
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

    final double senderHeight = _sender.isEmpty ? 0 : _senderTextPainter.height;
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

    final double senderHeight = _sender.isEmpty ? 0 : _senderTextPainter.height;

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
