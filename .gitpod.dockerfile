FROM gitpod/workspace-full-vnc:latest

USER root

# Install custom tools, runtime, etc.
RUN apt-get update \
    # window manager
    && apt-get install -y jwm \
    # electron
    && apt-get install -y libgtk-3-0 libnss3 libasound2 \
    # native-keymap
    && apt-get install -y libx11-dev libxkbfile-dev \
    # dotnet
    && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb && rm -rf packages-microsoft-prod.deb \
    && add-apt-repository universe \
    && apt-get update \
    && apt-get -y -o APT::Install-Suggests="true" install dotnet-sdk-2.1.500 \
    # mono
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get install -y mono-devel \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

USER gitpod
# Apply user-specific settings
RUN bash -c ". .nvm/nvm.sh \
    && nvm install 10 \
    && nvm use 10 \
    && npm install -g yarn"

# Give back control
USER root
