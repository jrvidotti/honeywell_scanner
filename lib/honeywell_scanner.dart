import 'dart:async';
import 'package:flutter/services.dart';

export 'package:honeywell_scanner/code_format.dart';

class HoneywellScanner {
  HoneywellScanner({
    void Function(String result)? onDecodedCallback,
    void Function(Exception error)? onErrorCallback,
  }) {
    _channel = const MethodChannel(_METHOD_CHANNEL);
    _channel.setMethodCallHandler(_onMethodCall);
    _onDecodedCallback = onDecodedCallback;
    _onErrorCallback = onErrorCallback;
  }

  static const _METHOD_CHANNEL = 'honeywellscanner';
  static const _SET_PROPERTIES = 'setProperties';
  static const _START_SCANNER = 'startScanner';
  static const _RESUME_SCANNER = 'resumeScanner';
  static const _PAUSE_SCANNER = 'pauseScanner';
  static const _STOP_SCANNER = 'stopScanner';
  static const _ON_DECODED = 'onDecoded';
  static const _ON_ERROR = 'onError';

  late MethodChannel _channel;
  // ScannerCallBack _scannerCallBack;

  /// Called when decoder has successfully decoded the code
  /// <br>
  /// @param result Encapsulates the result of decoding a barcode within an image
  void Function(String result)? _onDecodedCallback;

  /// Called when error has occurred
  /// <br>
  /// @param error Exception that has been thrown
  void Function(Exception error)? _onErrorCallback;

  set onDecodedCallback(void Function(String result) onDecodedCallback) =>
      _onDecodedCallback = onDecodedCallback;

  setOnDecodedCallback(void Function(String result) onDecodedCallback) =>
      _onDecodedCallback = onDecodedCallback;

  set onErrorCallback(void Function(Exception error) onErrorCallback) =>
      _onErrorCallback = onErrorCallback;

  setOnErrorCallback(void Function(Exception error) onErrorCallback) =>
      _onErrorCallback = onErrorCallback;

  Future<dynamic> _onMethodCall(MethodCall call) {
    try {
      switch (call.method) {
        case _ON_DECODED:
          onDecoded(call.arguments as String);
          break;
        case _ON_ERROR:
          onError(Exception(call.arguments));
          break;
        default:
          print(call.arguments);
      }
    } catch (e) {
      print(e);
    }
    return Future.value();
  }

  ///Called when decoder has successfully decoded the code
  ///<br>
  ///Note that this method always called on a worker thread
  ///
  ///@param code Encapsulates the result of decoding a barcode within an image
  void onDecoded(String code) {
    if (_onDecodedCallback != null) _onDecodedCallback!(code);
  }

  ///Called when error has occurred
  ///<br>
  ///Note that this method always called on a worker thread
  ///
  ///@param error Exception that has been thrown
  void onError(Exception error) {
    if (_onErrorCallback != null) _onErrorCallback!(error);
  }

  Future setProperties(Map<String, dynamic> mapProperties) {
    return _channel.invokeMethod(_SET_PROPERTIES, mapProperties);
  }

  Future startScanner() {
    return _channel.invokeMethod(_START_SCANNER);
  }

  Future resumeScanner() {
    return _channel.invokeMethod(_RESUME_SCANNER);
  }

  Future pauseScanner() {
    return _channel.invokeMethod(_PAUSE_SCANNER);
  }

  Future stopScanner() {
    return _channel.invokeMethod(_STOP_SCANNER);
  }
}
