{ stdenv, fetchurl, makeWrapper, jre, buildTools }:

stdenv.mkDerivation rec {
  name = "apktool-${version}";
  version = "2.3.1";

  src = fetchurl {
    urls = [
      "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar"
      "https://github.com/iBotPeaches/Apktool/releases/download/v${version}/apktool_${version}.jar"
    ];
    sha256 = "01xj2hivwwp3msvv0psxyxrzg95vj2ny56l3n90glhwznn7l60ai";
  };

  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    install -D ${src} "$out/libexec/apktool/apktool.jar"
    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/apktool" \
        --add-flags "-jar $out/libexec/apktool/apktool.jar" \
        --prefix PATH : "${buildTools}/build-tools/25.0.1/"
  '';

  meta = with stdenv.lib; {
    description = "A tool for reverse engineering Android apk files";
    homepage    = https://ibotpeaches.github.io/Apktool/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms   = with platforms; unix;
  };

}
