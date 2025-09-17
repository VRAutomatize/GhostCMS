# Ghost CMS Fork - Dockerfile funcional
FROM node:18-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    dumb-init \
    bash \
    curl

# Criar usuário não-root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S ghost -u 1001

# Definir diretório de trabalho
WORKDIR /var/lib/ghost

# Copiar package.json primeiro
COPY ghost/core/package.json ./

# Instalar apenas dependências essenciais
RUN npm install --production --omit=dev --omit=optional --legacy-peer-deps --no-audit --no-fund --ignore-scripts

# Limpar cache
RUN npm cache clean --force

# Copiar código fonte do Ghost
COPY ghost/core/ ./

# Criar diretório de conteúdo com permissões corretas
RUN mkdir -p /var/lib/ghost/content && \
    chown -R ghost:nodejs /var/lib/ghost && \
    chmod -R 755 /var/lib/ghost

# Tentar construir assets (ignorar erros)
RUN npm run build:assets || echo "Build assets failed, continuing..."

# Limpar arquivos desnecessários
RUN rm -rf /tmp/* /var/tmp/* /root/.npm

# Expor porta
EXPOSE 2368

# Definir usuário
USER ghost

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:2368/ghost/ || exit 1

# Comando de inicialização
CMD ["dumb-init", "node", "index.js", "start", "--no-setup"]
