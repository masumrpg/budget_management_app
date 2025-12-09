; tool/package_windows.iss

[Setup]
AppId={{D4C7F6A3-9E2B-4C5D-8F1A-7B3E9D0C2A1E}
AppName=Budget Management App
AppVersion={#AppVersion}
AppPublisher=Masum
DefaultDirName={autopf}\Budget Management App
DefaultGroupName=Budget Management App
OutputBaseFilename=budget_management_app_setup
OutputDir=..\dist
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\budget_management_app.exe

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; IMPORTANT: Confirmed x64 path is standard for Windows builds
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Add portable data folder creation
Source: "..\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: DirExists(ExpandConstant('{src}\data'))

[Icons]
Name: "{group}\Budget Management App"; Filename: "{app}\budget_management_app.exe"
Name: "{autodesktop}\Budget Management App"; Filename: "{app}\budget_management_app.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\budget_management_app.exe"; Description: "{cm:LaunchProgram,Budget Management App}"; Flags: nowait postinstall skipifsilent
