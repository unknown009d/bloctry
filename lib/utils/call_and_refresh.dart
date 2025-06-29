import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phone_state/phone_state.dart';
import 'dart:async';

Future<void> callAndRefresh({
  required String number,
  required Future<void> Function() onCallEnded,
}) async {
  await FlutterPhoneDirectCaller.callNumber(number);

  StreamSubscription<PhoneState>? sub;
  sub = PhoneState.stream.listen((PhoneState state) async {
    if (state.status == PhoneStateStatus.CALL_ENDED) {
      await Future.delayed(Duration(seconds: 2)); // Ensure log is saved
      await onCallEnded();
      sub?.cancel();
    }
  });
}
