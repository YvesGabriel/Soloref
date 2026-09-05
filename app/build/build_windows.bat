@echo off
REM Gera o executavel para Windows. Rode NO WINDOWS, com o venv ativo (entra em app\ sozinho).
REM   build\build_windows.bat  (de dentro de app\)  ou   app\build\build_windows.bat
cd /d "%~dp0.."

python -m pip install --upgrade pyinstaller
if exist dist rmdir /s /q dist
if exist build\_work rmdir /s /q build\_work
pyinstaller --clean --noconfirm --workpath build\_work build\soloref.spec

echo.
echo ^>^>^> Pronto: dist\SoloRef\SoloRef.exe
echo     App nao assinado: o Windows SmartScreen pode avisar - clique "Mais informacoes" ^> "Executar assim mesmo".
echo     Para um instalador unico, use Inno Setup (https://jrsoftware.org/isinfo.php) apontando para a pasta dist\SoloRef.
