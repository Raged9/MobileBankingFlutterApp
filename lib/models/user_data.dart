// lib/models/user_data.dart

class UserData {
  final String name;
  final String email;
  final String cardNumber;
  final double balance;
  final String phoneNumber;
  final String address;
  final String accountNumber;
  final String pin;

  UserData({
    required this.name,
    required this.email,
    required this.cardNumber,
    required this.balance,
    required this.phoneNumber,
    required this.address,
    required this.accountNumber,
    required this.pin,
  });

  // Method untuk membuat salinan objek dengan nilai yang diperbarui
  UserData copyWith({
    String? name,
    String? email,
    String? cardNumber,
    double? balance,
    String? phoneNumber,
    String? address,
    String? accountNumber,
    String? pin,
  }) {
    return UserData(
      name: name ?? this.name,
      email: email ?? this.email,
      cardNumber: cardNumber ?? this.cardNumber,
      balance: balance ?? this.balance,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      accountNumber: accountNumber ?? this.accountNumber,
      pin: pin ?? this.pin,
    );
  }
}