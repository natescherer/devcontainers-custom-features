FROM mcr.microsoft.com/devcontainers/base:debian

# Set default shell for RUN commands to bash
SHELL ["/bin/bash", "-c"]

# Copy support files into image
COPY * /opt/testsuite/

# Install PowerShell manually
RUN ARCHITECTURE="$(uname -m)" && \
    case ${ARCHITECTURE} in \
    x86_64) ARCHITECTURE="x64" ;; \
    aarch64 | armv8*) ARCHITECTURE="arm64" ;; \
    aarch32 | armv7* | armvhf*) ARCHITECTURE="arm32" ;; \
    *) \
        echo "(!) Architecture ${ARCHITECTURE} unsupported" \
        exit 1 \
        ;; \
    esac && \
    curl -L -o /tmp/powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/powershell-7.3.6-linux-$ARCHITECTURE.tar.gz"
# RUN if [ $(uname -m) = "x86_64" ]; then export ARCHITECTURE="x64"; elif [[ $(uname -m) =~ "aarch64|armv8.*" ]]; then export ARCHITECTURE="arm64"; elif [[ $(uname -m) =~ "aarch32|armv7.*|armvhf.*" ]]; then export ARCHITECTURE="arm32"; fi
#RUN curl -L -o /tmp/powershell.tar.gz "https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/powershell-7.3.6-linux-$ARCHITECTURE.tar.gz"
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Install old version of PSResourceGet
RUN pwsh -c "Install-Module -Name Microsoft.PowerShell.PSResourceGet -RequiredVersion 0.5.22-beta22 -Force -AllowPrerelease -Scope AllUsers"