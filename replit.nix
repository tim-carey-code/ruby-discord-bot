{ pkgs }: {
  deps = [
    pkgs.wget
    pkgs.sudo
    pkgs.ruby_3_1
    pkgs.rubyPackages_3_1.solargraph
  ];
}