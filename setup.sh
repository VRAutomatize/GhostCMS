#!/bin/bash

# Script de setup para Ghost CMS Fork
# Configura o ambiente completo para desenvolvimento e produção

set -e

echo "🚀 Configurando Ghost CMS Fork..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    error "Docker não está instalado. Por favor, instale o Docker primeiro."
fi

# Verificar se Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    error "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
fi

# Verificar se Node.js está instalado
if ! command -v node &> /dev/null; then
    warn "Node.js não está instalado. Instalando dependências apenas via Docker..."
    NODE_AVAILABLE=false
else
    NODE_AVAILABLE=true
fi

# Verificar se Yarn está instalado
if [ "$NODE_AVAILABLE" = true ] && ! command -v yarn &> /dev/null; then
    warn "Yarn não está instalado. Instalando..."
    npm install -g yarn
fi

log "Criando diretório de conteúdo..."
mkdir -p content

log "Definindo permissões corretas..."
chmod 755 content

log "Construindo imagem Docker..."
docker build -t ghost-cms-fork .

log "Subindo serviços..."
docker-compose up -d

log "Aguardando serviços iniciarem..."
sleep 30

# Verificar se os serviços estão rodando
if ! docker-compose ps | grep -q "Up"; then
    error "Falha ao iniciar os serviços. Verifique os logs com: docker-compose logs"
fi

log "Verificando saúde dos serviços..."
sleep 10

# Verificar MySQL
if docker-compose exec mysql mysqladmin ping -h localhost -u mysql -p91cf92ea3a47f6ced4f7 --silent; then
    log "✅ MySQL está rodando"
else
    warn "⚠️ MySQL pode não estar totalmente pronto ainda"
fi

# Verificar Ghost
if curl -f http://localhost:2368/ghost/ &> /dev/null; then
    log "✅ Ghost está rodando"
else
    warn "⚠️ Ghost pode não estar totalmente pronto ainda"
fi

log "Executando seed (se disponível)..."
if [ "$NODE_AVAILABLE" = true ]; then
    yarn install
    node seed.js || warn "Seed falhou ou já foi executado"
else
    warn "Seed não executado - Node.js não disponível localmente"
fi

echo ""
echo -e "${BLUE}🎉 Setup concluído!${NC}"
echo ""
echo -e "${GREEN}📋 Próximos passos:${NC}"
echo "1. Acesse: http://localhost:2368"
echo "2. Admin: http://localhost:2368/ghost/"
echo "3. Login: admin@clebersocial.com.br / admin123!@#"
echo ""
echo -e "${GREEN}🔧 Comandos úteis:${NC}"
echo "• Ver logs: docker-compose logs -f"
echo "• Parar: docker-compose down"
echo "• Reiniciar: docker-compose restart"
echo "• Shell: docker-compose exec ghost-fork /bin/bash"
echo ""
echo -e "${GREEN}📚 Para deploy no Easypanel:${NC}"
echo "1. Commit e push do código"
echo "2. Importe o repositório no Easypanel"
echo "3. Configure o domínio: blog.clebersocial.com.br"
echo ""
echo -e "${YELLOW}⚠️ IMPORTANTE: Altere a senha padrão após o primeiro login!${NC}"
