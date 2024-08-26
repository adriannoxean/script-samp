#!/bin/bash

# Variáveis
DOWNLOAD_URL="https://nx-h.org/0.3.7.tar.gz"
SAMP_SERVER_PATH="/home/container"
SAMP_BINARY="samp03svr"
CHECK_URL="https://github.com/adriandbrz/samp/samp.sh"

# Função para restaurar o arquivo samp03svr
function restore_samp03svr {
    echo "samp03svr não detectado, restaurando..."
    
    # Baixar o arquivo e extrair apenas o samp03svr
    curl -sSL -o /tmp/samp.tar.gz $DOWNLOAD_URL
    mkdir -p /tmp/samp_extract
    tar -xzvf /tmp/samp.tar.gz -C /tmp/samp_extract samp03svr
    
    # Mover o arquivo restaurado para o diretório do servidor
    mv /tmp/samp_extract/samp03svr $SAMP_SERVER_PATH
    
    # Dar permissões de execução ao binário
    chmod +x $SAMP_SERVER_PATH/$SAMP_BINARY
    echo "samp03svr restaurado com sucesso e permissões aplicadas."
    
    # Limpar arquivos temporários
    rm -rf /tmp/samp.tar.gz /tmp/samp_extract
}

# Função para atualizar plugins no server.cfg
function update_plugins_in_server_cfg {
    PLUGIN_DIR="$SAMP_SERVER_PATH/plugins"
    SERVER_CFG="$SAMP_SERVER_PATH/server.cfg"
    
    # Checar se o diretório de plugins existe
    if [ -d "$PLUGIN_DIR" ]; then
        # Encontrar todos os arquivos .so no diretório de plugins
        PLUGINS=$(ls $PLUGIN_DIR/*.so 2>/dev/null | xargs -n 1 basename | tr '\n' ' ')
        
        # Atualizar o server.cfg com os plugins
        sed -i '/^plugins /d' $SERVER_CFG
        echo "plugins $PLUGINS" >> $SERVER_CFG
        echo "Plugins atualizados no server.cfg com sucesso."
    else
        echo "Diretório de plugins não encontrado."
    fi
}

# Verificação se o samp03svr existe
if [ ! -f "$SAMP_SERVER_PATH/$SAMP_BINARY" ]; then
    restore_samp03svr
else
    echo "samp03svr já está presente."
fi

# Definindo permissões se o arquivo existe
chmod +x $SAMP_SERVER_PATH/$SAMP_BINARY

# Atualizar plugins no server.cfg
update_plugins_in_server_cfg

# Baixar e executar script adicional de GitHub (se necessário)
curl -sSL $CHECK_URL | bash

# Iniciar o servidor e exibir as 70 últimas linhas do log
echo "Iniciando servidor SA-MP..."
cd $SAMP_SERVER_PATH
./samp03svr > server_log.txt 2>&1 &

# Aguardar o servidor iniciar
sleep 10

# Exibir as últimas 70 linhas do log
tail -n 70 server_log.txt

echo "Instalação concluída!"
