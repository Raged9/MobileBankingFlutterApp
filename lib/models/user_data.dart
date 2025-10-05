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

var userData = UserData(
  name: '',
  email: '',
  cardNumber: '**** **** **** 1234',
  balance: 0,
  phoneNumber: '',
  address: '',
);