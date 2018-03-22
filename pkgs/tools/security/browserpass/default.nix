# This file was generated by https://github.com/kamilchm/go2nix v1.2.0
{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "browserpass-${version}";
  version = "2.0.13";

  goPackagePath = "github.com/dannyvankooten/browserpass";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    repo = "browserpass";
    owner = "dannyvankooten";
    rev = version;
    sha256 = "0pch0jddphgaaw208ddqjhnkiy5916n0kjxfza1cpc78fa8zw82l";
  };

  postInstall = ''
      host_file="$bin/bin/browserpass"
      mkdir -p "$bin/etc"

      sed -e "s!%%replace%%!$host_file!" go/src/${goPackagePath}/chrome/host.json > chrome-host.json
      sed -e "s!%%replace%%!$host_file!" go/src/${goPackagePath}/firefox/host.json > firefox-host.json

      install chrome-host.json $bin/etc/
      install -D firefox-host.json $bin/lib/mozilla/native-messaging-hosts/com.dannyvankooten.browserpass.json
      install go/src/${goPackagePath}/chrome/policy.json $bin/etc/chrome-policy.json
  '';

  meta = with stdenv.lib; {
    description = "A Chrome & Firefox extension for zx2c4's pass";
    homepage = https://github.com/dannyvankooten/browserpass;
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin ++ openbsd;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
