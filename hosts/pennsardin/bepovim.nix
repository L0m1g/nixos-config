# modules/alerts/sms.nix

{ config, pkgs, lib, ... }:

{
#  services.xserver.enable = true;

  services.xserver.xkb.extraLayouts.bepovim = {
    description = "Clavier Bepovim – 4 niveaux";
    languages = [ "fr" ];
    # IMPORTANT: c'est `symbolsFile`, pas `symbols`.
    symbolsFile = builtins.toFile "bepovim.xkb" ''
      xkb_symbols "basic" {
        name[Group1] = "Bepovim";

        key <ESC>  { [ Escape ] };
        key <AE01> { [ dollar, numbersign ] };
        key <AE02> { [ less, 1, guillemotleft ] };
        key <AE03> { [ greater, 2, guillemotright ] };
        key <AE04> { [ parenleft, 3, bracketleft ] };
        key <AE05> { [ parenright, 4, bracketright ] };
        key <AE06> { [ at, 5, braceleft ] };
        key <AE07> { [ plus, 6, braceright ] };
        key <AE08> { [ minus, 7, asciitilde ] };
        key <AE09> { [ asterisk, 8 ] };
        key <AE10> { [ slash, 9, backslash ] };
        key <AE11> { [ quotedbl, 0 ] };
        key <AE12> { [ equal, ampersand ] };
        key <BKSP> { [ BackSpace ] };
        key <TAB>  { [ Tab, ISO_Left_Tab ] };

        key <AD01> { [ b, B ] };
        key <AD02> { [ eacute, Eacute ] };
        key <AD03> { [ p, P ] };
        key <AD04> { [ o, O ] };
        key <AD05> { [ r, R ] };
        key <AD06> { [ dead_circumflex, grave ] };
        key <AD07> { [ v, V ] };
        key <AD08> { [ s, S ] };
        key <AD09> { [ t, T ] };
        key <AD10> { [ d, D ] };
        key <AD11> { [ egrave, Egrave ] };
        key <AD12> { [ ccedilla, Ccedilla ] };

        key <RTRN> { [ Return ] };
        key <AC01> { [ c, C ] };
        key <AC02> { [ a, A ] };
        key <AC03> { [ u, U ] };
        key <AC04> { [ i, I ] };
        key <AC05> { [ e, E, EuroSign ] };
        key <AC06> { [ period, question ] };
        key <AC07> { [ n, N ] };
        key <AC08> { [ h, H, Left ] };
        key <AC09> { [ j, J, Down ] };
        key <AC10> { [ k, K, Up ] };
        key <AC11> { [ l, L, Right ] };
        key <AC12> { [ m, M ] };

        key <LFSH> { [ Shift_L ] };
        key <LSGT> { [ q, Q ] };
        key <AB01> { [ w, W ] };
        key <AB02> { [ agrave, Agrave ] };
        key <AB03> { [ f, F ] };
        key <AB04> { [ colon, bar ] };
        key <AB05> { [ comma, semicolon ] };
        key <AB06> { [ apostrophe, exclam ] };
        key <AB07> { [ x, X ] };
        key <AB08> { [ g, G ] };
        key <AB09> { [ z, Z ] };
        key <AB10> { [ y, Y ] };

        key <DELE>    { [ Up ] };
        key <DOWN>  { [ Left ] };
        key <RGHT>  { [ Down ] };
        key <INS>  { [ Right ] };

        key <LCTL>  { [ Control_L ] };
        key <LALT>  { [ Alt_L ] };
        key <SPCE>  { [ space, underscore, nobreakspace, U202F ] };
        key <RALT>  { [ ISO_Level3_Shift ] };

	key <FK02>  { [ F1, F1 ] };
	key <FK03>  { [ F2, F2 ] };
	key <FK04>  { [ F3, F3 ] };
	key <FK05>  { [ F4, F4 ] };
	key <FK06>  { [ F5, F5 ] };
	key <FK07>  { [ F6, F6 ] };
	key <FK08>  { [ F7, F7 ] };
	key <FK09>  { [ F8, F8 ]};
	key <FK10>  { [ F9, F9 ] };
	key <FK11>  { [ F10, F10 ] };
	key <FK12>  { [ F11, F11 ] };
      };
    '';
  };

  services.xserver.xkb.layout = "bepovim";
  services.xserver.xkb.variant = "basic";
  services.xserver.xkb.options = "lv3:ralt_switch";
  console.useXkbConfig = true;
}

