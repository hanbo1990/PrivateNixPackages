with import <nixpkgs>{}; 
 
#{ stdenv, fetchurl, jre, sha256 }: 
 
stdenv.mkDerivation rec { 
  version = "2.4.1"; 
  name = "apache-pulsar-${version}"; 
 
  src = fetchurl { 
    url = "https://www.apache.org/dist/pulsar/pulsar-${version}/apache-pulsar-${version}-bin.tar.gz"; 
    sha512 = "a26181dcfab650a7a79dd0cb8147d18d5e2f173eca1d29c543ccec3b025be83f079989d5d9659897915e27eef7e26eded4f4001841c578f1032e0bd18ff6fb75"; 
  }; 
 
  buildInputs = [ makeWrapper jre bash ]; 
 
  installPhase = '' 
    # move all built items into out folder 
    # todo: need to identify which binaries are required by server 
    mkdir -p $out 
    mkdir -p $out/data
    cp -R conf instances lib bin $out 

    sed -i 's/dataDir=data/dataDir=\/home\/bo\/log/g' $out/conf/global_zookeeper.conf
    sed -i 's/dataDir=data/dataDir=\/home\/bo\/log/g' $out/conf/zookeeper.conf
    sed -i 's/data\//\/home\/bo\/log\//g' $out/conf/bookkeeper.conf
    sed -i 's/\# indexDirectories/indexDirectories/g' $out/conf/bookkeeper.conf

    # for p in $out/bin\/* ; do   # this does not work..  
    wrapProgram $out/bin/pulsar \
      --set JAVA_HOME "${jre}" \
      --set PULSAR_LOG_DIR "/tmp/pulsar-logs" \
      --prefix PATH : "${bash}/bin"
    #done    
 
   
    chmod +x $out/bin\/*  
  ''; 
 
  meta = with stdenv.lib; { 
    homepage = https://pulsar.apache.org; 
    description = "Apache Pulsar is an open-source distributed pub-sub messaging system originally created at Yahoo and now part of the Apache Software Foundation";  
    license = licenses.asl20; 
    platforms = platforms.unix; 
  }; 
 
} 
 
