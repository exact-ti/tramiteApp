abstract class IPasswordProvider {
  
  Future<dynamic> submitEmail(String email);

  Future<dynamic> changePassword(String passActual, String passNew);
}
