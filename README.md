# Ghost CMS Fork - Blog Cleber Social

Este é um fork customizado do Ghost CMS otimizado para deploy no Easypanel, com configurações explícitas e sem dependência de variáveis mágicas.

## 🚀 Características

- **Ghost CMS 6.0.8** baseado no repositório oficial
- **MySQL 8.0** como banco de dados
- **Dockerfile customizado** baseado em `node:18-alpine`
- **Configuração explícita** via `config.production.json`
- **Deploy pronto** para Easypanel
- **Script de seed** para dados iniciais
- **Volume persistente** para conteúdo

## 📋 Pré-requisitos

- Docker e Docker Compose
- Node.js 18+ (para desenvolvimento local)
- Yarn 1.x

## 🛠️ Configuração Local

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/ghost-cms-fork.git
cd ghost-cms-fork
```

### 2. Instale as dependências

```bash
yarn install
```

### 3. Execute com Docker Compose

```bash
# Subir os serviços
yarn docker:run

# Ver logs
yarn docker:logs

# Parar os serviços
yarn docker:stop
```

### 🔧 Dockerfiles Disponíveis

O projeto inclui 4 versões do Dockerfile para diferentes cenários:

- **`Dockerfile`** - Versão completa com yarn (padrão)
- **`Dockerfile.simple`** - Versão simplificada com npm
- **`Dockerfile.robust`** - Versão robusta com otimizações
- **`Dockerfile.fixed`** - Versão com correção de conflitos de dependências (recomendada)

**Para Easypanel**, use o `Dockerfile.fixed` que resolve conflitos de dependências.

### 4. Execute o seed (opcional)

```bash
yarn seed
```

### 5. Acesse o blog

- **Frontend**: http://localhost:2368
- **Admin**: http://localhost:2368/ghost/
- **Credenciais**: admin@clebersocial.com.br / admin123!@#

## 🌐 Deploy no Easypanel

### 1. Prepare o repositório

Certifique-se de que todos os arquivos estão commitados:

```bash
git add .
git commit -m "Deploy ready"
git push origin main
```

### 2. Configure no Easypanel

1. Acesse seu painel do Easypanel
2. Crie um novo projeto
3. Importe o repositório GitHub
4. O Easypanel detectará automaticamente o `easypanel.json`
5. Configure o domínio: `blog.clebersocial.com.br`

### 3. Variáveis de ambiente (opcional)

Se necessário, configure estas variáveis no Easypanel:

```env
NODE_ENV=production
DB_HOST=cms_ghost-db
DB_USER=mysql
DB_PASSWORD=91cf92ea3a47f6ced4f7
DB_NAME=cms
```

## ⚙️ Configurações

### Alterando a URL do blog

Edite o arquivo `ghost/core/config.production.json`:

```json
{
  "url": "https://seu-dominio.com.br"
}
```

### Alterando configurações de email

```json
{
  "mail": {
    "from": "no-reply@seudominio.com.br",
    "transport": "SMTP",
    "options": {
      "service": "Gmail",
      "auth": {
        "user": "seu-email@gmail.com",
        "pass": "sua-senha-app"
      }
    }
  }
}
```

### Alterando configurações do banco

```json
{
  "database": {
    "client": "mysql2",
    "connection": {
      "host": "seu-host-mysql",
      "user": "seu-usuario",
      "password": "sua-senha",
      "database": "seu-banco"
    }
  }
}
```

## 📁 Estrutura do Projeto

```
ghost-cms-fork/
├── ghost/core/                 # Código fonte do Ghost
│   ├── config.production.json  # Configurações de produção
│   └── package.json           # Dependências do Ghost
├── content/                    # Volume persistente (criado automaticamente)
├── docker-compose.yml         # Configuração Docker Compose
├── Dockerfile                 # Imagem Docker customizada
├── easypanel.json            # Configuração para Easypanel
├── package.json              # Dependências do projeto
├── seed.js                   # Script de inicialização
└── README.md                 # Esta documentação
```

## 🔧 Comandos Úteis

### Desenvolvimento

```bash
# Instalar dependências
yarn install

# Construir assets
yarn build

# Executar em modo desenvolvimento
yarn dev

# Executar seed
yarn seed
```

### Docker

```bash
# Construir imagem
yarn docker:build

# Subir serviços
yarn docker:run

# Ver logs
yarn docker:logs

# Acessar shell do container
yarn docker:shell

# Parar serviços
yarn docker:stop
```

### Manutenção

```bash
# Backup do banco de dados
docker-compose exec mysql mysqldump -u mysql -p91cf92ea3a47f6ced4f7 cms > backup.sql

# Restaurar backup
docker-compose exec -T mysql mysql -u mysql -p91cf92ea3a47f6ced4f7 cms < backup.sql

# Limpar volumes
docker-compose down -v
```

## 🚨 Troubleshooting

### Problema: Erro de build no Docker (conflito de dependências)

**Solução**: Use o Dockerfile.fixed que resolve conflitos de dependências:

```bash
# No easypanel.json, altere para:
"dockerfile": "Dockerfile.fixed"

# Ou teste localmente:
docker build -f Dockerfile.fixed -t ghost-cms-fork .
```

**Erro específico**: `ERESOLVE unable to resolve dependency tree` entre knex e bookshelf

### Problema: Ghost não conecta ao MySQL

**Solução**: Verifique se o MySQL está rodando e acessível:

```bash
docker-compose logs mysql
docker-compose exec mysql mysql -u mysql -p91cf92ea3a47f6ced4f7 -e "SELECT 1"
```

### Problema: Erro de permissões no volume

**Solução**: Ajuste as permissões do diretório content:

```bash
sudo chown -R 1001:1001 content/
```

### Problema: Ghost não inicia

**Solução**: Verifique os logs e configurações:

```bash
docker-compose logs ghost-fork
```

### Problema: Seed falha

**Solução**: Execute o seed após o Ghost estar rodando:

```bash
# Aguarde o Ghost inicializar completamente
sleep 30
yarn seed
```

### Problema: Dependências não instalam

**Solução**: Use npm ao invés de yarn:

```bash
# No Dockerfile, altere:
RUN npm install --production --no-optional --no-audit --no-fund
```

## 📝 Logs e Monitoramento

### Ver logs em tempo real

```bash
# Todos os serviços
docker-compose logs -f

# Apenas Ghost
docker-compose logs -f ghost-fork

# Apenas MySQL
docker-compose logs -f mysql
```

### Health Checks

Os containers incluem health checks automáticos:

- **Ghost**: Verifica endpoint `/ghost/`
- **MySQL**: Verifica conexão com `mysqladmin ping`

## 🔒 Segurança

### Alterar senhas padrão

1. **MySQL**: Altere no `docker-compose.yml` e `easypanel.json`
2. **Admin Ghost**: Altere após primeiro login
3. **SSL**: Configure HTTPS no Easypanel

### Backup regular

Configure backups automáticos do volume MySQL:

```bash
# Script de backup diário
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec mysql mysqldump -u mysql -p91cf92ea3a47f6ced4f7 cms > "backup_${DATE}.sql"
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🆘 Suporte

- **Issues**: [GitHub Issues](https://github.com/seu-usuario/ghost-cms-fork/issues)
- **Documentação Ghost**: [Ghost Docs](https://ghost.org/docs/)
- **Easypanel Docs**: [Easypanel Docs](https://easypanel.io/docs)

---

**Desenvolvido com ❤️ para o Blog Cleber Social**