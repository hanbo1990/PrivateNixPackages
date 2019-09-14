with import <nixpkgs>{}; 
 
#{ stdenv, fetchurl, jre, sha256 }: 
 
stdenv.mkDerivation rec { 
  version = "2.4.1"; 
  name = "apache-pulsar-${version}"; 
 
  src = fetchurl { 
    url = "https://www.apache.org/dist/pulsar/pulsar-${version}/apache-pulsar-${version}-bin.tar.gz"; 
    sha512 = "a26181dcfab650a7a79dd0cb8147d18d5e2f173eca1d29c543ccec3b025be83f079989d5d9659897915e27eef7e26eded4f4001841c578f1032e0bd18ff6fb75"; 
  }; 
 
  buildInputs = [ makeWrapper jre maven ]; 
 
  installPhase = '' 
    # move all built items into out folder 
    # todo: need to identify which binaries are required by server 
    mkdir -p $out 
    mkdir -p $out/logs 
    cp -R conf instances lib bin $out 
    
    wrapProgram $out/bin/pulsar-admin-common.sh \ 
      --set JAVA_HOME "${jre}" \ 
      --set MAVEN_HOME "${maven}" \ 
      --set PULSAR_HOME "$out"  
        
    chmod +x $out/bin\/*  
    chmod -R 777 $out/logs 
 
    #.$out/bin/pulsar-admin-common.sh 
  ''; 
 
  meta = with stdenv.lib; { 
    homepage = https://pulsar.apache.org; 
    description = "Apache Pulsar is an open-source distributed pub-sub messaging system originally created at Yahoo and now part of the Apache Software Foundation";  
    license = licenses.asl20; 
    platforms = platforms.unix; 
  }; 
 
} 
 