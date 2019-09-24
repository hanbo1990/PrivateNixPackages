with import <nixpkgs>{}; 
 
#{ stdenv, fetchurl, jre, sha256 }: 
 
stdenv.mkDerivation rec { 
  version = "4.9.2"; 
  name = "apache-bookkeeper-${version}"; 
 
  src = fetchurl { 
    url = "https://archive.apache.org/dist/bookkeeper/bookkeeper-${version}/bookkeeper-server-${version}-bin.tar.gz"; 
    sha512 = "aff96d6068852c109076dc4ffea66158a41f73d9b9adfd064b3e75ab372fcedb002610c65949948566a37dbbe6f5f79f72956d3102edaf3e878d42afac263f0f"; 
  }; 
 
  buildInputs = [ makeWrapper jre bash ]; 
 
  installPhase = '' 
    # move all built items into out folder 
    # todo: need to identify which binaries are required by server 
    mkdir -p $out 
    # todo move conf to other folder and link conf inside bin file
    cp -R  deps conf lib bin $out

    substituteInPlace $out/conf/bk_server.conf \
        --replace data/bookkeeper/ranges /home/bo/tempdata/logs/ranges

    # for p in $out/bin\/* ; do   # this does not work..  
    wrapProgram $out/bin/bookkeeper \
      --set JAVA_HOME "${jre}" \
      --set BOOKIE_LOG_DIR "/home/bo/tempdata/logs" \
      --prefix PATH : "${bash}/bin"
    #done    
 
    chmod +x $out/bin\/*  
  ''; 
 
  meta = with stdenv.lib; { 
    homepage = https://bookkeeper.apache.org; 
    description = "Apache Pulsar is an open-source distributed pub-sub messaging system originally created at Yahoo and now part of the Apache Software Foundation";  
    license = licenses.asl20; 
    platforms = platforms.unix; 
  }; 
 
} 
 
