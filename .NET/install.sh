#!/bin/bash
nuget restore $SOLUTION_NAME.sln

# Install .NET core SDK
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-3.1

# Install minver core util
dotnet tool install --global minver-cli --version 2.0.0