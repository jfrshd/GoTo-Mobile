import 'dart:convert';

class Account {
  final int accountID;
  final String authToken;
  final bool authenticating;

  const Account(
      {this.accountID = -1, this.authToken = '', this.authenticating = false});

  Account copyWith({accountID, authToken, authenticating}) {
    return Account(
      accountID: accountID ?? this.accountID,
      authToken: authToken ?? this.authToken,
      authenticating: authenticating ?? this.authenticating,
    );
  }

  dynamic toJson() => {
        'accountID': accountID,
        'authToken':
            authToken.length > 0 ? authToken.substring(0, 50) + "..." : '',
        'authenticating': authenticating,
      };

  @override
  String toString() {
    return 'Account: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
