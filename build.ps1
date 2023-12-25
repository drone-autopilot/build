New-Item -ItemType Directory -Force .\repos
New-Item -ItemType Directory -Force .\build
Set-Location .\repos

if (!(Test-Path ".\tello-autopilot")) {
    git clone https://github.com/drone-autopilot/tello-autopilot.git
}

if (!(Test-Path ".\tello-detection")) {
    git clone https://github.com/drone-autopilot/tello-detection.git
}

if (!(Test-Path ".\TelloWatchdog")) {
    git clone https://github.com/drone-autopilot/TelloWatchdog.git
}

# build tello-autopilot
Set-Location .\tello-autopilot
git pull
cargo build
Copy-Item .\target\debug\tello-autopilot.exe ..\..\build

# build tello-detection, use pyinstaller
Set-Location ..\tello-detection
git pull
pyinstaller .\src\main.py --onefile -n tello-detection
Copy-Item .\dist\tello-detection.exe ..\..\build

# build TelloWatchdog
Set-Location ..\TelloWatchdog
git pull
dotnet publish -r win-x64 -p:PublishSingleFile=true --self-contained false
Copy-Item .\TelloWatchdog\bin\Debug\net6.0-windows\win-x64\publish\TelloWatchdog.exe ..\..\build

Set-Location ..\..\