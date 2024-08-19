String cutDoubleString(String s){
  int length = s.length;
  bool cicle = true;

  while (cicle) {
    if(s.endsWith('0')){
      s = s.substring(0, length-1);
    }else if(s.endsWith('.')){
      s = s.substring(0, length-1);
      cicle = false;
    }else{
      cicle = false;
    }
  }

  return s;
}