#!/usr/bin/env bash
# Publica SOMENTE a versao atual (1 unico commit, sem historico) no remoto.
# Artigo/, ia/, docs/, CLAUDE.md ja estao no .gitignore -> nao entram no commit.
# Rode no terminal LOCAL do seu Mac (VS Code), na raiz do repositorio.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
echo "==> Repositorio local : $(pwd)"
echo "==> Remoto de destino : $(git remote get-url origin)"

# 0) Backup completo do historico atual (por seguranca)
STAMP=$(date +%Y%m%d-%H%M)
git bundle create "../soloref-backup-${STAMP}.bundle" --all
echo "    backup: ../soloref-backup-${STAMP}.bundle"

# 1) Remove locks que possam ter sobrado
rm -f .git/index.lock .git/packed-refs.lock .git/refs/remotes/origin/*.lock 2>/dev/null || true

# 2) Cria um commit orfao (sem pais) com o estado atual, respeitando o .gitignore
git checkout --orphan _publish_tmp
git rm -r --cached . >/dev/null 2>&1 || true   # limpa o index
git add -A                                      # re-adiciona so o que NAO e ignorado
# tira do commit os proprios scripts auxiliares gerados por IA (ficam so locais)
git rm -q --cached --ignore-unmatch publicar_soloref.sh purgar_artigo_git.sh >/dev/null 2>&1 || true
git commit -m "SoloRef — versao inicial"

# 3) Faz esse commit virar o main
git branch -M main

# 4) Verificacao
echo
echo "==> VERIFICACAO"
echo "    commits (=1)..............: $(git rev-list --count HEAD)"
echo "    arquivos no commit........: $(git ls-files | wc -l | tr -d ' ')"
echo "    Artigo rastreado (=0).....: $(git ls-files | grep -c Artigo || true)"
echo "    ia/docs/CLAUDE (=0).......: $(git ls-files | grep -icE 'claude\.md|^ia/|^docs/' || true)"
echo "    destino...................: $(git remote get-url origin)"
echo

# 5) Push (com confirmacao)
read -r -p "Enviar SOMENTE esta versao para o remoto (--force)? [s/N] " R
if [ "$R" = "s" ] || [ "$R" = "S" ]; then
  git push -u --force origin main
  echo ">>> Push concluido."
else
  echo "Abortado antes do push. Para enviar depois:"
  echo "    git push -u --force origin main"
fi
