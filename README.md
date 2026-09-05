# SoloRef

Programa aberto e multiplataforma para **análise de estabilidade e dimensionamento
de estruturas de solo reforçado** (muros e taludes). Reimplementa, em Python/PySide6,
um programa legado que não roda nos Windows atuais. Reúne os métodos de empuxo de
cunha plana (Rankine, Coulomb e dois blocos), o fator de segurança de Bishop
simplificado, o dimensionamento com geossintéticos e as verificações de estabilidade
externa — todos validados contra a literatura.

Projeto de Iniciação Científica de **Yves Gabriel Queiroz de Sousa**, orientado
pelo **Prof. José Antonio Schiavon** (ITA).

## Estrutura

Todo o código versionado fica em **`app/`**:

```
app/
├── main.py            ponto de entrada (abre a interface)
├── requirements.txt   dependências
├── validar.py         valida os cálculos contra a literatura
├── soloref/           o programa
│   ├── core/          cálculo puro, sem interface (modelos + métodos)
│   └── ui/            interface PySide6
├── tests/             testes automatizados
├── assets/            ícones do aplicativo
└── build/             empacotamento em executável (PyInstaller)
```

## Requisitos

- Python 3.10 ou superior
- Dependências: PySide6, NumPy, SciPy, pytest (ver `app/requirements.txt`)

> O repositório **não inclui** o ambiente virtual nem as bibliotecas — eles são
> criados na sua máquina no passo abaixo. Isso mantém o repositório leve.

## Instalação e execução

Faça uma vez, a partir da pasta `app/`:

```bash
cd app

# 1) criar o ambiente virtual (uma pasta 'venv' local, não versionada)
python3 -m venv venv

# 2) ativar o ambiente
source venv/bin/activate         # macOS/Linux
# venv\Scripts\activate          # Windows (PowerShell/CMD)

# 3) instalar as dependências
pip install -r requirements.txt
```

Depois, sempre que quiser abrir o programa:

```bash
cd app
source venv/bin/activate         # (Windows: venv\Scripts\activate)
python main.py
```

### Reinstalar do zero

Se o ambiente corromper ou você quiser recomeçar, apague a pasta `venv` e
refaça os passos 1–3:

```bash
cd app
rm -rf venv                      # Windows: rmdir /s /q venv
python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt
```

## Testes e validação

Ainda dentro de `app/`, com o ambiente ativo:

```bash
# testes automatizados (rápidos, não abrem janela)
pytest -q

# validação contra os casos da literatura
python validar.py
```

O `validar.py` roda todos os casos de referência e gera o relatório legível
**`RELATORIO_VALIDACAO.md`** (com valor calculado, valor esperado e erro por caso).
Os métodos de fórmula fechada ficam com erro inferior a 0,2%; os de busca de
superfície crítica (Bishop, estabilidade externa), entre 1% e 1,5%.

> Não altere as fórmulas em `soloref/core/methods/` sem rodar `validar.py` —
> ele é a rede de segurança contra regressões.

## Gerar o executável

O empacotamento usa **PyInstaller** e **não** faz cross-compile: o `.exe` do
Windows só sai no Windows e o `.app` do macOS só sai no macOS. Com o ambiente
ativo, a partir de `app/`:

```bash
# macOS  -> gera dist/SoloRef.app
bash build/build_mac.sh

# Windows -> gera dist/SoloRef/SoloRef.exe
build\build_windows.bat
```

Aplicativos não assinados disparam aviso do Gatekeeper (macOS: abrir com botão
direito → Abrir) ou do SmartScreen (Windows: Mais informações → Executar assim
mesmo). Para distribuição ampla é preciso assinar/notarizar.
