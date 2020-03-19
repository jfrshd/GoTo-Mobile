import 'dart:convert';

class Account {
  final int accountID;
  final String authToken;
  final bool isFirstLaunch;
  final bool authenticating;
  final bool firebasing;

  const Account({
    this.accountID = -1,
    this.authToken = '',
    this.isFirstLaunch,
    this.authenticating = false,
    this.firebasing = false,
  });

  Account copyWith(
      {accountID, authToken, isFirstLaunch, authenticating, firebasing}) {
    return Account(
      accountID: accountID ?? this.accountID,
      authToken: authToken ?? this.authToken,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      authenticating: authenticating ?? this.authenticating,
      firebasing: firebasing ?? this.firebasing,
    );
  }

  dynamic toJson() => {
        'accountID': accountID,
        'authToken':
            authToken.length > 0 ? authToken.substring(0, 50) + "..." : '',
        'isFirstLaunch': isFirstLaunch,
        'authenticating': authenticating,
        'firebasing': firebasing,
      };

  @override
  String toString() {
    return 'Account: ${JsonEncoder.withIndent('  ').convert(this)}';
  }
}
