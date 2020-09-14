# nativescript-cli

This repo includes nativescript running on ubuntu-18.04 LTS.

It includes android sdk and latest node.js v10.x.

It allows you with a single command to build your entire nativescript application for android.

Perfect for CI environments like jenkins or bitbucket pipelines.

# Reproducability

For reproducable builds I added version branches / tags on docker hub.

Branch version/18.04-10.x-6.8.0-29.0.3

Is creating a Docker container with

- Ubuntu 18.04 LTS
- Node.js v10.x
- Nativescript CLI 7.0.8
- Android SDK 29.0.3

If you need more version combinations just create PRs on Bitbucket, Docker added for dind

# Running android with version/18.04-10.x-6.8.0-29.0.3

`docker run -v $(pwd):/app -it scratchy/nativescript-cli:18.04-10.x-6.8.0-29.0.3 bash -c "cd /app && tns build android"`

# Visual Studio Code devcontainer Usage

This image can be used for developing nativescript apps in a consistent environment, rather than installing nativescript on your local machine. Follow the standard steps for using a devcontainer, and use a `devcontainer.json` file similar to this:

```
{
    "name": "Sample Visual Studio Code Nativescript devcontainer.json configuration",
    "image": "scratchy/nativescript-cli:18.04-10.x-6.8.0-29.0.3"
    # Instead of "image", use "dockerFile": "<path to Dockerfile>",
    "settings": {
        "terminal.integrated.shell.linux": "/bin/bash"
    },
    "remoteUser": "tnsuser",
    "mounts": [
        "source=${localWorkspaceFolder}/Cache/.gradle,target=/home/tnsuser/.gradle,type=bind"
    ],
    "runArgs": [
        "--privileged",
        "-v",
        "/dev/bus/usb:/dev/bus/usb"
    ]
}
```

Notes:

- If you use a `Dockerfile`, it should start with `FROM scratchy/nativescript-cli:18.04-10.x-6.8.0-29.0.3` and then add customizations
- The image is about 2.5 GB, so it will take a long time for Visual Studio to start up the first time (however the image will be cached for future runs)
- This will cache downloaded gradle files (make sure `${localWorkspaceFolder}/Cache/.gradle` is in `.gitignore`)
- This will allow communication with physical Android phones (on a linux machine)
