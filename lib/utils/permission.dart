import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPhonePermissions() async {
  final statuses = await [
    Permission.contacts,
    Permission.phone,
  ].request();

  return statuses.values.every((status) => status.isGranted);
}

Future<void> openSettingsIfPermanentlyDenied() async {
  if (await Permission.contacts.isPermanentlyDenied ||
      await Permission.phone.isPermanentlyDenied) {
    await openAppSettings();
  }
}

Future<bool> requestCallLogPermission() async {
  const platform = MethodChannel('com.bloctry/permissions');
  try {
    final granted = await platform.invokeMethod<bool>(
      'requestCallLogPermission',
    );
    return granted ?? false;
  } catch (e) {
    if (kDebugMode) print('Failed to request call log permission: $e');
    return false;
  }
}
