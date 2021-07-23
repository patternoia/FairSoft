ARG BASE_IMAGE=ubuntu:20.04

FROM $BASE_IMAGE

ARG GIT_TAG=apr21p1

#
# Install dependencies
#
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
        autoconf automake binutils \
        bison build-essential bzip2 ca-certificates cmake coreutils \
        curl debianutils file findutils flex g++ gcc gfortran git gzip \
        hostname libbz2-dev libcurl4-openssl-dev libgsl-dev libicu-dev \
        libgl1-mesa-dev libglu1-mesa-dev \
        libncurses-dev libsqlite3-dev libssl-dev libtool \
        libx11-dev libxerces-c-dev libxext-dev libxft-dev \
        libxml2-dev libxmu-dev libxpm-dev libyaml-cpp-dev lsb-release make patch python-dev \
        python3-dev rsync sed subversion tar unzip wget xutils-dev xz-utils vim davix-dev \
        libsqlite3-0 libsqlite3-dev && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

#
# FairSoft
#
WORKDIR /tmp/fairsoft-build
ADD ./legacy.cmake .
RUN git clone https://github.com/FairRootGroup/FairSoft.git -b ${GIT_TAG} --depth 1 FairSoft && \
    cp ./legacy.cmake FairSoft/cmake/legacy.cmake && \
    cmake -B FairSoft_build -S FairSoft -C FairSoft/FairSoftConfig.cmake -DCMAKE_INSTALL_PREFIX=/opt/fairsoft && \
    cmake --build FairSoft_build -j`nproc` && rm -rf /tmp/fair*

ENV SIMPATH="/opt/fairsoft"\
    CLING_STANDARD_PCH="none" \
    G4ABLADATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4ABLA3.1" \
    G4ENSDFSTATEDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4ENSDFSTATE2.3" \
    G4INCLDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4INCL1.0" \
    G4LEDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4EMLOW7.13" \
    G4LEVELGAMMADATA="/opt/fairsoft/share/Geant4-10.7.1/data/PhotonEvaporation5.7" \
    G4NEUTRONHPDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4NDL4.6" \
    G4PARTICLEXSDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4PARTICLEXS3.1.1" \
    G4PIIDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4PII1.3" \
    G4RADIOACTIVEDATA="/opt/fairsoft/share/Geant4-10.7.1/data/RadioactiveDecay5.6" \
    G4REALSURFACEDATA="/opt/fairsoft/share/Geant4-10.7.1/data/RealSurface2.2" \
    G4SAIDXSDATA="/opt/fairsoft/share/Geant4-10.7.1/data/G4SAIDDATA2.0" \
    Geant4_INCLUDE_DIRS="/opt/fairsoft/include/Geant4" \
    Geant4VMC_INCLUDE_DIRS="/opt/fairsoft/include/geant4vmc:/opt/fairsoft/include/g4root" \
    Geant4VMC_LIBRARY_DIR="/opt/fairsoft/lib" \
    JUPYTER_CONFIG_DIR="/opt/fairsoft/etc/notebook" \
    JUPYTER_PATH="/opt/fairsoft/etc/notebook" \
    LD_LIBRARY_PATH="/opt/fairsoft/lib" \
    LIBPATH="/opt/fairsoft/lib" \
    PYTHIA6_LIBRARY_DIR="/opt/fairsoft/lib" \
    PYTHIA8DATA="/opt/fairsoft/share/Pythia8/xmldoc" \
    PYTHONPATH="/lib:/lib/root:/lib/Geant4:/lib/g4py" \
    ROOT_LIBRARIES="/opt/fairsoft/lib/libCore.so:/opt/fairsoft/lib/libImt.so:/opt/fairsoft/lib/libRIO.so:/opt/fairsoft/lib/libNet.so:/opt/fairsoft/lib/libHist.so:/opt/fairsoft/lib/libGraf.so:/opt/fairsoft/lib/libGraf3d.so:/opt/fairsoft/lib/libGpad.so:/opt/fairsoft/lib/libROOTDataFrame.so:/opt/fairsoft/lib/libTree.so:/opt/fairsoft/lib/libTreePlayer.so:/opt/fairsoft/lib/libRint.so:/opt/fairsoft/lib/libPostscript.so:/opt/fairsoft/lib/libMatrix.so:/opt/fairsoft/lib/libPhysics.so:/opt/fairsoft/lib/libMathCore.so:/opt/fairsoft/lib/libThread.so:/opt/fairsoft/lib/libMultiProc.so" \
    ROOT_LIBRARY_DIR="/opt/fairsoft/lib" \
    SHLIB_PATH="/opt/fairsoft/lib" \
    USE_VGM="1"

ENV PATH="${SIMPATH}/bin:${PATH}"

WORKDIR /opt/fairsoft
