"""Ponto de entrada do SoloRef.

Uso:
    python main.py
"""
import logging
import sys
from pathlib import Path

from PySide6.QtGui import QIcon
from PySide6.QtWidgets import QApplication

from soloref.ui.main_window import MainWindow

RAIZ = Path(__file__).resolve().parent


def _recurso(rel: str) -> Path:
    """Caminho de um recurso empacotado (funciona no dev e no executavel)."""
    base = Path(getattr(sys, "_MEIPASS", RAIZ))
    return base / rel


def _base_gravavel() -> Path:
    """Pasta gravavel: ao lado do executavel quando empacotado; senao a raiz."""
    if getattr(sys, "frozen", False):
        return Path(sys.executable).resolve().parent
    return RAIZ


def _configurar_logging() -> None:
    logs_dir = _base_gravavel() / "logs"
    logs_dir.mkdir(exist_ok=True)
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
        handlers=[logging.FileHandler(logs_dir / "soloref_app.log", encoding="utf-8")],
    )


def main() -> int:
    _configurar_logging()
    app = QApplication(sys.argv)
    app.setApplicationName("SoloRef")
    app.setOrganizationName("ITA - IC")
    win = MainWindow()
    win.show()
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
