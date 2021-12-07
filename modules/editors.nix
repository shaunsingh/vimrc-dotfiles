# Editors.nix
# My editor configurations have grown out of control, so lets tame them a bit.

# [[file:../nix-config.org::*Editors.nix][Editors.nix:1]]
{ pkgs, lib, home-manager, ... }:
# Editors.nix:1 ends here

# Doom-emacs
# Nix via doom-emacs is very, /very/ annoying. Initially I was using [[https://github.com/vlaci/nix-doom-emacs][Nix-doom-emacs]]. However, this has a few drawbacks
# 1. It doesn't support straight =:recipe=, so all packages must be from melpa or elpa
# 2. It pins the version of doom, so you need to update doom and its dependencies painstakingly manually
# 3. It just ends up breaking anyways.

# A simpler solution is just to have nix clone =doom-emacs= to =~/.config/emacs=, and the user can handle doom manually

# [[file:../nix-config.org::*Doom-emacs][Doom-emacs:1]]
let
  emacsSyncScript = pkgs.writeScriptBin "doom-sync-git" ''
    #!${pkgs.runtimeShell}
    export PATH=$PATH:${lib.makeBinPath [ pkgs.git pkgs.sqlite pkgs.unzip ]}
    if [ ! -d $HOME/.config/emacs/.git ]; then
      mkdir -p $HOME/.config/emacs
      git -C $HOME/.config/emacs init
    fi
    if [ $(git -C $HOME/.config/emacs rev-parse HEAD) != ${pkgs.doomEmacsRevision} ]; then
      git -C $HOME/.config/emacs fetch https://github.com/hlissner/doom-emacs.git || true
      git -C $HOME/.config/emacs checkout ${pkgs.doomEmacsRevision} || true
    fi
  '';
in
{
  home-manager.users.shauryasingh.home.packages = with pkgs; [
    ((emacsPackagesNgGen emacsGcc).emacsWithPackages
      (epkgs: [ epkgs.vterm ]))
    (ripgrep.override { withPCRE2 = true; })
    fd
    sqlite
    gnuplot
    # pandoc
    # sdcv
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    (texlive.combine {
      inherit (texlive)
        scheme-small dvipng dvisvgm l3packages xcolor soul adjustbox
        collectbox amsmath siunitx cancel mathalpha capt-of chemfig
        wrapfig mhchem fvextra cleveref latexmk tcolorbox environ arev
        amsfonts simplekv alegreya sourcecodepro newpx svg catchfile
        transparent hanging biblatex biblatex-mla;
    })
    emacsSyncScript
    languagetool
    # neovim deps
    neovim-nightly
    tree-sitter
    # neovide-git
    nodejs
    tree-sitter
  ];
  system.activationScripts.postUserActivation.text = ''
    $HOME/.config/emacs/bin/doom sync || true
    YES=1 FORCE=1 $HOME/.config/emacs/bin/doom sync -u &
  '';
# Doom-emacs:1 ends here

# Neovim
# Lastly, I didn't feel like nix-ifying my neovim lua config. Lets cheat a bit and just symlink it instead

# [[file:../nix-config.org::*Neovim][Neovim:1]]
home-manager.users.shauryasingh.xdg.configFile."nvim/init.lua".source = ../configs/nyoom.nvim/init.lua;  
  # fzf-native
  home-manager.users.shauryasingh.xdg.dataFile."nvim/site/pack/packer/start/telescope-fzf-native.nvim/build/libfzf.so".source = "${pkgs.telescope-fzf-native}/build/libfzf.so";
  # tree-sitter parsers
  home-manager.users.shauryasingh.xdg.configFile."nvim/parser/lua.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  home-manager.users.shauryasingh.xdg.configFile."nvim/parser/nix.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
}
# Neovim:1 ends here