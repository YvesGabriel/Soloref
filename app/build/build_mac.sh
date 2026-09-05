#!/usr/bin/env bash
# Gera o app para macOS. Rode NO MAC, com o venv ativo (o script entra em app/ sozinho).
#   bash build/build_mac.sh   (de dentro de app/)  ou   bash app/build/build_mac.sh
set -euo pipefail
cd "$(dirname "$0")/.."

python3 -m pip install -r requirements.txt
python3 -m pip install --upgrade pyinstaller
rm -rf build/_work dist
pyinstaller --clean --noconfirm --workpath build/_work build/soloref.spec

echo
echo ">>> Pronto: dist/SoloRef.app"
echo "    Para abrir na 1a vez (app nao assinado): clique com o botao direito > Abrir."
echo "    Para distribuir: precisa assinar/notarizar com conta Apple Developer."
echo "    (Opcional) gerar .dmg:  brew install create-dmg && create-dmg dist/SoloRef.app dist/"
