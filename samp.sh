#!/bin/bash

# Definições básicas
Start_CMD="./samp03svr"       # Comando Start para AMD64.
Stop_CMD="Parar Servidor"     # Comando para parar o Servidor.
Plugin_Dir="./plugins"        # Diretório onde os plugins são armazenados.
Server_Cfg="./server.cfg"     # Arquivo de configuração do servidor.

# Função para iniciar o servidor
start_server() {
    echo "🔵 Iniciando o servidor SA-MP..."
    $Start_CMD
}

# Função para parar o servidor
stop_server() {
    echo "🔴 Parando o servidor SA-MP..."
    # Comando para parar o servidor
    $Stop_CMD
}

# Função para adicionar plugins ao server.cfg
add_plugins() {
    echo "🔵 Adicionando plugins ao server.cfg..."
    for plugin in $Plugin_Dir/*.so; do
        if ! grep -q "$(basename $plugin)" "$Server_Cfg"; then
            echo "Adicionando $(basename $plugin) ao server.cfg"
            sed -i "/plugins/ s/$/ $(basename $plugin)/" "$Server_Cfg"
        else
            echo "$(basename $plugin) já está no server.cfg"
        fi
    done
}

# Verificação dos comandos passados
case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    add-plugins)
        add_plugins
        ;;
    *)
        echo "Uso: $0 {start|stop|add-plugins}"
        exit 1
        ;;
esac
