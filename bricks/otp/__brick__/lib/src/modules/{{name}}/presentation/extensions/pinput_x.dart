import 'package:pinput/pinput.dart';

extension PinStateTypeX on PinItemStateType {
  R maybeWhen<R>({
    R Function()? focused,
    R Function()? submitted,
    R Function()? following,
    R Function()? disabled,
    R Function()? error,
    required R Function() orElse,
  }) {
    if (this == PinItemStateType.focused && focused != null) {
      return focused();
    } else if (this == PinItemStateType.submitted && submitted != null) {
      return submitted();
    } else if (this == PinItemStateType.following && following != null) {
      return following();
    } else if (this == PinItemStateType.disabled && disabled != null) {
      return disabled();
    } else if (this == PinItemStateType.error && error != null) {
      return error();
    } else {
      return orElse();
    }
  }
}
