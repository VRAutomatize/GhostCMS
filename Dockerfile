# Ghost CMS Fork - Dockerfile customizado
FROM node:18-alpine

# Instalar dependências do sistema necessárias
RUN apk add --no-cache \
    dumb-init \
    su-exec \
    bash \
    curl \
    python3 \
    make \
    g++

# Criar usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S ghost -u 1001

# Definir diretório de trabalho
WORKDIR /var/lib/ghost

# Copiar package.json do Ghost core primeiro
COPY ghost/core/package.json ./

# Instalar dependências de produção com npm (mais estável)
RUN npm install --production --no-optional --legacy-peer-deps && \
    npm cache clean --force

# Copiar código fonte do Ghost
COPY ghost/core/ ./

# Criar diretório de conteúdo e definir permissões
RUN mkdir -p /var/lib/ghost/content && \
    chown -R ghost:nodejs /var/lib/ghost && \
    chmod -R 755 /var/lib/ghost

# Construir assets de produção
RUN npm run build:assets

# Expor porta
EXPOSE 2368

# Definir usuário
USER ghost

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:2368/ghost/ || exit 1

# Comando de inicialização
CMD ["dumb-init", "node", "index.js", "start", "--no-setup"]
