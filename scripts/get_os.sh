#!/bin/bash
function getOS {
    local unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)    local machine=Linux;;
        Darwin*)   local machine=Mac;;
        CYGWIN*)   local machine=Cygwin;;
        MINGW*)    local machine=MinGw;;
        *)         local machine="UNKNOWN:${unameOut}"
    esac
    echo "$machine"
}

OS=$(getOS)
echo $OS

