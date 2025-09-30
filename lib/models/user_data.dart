class UserData {
  final String name;
  final String balance;
  final String cardNumber;

  UserData({
    required this.name,
    required this.balance,
    required this.cardNumber,
  });
}

final userData = UserData(
  name: 'Ronald Suchanto',
  balance: '27.230.000',
  cardNumber: '**** **** **** 1234',
);