{ config, pkgs, ... }:
{
    programs.zsh = {
    	enable = true ;
	enableCompletion = true ;
	history = {
	    append = true ;
	    extended = true ;
	    findNoDups = true ;
	    ignoreAllDups = true ;
	    ignoreSpace = true ;
	    ignorePatterns = [ "rm *" "cd *" "ls *" ] ;
	    saveNoDups = false ;
	};
    shellGlobalAliases = {
	G = "| grep";
	M = "| more";
    };
    };
}
