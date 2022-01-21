

 String? emailValidator(String text){
   bool validEmail = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(text);
   if (validEmail) {
     return null;
   } else {
     return "Enter a valid Email";
   }
}

String? passwordValidator(String text){
  bool validPassword = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?])[A-Za-z\d#$@!%&*?]{8,30}$').hasMatch(text);
  if (validPassword) {
    return null;
  } else {
    return "*Password must contain a uppercase character and a symbol.\n*Must be 8 characters long";
  }
}