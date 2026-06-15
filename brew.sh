#!/bin/bash
# Instala todo lo declarado en el Brewfile. Idempotente: reejecutar es seguro.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew update

# `brew bundle` distingue brew / cask / tap / font correctamente y solo instala
# lo que falta (a diferencia de una lista de `brew install`, donde un cask escrito
# como fórmula fallaba).
brew bundle --file="${SCRIPT_DIR}/Brewfile"
