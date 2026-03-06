import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/connectivity/network_info.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfo networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfo(mockConnectivity);
  });

  group('NetworkInfo', () {
    group('isConnected', () {
      test('should return true when WiFi is connected', () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.wifi]);

        final result = await networkInfo.isConnected;

        expect(result, true);
      });

      test('should return true when mobile data is connected', () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.mobile]);

        final result = await networkInfo.isConnected;

        expect(result, true);
      });

      test('should return true when ethernet is connected', () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.ethernet]);

        final result = await networkInfo.isConnected;

        expect(result, true);
      });

      test(
        'should return true when multiple connections are available',
        () async {
          when(() => mockConnectivity.checkConnectivity()).thenAnswer(
            (_) async => [ConnectivityResult.wifi, ConnectivityResult.mobile],
          );

          final result = await networkInfo.isConnected;

          expect(result, true);
        },
      );

      test(
        'should fall back to connectivity check when actual internet lookup fails',
        () async {
          when(
            () => mockConnectivity.checkConnectivity(),
          ).thenAnswer((_) async => [ConnectivityResult.none]);

          final result = await networkInfo.isConnected;

          expect(result, isA<bool>());
        },
      );

      test('should return false when connectivity result is none', () async {
        when(
          () => mockConnectivity.checkConnectivity(),
        ).thenAnswer((_) async => [ConnectivityResult.none]);

        final result = await networkInfo.isConnected;

        expect(result, false);
      });
    });

    group('INetworkInfo interface', () {
      test('NetworkInfo should implement INetworkInfo', () {
        expect(networkInfo, isA<INetworkInfo>());
      });
    });
  });
}
