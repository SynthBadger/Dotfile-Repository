# NOTE: Similar to cups-brother-dcpt310

{
  stdenvNoCC,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  autoPatchelfHook,
  perl,
  gnused,
  libredirect,
  coreutils,
  gnugrep,
  ghostscript,
  file,
  pkgsi686Linux,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cups-brother-dcpl355cdw";
  version = "1.0.2";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103919/dcpl3550cdwpdrv-${finalAttrs.version}-0.i386.deb";
    sha256 = "sha256-FbtqISK3f1q1+JXJ+RP5O/8G0ZW9gcCS7OI0YRljwyY=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    perl
    gnused
    libredirect
    pkgsi686Linux.stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -pr opt $out
    cp -pr usr/bin $out/bin
    rm $out/opt/brother/Printers/dcpl3550cdw/cupswrapper/cupswrapperdcpl3550cdw

    mkdir -p $out/lib/cups/filter $out/share/cups/model

    ln -s ../../../opt/brother/Printers/dcpl3550cdw/cupswrapper/brother_lpdwrapper_dcpl3550cdw \
      $out/lib/cups/filter/brother_lpdwrapper_dcpl3550cdw

    ln -s ../../../opt/brother/Printers/dcpl3550cdw/cupswrapper/brother_dcpl3550cdw_printer_en.ppd \
      $out/share/cups/model/brother_dcpl3550cdw_printer_en.ppd

    runHook postInstall
  '';

  postFixup = ''
    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2

    substituteInPlace $out/opt/brother/Printers/dcpl3550cdw/lpd/filter_dcpl3550cdw \
      --replace-fail "my \$BR_PRT_PATH =" "my \$BR_PRT_PATH = \"$out/opt/brother/Printers/dcpl3550cdw/\"; #" \
      --replace-fail /usr/bin/pdf2ps "${ghostscript}/bin/pdf2ps" \
      --replace-fail "my \$GHOST_SCRIPT" "my \$GHOST_SCRIPT = \"${ghostscript}/bin/gs\"; #" \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpl3550cdw\"; #"

    substituteInPlace $out/opt/brother/Printers/dcpl3550cdw/cupswrapper/brother_lpdwrapper_dcpl3550cdw \
      --replace-fail "PRINTER =~" "PRINTER = \"dcpl3550cdw\"; #" \
      --replace-fail "my \$basedir = \`readlink \$0\`" "my \$basedir = \"$out/opt/brother/Printers/dcpl3550cdw/\"" \
      --replace-fail "my \$lpdconf = \$LPDCONFIGEXE.\$PRINTER;" "my \$lpdconf = \"$out/bin/brprintconf_dcpl3550cdw\";"

    patchelf --set-interpreter "$interpreter" "$out/opt/brother/Printers/dcpl3550cdw/lpd/brdcpl3550cdwfilter" \
      --set-rpath ${lib.makeLibraryPath [ pkgsi686Linux.stdenv.cc.cc ]}

    patchelf --set-interpreter "$interpreter" $out/bin/brprintconf_dcpl3550cdw

    wrapProgram $out/bin/brprintconf_dcpl3550cdw \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    wrapProgram $out/opt/brother/Printers/dcpl3550cdw/lpd/brdcpl3550cdwfilter \
      --set PATH ${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
          ghostscript
        ]
      } \
      --set LD_PRELOAD "${pkgsi686Linux.libredirect}/lib/libredirect.so" \
      --set NIX_REDIRECTS /opt=$out/opt

    for f in \
      $out/opt/brother/Printers/dcpl3550cdw/cupswrapper/brother_lpdwrapper_dcpl3550cdw \
      $out/opt/brother/Printers/dcpl3550cdw/lpd/filter_dcpl3550cdw \
    ; do
      wrapProgram $f \
        --set PATH ${
          lib.makeBinPath [
            coreutils
            ghostscript
            gnugrep
            gnused
            file
          ]
        }
    done

    substituteInPlace $out/bin/brprintconf_dcpl3550cdw \
      --replace-fail \"\$"@"\" \"\$"@\" | LD_PRELOAD= ${gnused}/bin/sed -E '/^(function list :|resource file :).*/{s#/opt#$out/opt#}'"
  '';

  meta = {
    description = "Brother DCP-L3550CDW printer driver";
    license = with lib.licenses; [
      unfree
      gpl2Plus
    ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource
    ];
    maintainers = [ "bwolf" ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    homepage = "https://www.brother.com/";
    downloadPage = "https://support.brother.com/g/b/downloadlist.aspx?c=de&lang=de&prod=dcpl3550cdw_eu&os=128&flang=English";
  };
})
