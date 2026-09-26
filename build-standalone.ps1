param(
    [switch]$RunTests,
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot
try {
    & $Python -m pip install --upgrade pip
    & $Python -m pip install -r requirements.txt
    & $Python -m pip install pyinstaller '.[dev]'

    if ($RunTests) {
        & $Python -m pytest tests -v
    }

    & $Python -m PyInstaller --noconfirm --clean --onefile --name office-mcp-server --paths . --collect-submodules tools --hidden-import aioumcp --hidden-import umcp_shared --add-data "vendor/umcp;vendor/umcp" office_server.py

    Write-Host "Standalone executable created at: $PSScriptRoot\dist\office-mcp-server.exe"
}
finally {
    Pop-Location
}
