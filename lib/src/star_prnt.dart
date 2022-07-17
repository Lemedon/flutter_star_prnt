import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_star_prnt/src/enums.dart';
import 'package:flutter_star_prnt/src/portInfo.dart';
import 'package:flutter_star_prnt/src/print_commands.dart';
import 'package:flutter_star_prnt/src/utilities.dart';
import 'printer_response_status.dart';

/// Class to handle printer communication
class StarPrnt {
  static const MethodChannel _channel =
      const MethodChannel('flutter_star_prnt');

  StarPrnt._();

  static StarPrnt _instance = new StarPrnt._();

  static StarPrnt get instance => _instance;

  /// Scan for available printers. Have specify [StarPortType] of the printer
  Future<List<PortInfo>> portDiscovery(StarPortType portType) async {
    dynamic result =
        await _channel.invokeMethod('portDiscovery', {'type': portType.text});
    if (result is List) {
      return result.map<PortInfo>((port) {
        return PortInfo(port);
      }).toList();
    } else {
      return [];
    }
  }

  /// Check status of printer. Have specify [portName] and [emulation]. Returns [PrinterResponseStatus]. Use [StarMicronicsUtilities] to find suitable emulations.
  Future<PrinterResponseStatus> getStatus({
    required String portName,
    required String emulation,
  }) async {
    dynamic result = await _channel.invokeMethod('checkStatus', {
      'portName': portName,
      'emulation': emulation,
    });
    return PrinterResponseStatus.fromMap(
      Map<String, dynamic>.from(result),
    );
  }

  /// WORK IN PROGRESS
  /// Connects to the printer to achieve constant connection with printer. Have specify [portName] and [emulation].
  Future<PrinterResponseStatus> connect({
    required String portName,
    required String emulation,
  }) async {
    dynamic result = await _channel.invokeMethod('connect', {
      'portName': portName,
      'emulation': emulation,
    });
    return PrinterResponseStatus.fromMap(
      Map<String, dynamic>.from(result),
    );
  }

  /// WORK IN PROGRESS
  /// Disconnects with the printer. Have specify [portName] and [emulation].
  Future<PrinterResponseStatus> disconnect({
    required String portName,
    required String emulation,
  }) async {
    dynamic result = await _channel.invokeMethod('disconnect', {
      'portName': portName,
      'emulation': emulation,
    });
    return PrinterResponseStatus.fromMap(
      Map<String, dynamic>.from(result),
    );
  }

  /// Sends [PrintCommands] to the printer. Have to specify [portName] and [emulation]. Returns [PrinterResponseStatus]
  Future<PrinterResponseStatus> sendCommands({
    required String portName,
    required String emulation,
    required PrintCommands printCommands,
  }) async {
    dynamic result = await _channel.invokeMethod('print', {
      'portName': portName,
      'emulation': emulation,
      'printCommands': printCommands.getCommands(),
    });
    return PrinterResponseStatus.fromMap(
      Map<String, dynamic>.from(result),
    );
  }

  /// sends commands to printer to run
  @Deprecated('Use sendCommands instead.')
  Future<dynamic> print({
    required String portName,
    required String emulation,
    required PrintCommands printCommands,
  }) async {
    dynamic result = await _channel.invokeMethod('print', {
      'portName': portName,
      'emulation': emulation,
      'printCommands': printCommands.getCommands(),
    });
    return result;
  }

  /// Check status of printer
  @Deprecated('Use getStatus instead.')
  Future<dynamic> checkStatus({
    required String portName,
    required String emulation,
  }) async {
    dynamic result = await _channel.invokeMethod('checkStatus', {
      'portName': portName,
      'emulation': emulation,
    });
    return result;
  }
}
