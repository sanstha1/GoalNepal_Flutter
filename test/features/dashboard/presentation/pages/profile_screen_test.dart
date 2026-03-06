import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity - Constructor', () {
    test('should create instance with required fields only', () {
      final entity = AuthEntity(
        fullName: 'Test User',
        email: 'test@example.com',
      );
      expect(entity.fullName, equals('Test User'));
      expect(entity.email, equals('test@example.com'));
      expect(entity.authId, isNull);
      expect(entity.password, isNull);
      expect(entity.profilePicture, isNull);
    });

    test('should create instance with all fields', () {
      final entity = AuthEntity(
        authId: 'auth_123',
        fullName: 'John Doe',
        email: 'john@example.com',
        password: 'secure123',
        profilePicture: 'https://example.com/image.jpg',
      );
      expect(entity.authId, equals('auth_123'));
      expect(entity.fullName, equals('John Doe'));
      expect(entity.email, equals('john@example.com'));
      expect(entity.password, equals('secure123'));
      expect(entity.profilePicture, equals('https://example.com/image.jpg'));
    });

    test('should handle empty string for fullName', () {
      final entity = AuthEntity(fullName: '', email: 'test@example.com');
      expect(entity.fullName, equals(''));
    });

    test('should handle empty string for email', () {
      final entity = AuthEntity(fullName: 'Test User', email: '');
      expect(entity.email, equals(''));
    });
  });

  group('AuthEntity - copyWith', () {
    test('should return same values when no parameters provided', () {
      final original = AuthEntity(
        authId: 'auth_1',
        fullName: 'Original Name',
        email: 'original@test.com',
        password: 'pass123',
        profilePicture: 'img.jpg',
      );
      final copied = original.copyWith();
      expect(copied.authId, equals(original.authId));
      expect(copied.fullName, equals(original.fullName));
      expect(copied.email, equals(original.email));
      expect(copied.password, equals(original.password));
      expect(copied.profilePicture, equals(original.profilePicture));
    });

    test('should update authId when provided', () {
      final original = AuthEntity(
        authId: 'auth_1',
        fullName: 'Test',
        email: 'test@test.com',
      );
      final copied = original.copyWith(authId: 'auth_2');
      expect(copied.authId, equals('auth_2'));
      expect(original.authId, equals('auth_1'));
    });

    test('should update fullName when provided', () {
      final original = AuthEntity(fullName: 'Old Name', email: 'test@test.com');
      final copied = original.copyWith(fullName: 'New Name');
      expect(copied.fullName, equals('New Name'));
      expect(original.fullName, equals('Old Name'));
    });

    test('should update email when provided', () {
      final original = AuthEntity(fullName: 'Test', email: 'old@test.com');
      final copied = original.copyWith(email: 'new@test.com');
      expect(copied.email, equals('new@test.com'));
      expect(original.email, equals('old@test.com'));
    });

    test('should update password when provided', () {
      final original = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        password: 'oldPass',
      );
      final copied = original.copyWith(password: 'newPass');
      expect(copied.password, equals('newPass'));
      expect(original.password, equals('oldPass'));
    });

    test('should update profilePicture when provided', () {
      final original = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        profilePicture: 'old.jpg',
      );
      final copied = original.copyWith(profilePicture: 'new.jpg');
      expect(copied.profilePicture, equals('new.jpg'));
      expect(original.profilePicture, equals('old.jpg'));
    });

    test('should update multiple fields at once', () {
      final original = AuthEntity(
        authId: 'auth_1',
        fullName: 'Old Name',
        email: 'old@test.com',
      );
      final copied = original.copyWith(
        fullName: 'New Name',
        email: 'new@test.com',
        profilePicture: 'pic.jpg',
      );
      expect(copied.authId, equals('auth_1'));
      expect(copied.fullName, equals('New Name'));
      expect(copied.email, equals('new@test.com'));
      expect(copied.profilePicture, equals('pic.jpg'));
    });

    test('should maintain immutability of original instance', () {
      final original = AuthEntity(
        fullName: 'Original',
        email: 'original@test.com',
      );
      final copied = original.copyWith(fullName: 'Modified');
      expect(original.fullName, equals('Original'));
      expect(copied.fullName, equals('Modified'));
    });
  });

  group('AuthEntity - Equatable props', () {
    test('should return props list with all five fields', () {
      final entity = AuthEntity(
        authId: 'auth_1',
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'pass123',
        profilePicture: 'img.jpg',
      );
      expect(entity.props.length, equals(5));
      expect(entity.props[0], equals('auth_1'));
      expect(entity.props[1], equals('Test User'));
      expect(entity.props[2], equals('test@example.com'));
      expect(entity.props[3], equals('pass123'));
      expect(entity.props[4], equals('img.jpg'));
    });

    test('should be equal when all props match', () {
      final entity1 = AuthEntity(
        authId: 'auth_123',
        fullName: 'John Doe',
        email: 'john@test.com',
        password: 'secret',
        profilePicture: 'pic.png',
      );
      final entity2 = AuthEntity(
        authId: 'auth_123',
        fullName: 'John Doe',
        email: 'john@test.com',
        password: 'secret',
        profilePicture: 'pic.png',
      );
      expect(entity1, equals(entity2));
    });

    test('should not be equal when authId differs', () {
      final entity1 = AuthEntity(
        authId: 'auth_1',
        fullName: 'Test',
        email: 'test@test.com',
      );
      final entity2 = AuthEntity(
        authId: 'auth_2',
        fullName: 'Test',
        email: 'test@test.com',
      );
      expect(entity1, isNot(equals(entity2)));
    });

    test('should not be equal when fullName differs', () {
      final entity1 = AuthEntity(fullName: 'User One', email: 'test@test.com');
      final entity2 = AuthEntity(fullName: 'User Two', email: 'test@test.com');
      expect(entity1, isNot(equals(entity2)));
    });

    test('should not be equal when email differs', () {
      final entity1 = AuthEntity(fullName: 'Test', email: 'one@test.com');
      final entity2 = AuthEntity(fullName: 'Test', email: 'two@test.com');
      expect(entity1, isNot(equals(entity2)));
    });

    test('should not be equal when password differs', () {
      final entity1 = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        password: 'pass1',
      );
      final entity2 = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        password: 'pass2',
      );
      expect(entity1, isNot(equals(entity2)));
    });

    test('should not be equal when profilePicture differs', () {
      final entity1 = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        profilePicture: 'img1.jpg',
      );
      final entity2 = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        profilePicture: 'img2.jpg',
      );
      expect(entity1, isNot(equals(entity2)));
    });

    test('should have same hashCode when equal', () {
      final entity1 = AuthEntity(
        authId: 'auth_1',
        fullName: 'Test',
        email: 'test@test.com',
      );
      final entity2 = AuthEntity(
        authId: 'auth_1',
        fullName: 'Test',
        email: 'test@test.com',
      );
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('should handle null values in equality check', () {
      final entity1 = AuthEntity(fullName: 'Test', email: 'test@test.com');
      final entity2 = AuthEntity(fullName: 'Test', email: 'test@test.com');
      expect(entity1, equals(entity2));
    });
  });

  group('AuthEntity - Edge Cases', () {
    test('should handle very long fullName', () {
      final longName = 'A' * 1000;
      final entity = AuthEntity(fullName: longName, email: 'test@test.com');
      expect(entity.fullName.length, equals(1000));
    });

    test('should handle special characters in email', () {
      final entity = AuthEntity(
        fullName: 'Test',
        email: 'test+tag@sub.domain.com',
      );
      expect(entity.email, equals('test+tag@sub.domain.com'));
    });

    test('should handle null authId in equality', () {
      final entity1 = AuthEntity(fullName: 'Test', email: 'test@test.com');
      final entity2 = AuthEntity(
        authId: null,
        fullName: 'Test',
        email: 'test@test.com',
      );
      expect(entity1, equals(entity2));
    });

    test('should handle empty string vs null for optional fields', () {
      final entity1 = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        password: '',
      );
      final entity2 = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        password: null,
      );
      expect(entity1, isNot(equals(entity2)));
    });

    test('should preserve case sensitivity in comparisons', () {
      final entity1 = AuthEntity(fullName: 'Test User', email: 'test@test.com');
      final entity2 = AuthEntity(fullName: 'test user', email: 'test@test.com');
      expect(entity1, isNot(equals(entity2)));
    });
  });

  group('AuthEntity - toString', () {
    test('should include class name in string representation', () {
      final entity = AuthEntity(fullName: 'Test', email: 'test@test.com');
      expect(entity.toString(), contains('AuthEntity'));
    });

    test('should include required fields in string representation', () {
      final entity = AuthEntity(fullName: 'John Doe', email: 'john@test.com');
      final str = entity.toString();
      expect(str, contains('John Doe'));
      expect(str, contains('john@test.com'));
    });
  });

  group('AuthEntity - Factory Patterns', () {
    test('should create guest user entity', () {
      final guest = AuthEntity(
        fullName: 'Guest User',
        email: 'guest@temporary.com',
      );
      expect(guest.fullName, equals('Guest User'));
      expect(guest.authId, isNull);
    });

    test('should create authenticated user with minimal data', () {
      final user = AuthEntity(
        authId: 'user_999',
        fullName: 'Authenticated',
        email: 'auth@verified.com',
      );
      expect(user.authId, equals('user_999'));
      expect(user.profilePicture, isNull);
    });

    test('should create user with profile picture URL', () {
      final user = AuthEntity(
        fullName: 'With Photo',
        email: 'photo@test.com',
        profilePicture: 'https://cdn.example.com/users/123.jpg',
      );
      expect(user.profilePicture, contains('https://'));
      expect(user.profilePicture, contains('.jpg'));
    });
  });

  group('AuthEntity - CopyWith Chains', () {
    test('should support chained copyWith calls', () {
      final base = AuthEntity(fullName: 'Base', email: 'base@test.com');
      final step1 = base.copyWith(authId: 'auth_1');
      final step2 = step1.copyWith(profilePicture: 'pic.jpg');
      final step3 = step2.copyWith(password: 'newPass');

      expect(step3.authId, equals('auth_1'));
      expect(step3.profilePicture, equals('pic.jpg'));
      expect(step3.password, equals('newPass'));
      expect(step3.fullName, equals('Base'));
      expect(step3.email, equals('base@test.com'));
    });

    test('should not affect original after chained copies', () {
      final original = AuthEntity(fullName: 'Original', email: 'orig@test.com');
      final modified = original
          .copyWith(fullName: 'Modified')
          .copyWith(email: 'mod@test.com');

      expect(original.fullName, equals('Original'));
      expect(original.email, equals('orig@test.com'));
      expect(modified.fullName, equals('Modified'));
      expect(modified.email, equals('mod@test.com'));
    });
  });
}
