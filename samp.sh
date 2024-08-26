#!/bin/bash

# Definições básicas
StartAMD="./samp03svr"         # Comando Start para amd.
StartARM="sh -c box86 ./samp03svr"  # Comando Start para arm.
Stop_CMD="Parar Servidor"     # Comando para parar o Servidor do NoHub.
Plugin_Dir="./plugins"        # Diretório onde os plugins são armazenados.
Server_Cfg="./server.cfg"     # Arquivo de configuração do servidor.

# Função para iniciar o servidor
start_server() {
    echo "🔵 Iniciando o servidor SA-MP..."
    if [ "$(uname -m)" == "x86_64" ]; then
        $StartAMD
    else
        $StartARM
    fi
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
