part of '../bytebank_balance.dart';

class ByteBankBalance extends StatefulWidget {
  const ByteBankBalance({super.key, required this.color, required this.userId});
  final Color color;
  final String userId;

  @override
  State<ByteBankBalance> createState() => _ByteBankBalanceState();
}

class _ByteBankBalanceState extends State<ByteBankBalance> {
  bool isShowingBalance = false;
  double userBalance = 0;
  BalanceService balanceService = BalanceService();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Saldo",
              style: TextStyle(
                fontSize: 20,
                color: widget.color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            IconButton(
              onPressed: () {
                onVisibilityBalanceClicked();
              },
              icon: Icon(
                isShowingBalance ? Icons.visibility : Icons.visibility_off,
                color: widget.color,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(color: widget.color, thickness: 2),
        ),
        Text(
          "Conta Corrente",
          style: TextStyle(
            color: widget.color,
            fontSize: 16,
          ),
        ),
        Text(
          isShowingBalance
              ? 'R\$ ${userBalance.toStringAsFixed(2)}'
              : 'R\$ ⚪⚪⚪⚪',
          style: TextStyle(
            color: widget.color,
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  onVisibilityBalanceClicked() {
    if (isShowingBalance) {
      setState(() {
        isShowingBalance = false;
      });
    } else {
      balanceService.hasPin(userId: widget.userId).then((bool hasPin) {
        if (hasPin) {
          showPinDialog(context, isRegister: false).then((String? pin) {
            if (pin != null && pin.length == 4) {
              balanceService
                  .getBalance(userId: widget.userId, pin: pin)
                  .then((double? balance) {
                setState(() {
                  if (balance != null) {
                    isShowingBalance = true;
                    userBalance = balance;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("PIN inválido")));
                  }
                });
              });
            }
          });
        } else {
          showPinDialog(context, isRegister: true).then((String? pin) {
            if (pin != null && pin.length == 4) {
              balanceService
                  .createPin(userId: widget.userId, pin: pin)
                  .then((double? balance) {
                if (balance != null) {
                  setState(() {
                    isShowingBalance = true;
                    userBalance = balance;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("PIN inválido")));
                }
              });
            }
          });
        }
      });
    }
  }
}
