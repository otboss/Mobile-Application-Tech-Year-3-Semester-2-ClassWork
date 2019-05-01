#!/bin/bash

printf "Calabash installer started..\n";
printf "Run this script using the command 'source ./calabash-installer.sh'\n";
printf "IT WILL FAIL IF UNSOURCED!";
sleep 4;
sudo apt-get update;
sudo add-apt-repository ppa:openjdk-r/ppa;
sudo apt-get update;
printf "\n\n\n\n\n\n";
printf "Installing Requirements..";
sleep 3;
sudo apt-get install openjdk-8-jdk;
sudo apt-get install wget unzip curl;
sudo apt-get install ruby-dev;
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
printf "\n\n\n\n\n\n";
printf "Downloading RVM";
sleep 2;
\curl -sSL https://get.rvm.io | bash -s stable --ruby;
source ~/.rvm/scripts/rvm;
rvm install 2.3.1;
rvm use 2.3.1 --default;
cd ~/.rvm/gems/ruby-2.3.1;
gem install calabash-android;
cd ~/;
read -p 'Do you already have Android Studio installed and have set up the SDK before? [Y/n] ' choice;
if [ "$choice" == "n" -o "$choice" == "N" ];
then
    printf "\n\n\n\n\n\n";
    printf "Downloading Android Studio..";
    sleep 1;
    wget https://dl.google.com/dl/android/studio/ide-zips/3.3.2.0/android-studio-ide-182.5314842-linux.zip;
    printf "Unzipping..";    
    unzip android-studio-ide-182.5314842-linux.zip;
    printf "Starting Android Studio.. Please Setup the SDK and Quit when finished";
    sleep 2;
    chmod +x ./android-studio/bin/studio.sh;
    ./android-studio/bin/studio.sh;
fi
export ANDROID_HOME='/home/'$USER'/Android/Sdk';
export PATH=${PATH}:$ANDROID_HOME/platform-tools;
printf '#!/bin/bash
#Run this file with the command: source ./setpaths.sh
export ANDROID_HOME="/home/'$USER'/Android/Sdk";
export PATH=${PATH}:$ANDROID_HOME/platform-tools;
source ~/.rvm/scripts/rvm;' > setpaths.sh;
chmod +x setpaths.sh;
printf "\n\n\n\n";
printf "Enviromnent Paths set! This is only per terminal session. A script file has been generated, you may run this file in the future using the command 'source ./setpaths.sh'\n\n\n";
sleep 3;
printf "Generating Keystore..";
keytool -genkey -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US";
printf "Keystore Generated.\n\n";
sleep 2;
printf "Calabash Installation Complete.";
