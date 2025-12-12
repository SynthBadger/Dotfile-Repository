{ config, lib, pkgs, ... }:

let
  stdenvNoCC = pkgs.stdenvNoCC;
  fetchurl = pkgs.fetchurl;
  # add other necessary packages directly from pkgs
in
stdenvNoCC.mkDerivation {
  pname = "cups-brother-dcpl355cdw";
  version = "1.0.2";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103919/dcpl3550cdwpdrv-${version}-0.i386.deb";
    sha256 = "sha256-FbtqISK3f1q1+JXJ+RP5O/8G0ZW9gcCS7OI0YRljwyY=";
  };

  nativeBuildInputs = [
    pkgs.dpkg
    pkgs.makeWrapper
    pkgs.autoPatchelfHook
  ];

  buildInputs = [
    pkgs.perl
    pkgs.gnused
    pkgs.libredirect
    pkgs.pkgsi686Linux.stdenv.cc.cc.lib
  ];

  installPhase = ''
    # Your install phase commands here
  '';

  # Any additional phases or configurations
  meta = {
    description = "Brother DCP-L3550CDW printer driver";
    license = with lib.licenses; [ lib.licenses.unfree lib.licenses.gpl2Plus ];
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ "bwolf" ];
    homepage = "https://www.brother.com/";
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=de&lang=de&prod=dcpl3550cdw_eu&os=128&flang=English";
  };
}
