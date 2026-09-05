# -*- mode: python ; coding: utf-8 -*-
# PyInstaller spec do SoloRef.
#   cd app && pyinstaller build/soloref.spec
# Gera dist/SoloRef (Windows) ou dist/SoloRef.app (macOS). Sem cross-compile:
# .exe so no Windows, .app so no macOS.
import os
import sys

block_cipher = None

# Caminhos absolutos, independentes de onde o pyinstaller e chamado.
# SPECPATH = pasta deste .spec (app/build); APP = app/
APP = os.path.abspath(os.path.join(SPECPATH, '..'))
ASSETS = os.path.join(APP, 'assets')
ICONE = os.path.join(ASSETS, 'icone.icns' if sys.platform == 'darwin' else 'icone.ico')

a = Analysis(
    [os.path.join(APP, 'main.py')],
    pathex=[APP],
    binaries=[],
    datas=[(os.path.join(ASSETS, 'icone.png'), 'assets')],  # icone da janela em runtime
    hiddenimports=[],                            # PySide6/scipy detectados automaticamente
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=['tkinter', 'pytest', '_pytest'],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='SoloRef',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,                  # app de janela (GUI), sem terminal
    disable_windowed_traceback=False,
    argv_emulation=True,            # macOS: permite abrir arquivos arrastados
    target_arch=None,               # macOS: 'universal2' para Intel+ARM, se quiser
    codesign_identity=None,
    entitlements_file=None,
    icon=ICONE,
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='SoloRef',
)

# No macOS, empacota tambem como .app (bundle clicavel):
if sys.platform == 'darwin':
    app = BUNDLE(
        coll,
        name='SoloRef.app',
        icon=os.path.join(ASSETS, 'icone.icns'),
        bundle_identifier='br.ita.soloref',
        info_plist={'NSHighResolutionCapable': 'True'},
    )
