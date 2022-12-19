{ pkgs, ... }:

{
  languages.ruby = {
    enable = true;
    package = pkgs.ruby_2_7;
  };
}
