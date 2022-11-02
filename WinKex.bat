@echo off
cd /Users/Public/Desktop
goto admincheck


:admincheck
    echo Administrative permissions required. Detecting permissions...
    
    net session >nul 2>&1
    if %errorLevel% == 0 (
        goto menu
    ) else (
        echo Failed: Please run as admin.
    )
    
    pause >nul

:menu
cls
echo Welcome to Zigz Kali Linux Win-Kex Install script.
echo
echo IMPORTANT: To run seemless you NEED to download Windows X-server https://sourceforge.net/projects/vcxsrv/
echo
echo Options:
echo 1 - Run the wsl configuration/install commands
echo 2 - Install with a new kali image
echo 3 - Install to your preinstalled kali image (will use "wsl -d kali-linux" to access the instance)
echo 4 - Just create the Win-Kex startup batch scripts in the active folder
echo 5 - Exit

set /P select="Enter Option Number: "

if "%select%"=="1" (
	goto preinstall
) 
if "%select%"=="2" (
	goto setupkali
) 
if "%select%"=="3" (
    goto installwinkex
) 
if "%select%"=="4" (
    goto createbatch
) 
if "%select%"=="5"(
    echo Good bye!
    goto CEND
) else (
    echo ERROR %select% was not recognized
    pause
    goto menu
)



:preinstall
echo You will need to run this twice
echo After running each part you need to manually restart (you only need to run each once)
echo 1 - run part one
echo 2 - run part two
echo 3 - goes back to the main menu
set /P select="Enter Option Number: "

IF "%select%"=="1" (
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    goto REEND
)
IF "%select%"=="2" (
	dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    goto REEND

)
IF "%select%"=="3"(
    goto menu
) ELSE (
    echo ERROR %select% was not recognized
    pause
    goto preinstall
)




:setupkali
wsl --install kali-linux --web-download --no-launch
goto installwinkex



:installwinkex
echo Installing win-kex
wsl -d kali-linux sudo apt update; sudo apt upgrade -y; sudo apt install -y kali-win-kex
goto SEND




:createbatch
(
    echo start wsl -d kali-linux echo IMPORTANT: To start Win-Kex in windowed/remote mode with sound just run 'kex -s'; echo or run 'kex --sl -s' to run the seemless version with sound; /bin/bash
) > LauchKali.bat
goto SEND

:SEND
echo The script is finished. Please use the batch scripts on your desktop to run WSL or the KEX command inside of your WSL kali instance.
goto CEND

:REEND
echo Please restart your system
goto CEND

:CEND
pause
