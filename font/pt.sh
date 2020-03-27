#!/bin/bash

# Installs PT Mono font onto Ubuntu 12.04 or 14.04 Systems

# Check to make sure the user has the unzip package installed
export NO_UNZIP=$(apt-cache policy unzip | grep "Installed: (none)" | wc -l)

# Result will be 1 if it is NOT installed
if [ "$NO_UNZIP" = "0" ]; then

    export TEMP_DIR='temp-technostu-script'
    cd ~
    mkdir $TEMP_DIR
    cd $TEMP_DIR

    # Download PT mono from google fonts
    export FONT_URL="http://www.google.com/fonts/download"
    export FONT_URL="$FONT_URL?kit=7qsh9BNBJbZ6khIbS3ZpfKCWcynf_cDxXwCLxiixG1c"
    wget --content-disposition "$FONT_URL"

    # Create a PT_Mono directory which we will copy across into the fonts directory.
    mkdir PT_Mono
    mv PT_Mono.zip PT_Mono/.
    cd PT_Mono
    unzip PT_Mono.zip
    rm PT_Mono.zip
    cd ..
    sudo mv PT_Mono /usr/share/fonts/truetype/.

    # Re-cache the fonts
    echo 'Re-caching fonts...'
    sudo fc-cache -fv

    # cleanup
    cd ~
    sudo rm -rf $TEMP_DIR

    echo 'done!'
else
    # User doesnt have unzip installed, tell them how to install it
    echo 'You need to install unzip for this to work: try '
    echo '"sudo apt-get install unzip"'
fi
