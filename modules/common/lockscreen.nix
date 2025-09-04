_: {
  environment.etc."pam.d/i3lock".text = ''
    auth     include login
    account  include login
    password include login
    session  include login
  '';
}
