import 'package:tramiteapp/src/Providers/password/IPasswordProvider.dart';
import 'IPasswordCore.dart';

class PasswordCore implements IPasswordCore {

  IPasswordProvider passwordProvider;

  PasswordCore(IPasswordProvider passwordProvider) {
    this.passwordProvider = passwordProvider;
  }

  @override
  Future submitEmail(String email) async  {
    return await passwordProvider.submitEmail(email);
  }

  @override
  Future changePassword(String passActual, String passNew) async {
    return await passwordProvider.changePassword(passActual, passNew);
  }
}
