#!/bin/bash

echo "getting MS setup"
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
echo "installing MS setup"
sudo dpkg -i packages-microsoft-prod.deb

echo "update"
sudo apt-get update
echo "install apt-transport-https"
sudo apt-get install apt-transport-https
echo "update"
sudo apt-get update
echo "install dotnet-sdk-3.1"
sudo apt-get install dotnet-sdk-3.1