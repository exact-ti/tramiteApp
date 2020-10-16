import 'package:tramiteapp/src/Providers/password/IPasswordProvider.dart';
import 'IPasswordCore.dart';

class PasswordCore implements IPasswordCore {

  IPasswordProvider passwordProvider;

  PasswordCore(IPasswordProvider passwordProvider) {
    this.passwordProvider = passwordProvider;
  }

  @override
  Future submitEmail(String email) async  {
    dynamic resp = await passwordProvider.submitEmail(email);
    return resp;
  }

  @override
  Future changePassword(String passActual, String passNew) async {
    dynamic resp = await passwordProvider.changePassword(passActual, passNew);
    return resp;
  }
}
