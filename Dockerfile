FROM ubuntu:18.04

USER root

ENV ANDROID_HOME=/android-sdk PATH=$PATH:/android-sdk/tools:/android-sdk/tools/bin:/android-sdk/platform-tools

# Install all system requirements
RUN apt-get update && apt-get install -y sudo lib32z1 lib32ncurses5 g++ unzip openjdk-8-jdk zsh-common curl gnupg2 git make libx32gcc-8-dev xxd docker.io && \
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/lib/apt/*

RUN groupadd tnsgroup && \
  useradd -m -g tnsgroup tnsuser

# Allow the tnsuser to use sudo without a password (helps when debugging configuration issues)
RUN echo "tnsuser ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/tnsuser && \
  chmod 0440 /etc/sudoers.d/tnsuser

# Switch to non-root tns-user
USER tnsuser

# Install android sdk
RUN curl "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" -o /tmp/sdk.zip && \
  sudo mkdir -p /android-sdk && \
  sudo chmod a+w /android-sdk && \
  unzip -q /tmp/sdk.zip -d /android-sdk && \
  mkdir -p ~/.android/ && touch ~/.android/repositories.cfg && \
  rm /tmp/sdk.zip

RUN echo "export JAVA_OPTS=\"$JAVA_OPTS\"" >> ~/.bashrc && \
  echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc && \
  echo "export PATH=$PATH" >> ~/.bashrc

# Download sdk components (takes a long time)
RUN yes | /android-sdk/tools/bin/sdkmanager --licenses && \
  /android-sdk/tools/bin/sdkmanager "tools" "platform-tools" "platforms;android-30" "build-tools;30.0.3" "extras;google;m2repository" "extras;android;m2repository"

# Install nativescript globally
RUN yes | sudo npm install nativescript@8.1.5 -g

# Configure reporting, and ensure that we have a good setup (will fail if 'nativescript doctor' finds any issues)
RUN tns usage-reporting disable && \
  tns error-reporting enable && \
  nativescript doctor
