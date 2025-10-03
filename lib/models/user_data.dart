class UserData {
  final String name;
  final String email;
  final String cardNumber;
  final double balance;
  final String phoneNumber;
  final String address;

  UserData({
    required this.name,
    required this.email,
    required this.cardNumber,
    required this.balance,
    required this.phoneNumber,
    required this.address,
  });
}

final userData = UserData(
  name: '',
  email: 'ronald.suchanto@email.com',
  cardNumber: '**** **** **** 1234',
  balance: 0,
  phoneNumber: '+62 812 3456 7890',
  address: 'Jakarta, Indonesia',
);