import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/values_object/failure.dart';

part 'async_state.freezed.dart';

@freezed
class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.initial() = _Initial;
  const factory AsyncState.loading() = _Loading;
  const factory AsyncState.data(T data) = _Data;
  const factory AsyncState.error(Failure failure) = _Error;
}
