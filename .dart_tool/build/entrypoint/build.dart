// ignore_for_file: directives_ordering
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:dart_web3/src/builder/builders.dart' as _i2;
import 'package:build/build.dart' as _i3;
import 'dart:isolate' as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(r'dart_web3:abi_generator', [_i2.abiGenerator],
      _i1.toDependentsOf(r'dart_web3'),
      hideOutput: false,
      appliesBuilders: const [r'dart_web3:delete_abi_source']),
  _i1.applyPostProcess(r'dart_web3:delete_abi_source', _i2.deleteSource,
      defaultReleaseOptions: const _i3.BuilderOptions({r'enabled': true}))
];
void main(List<String> args, [_i4.SendPort? sendPort]) async {
  var result = await _i5.run(args, _builders);
  sendPort?.send(result);
  _i6.exitCode = result;
}
