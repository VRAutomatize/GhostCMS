# 🚀 Quick Start - Ghost CMS Fork

## ⚡ Início Rápido (5 minutos)

### 1. Clone e Configure
```bash
git clone https://github.com/seu-usuario/ghost-cms-fork.git
cd ghost-cms-fork
```

### 2. Execute Setup Automático

**Linux/Mac:**
```bash
./setup.sh
```

**Windows:**
```powershell
.\setup.ps1
```

### 3. Acesse seu Blog
- **Frontend**: http://localhost:2368
- **Admin**: http://localhost:2368/ghost/
- **Login**: admin@clebersocial.com.br / admin123!@#

## 🐳 Comandos Docker Essenciais

```bash
# Subir serviços
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar serviços
docker-compose down

# Reiniciar
docker-compose restart
```

## 🌐 Deploy no Easypanel

1. **Push do código**:
   ```bash
   git add .
   git commit -m "Deploy ready"
   git push origin main
   ```

2. **No Easypanel**:
   - Importe o repositório
   - Configure domínio: `blog.clebersocial.com.br`
   - Deploy automático via `easypanel.json`

## ⚙️ Configurações Importantes

### Alterar URL do Blog
Edite `ghost/core/config.production.json`:
```json
{
  "url": "https://seu-dominio.com.br"
}
```

### Alterar Senha MySQL
Edite em 3 lugares:
- `docker-compose.yml`
- `easypanel.json` 
- `ghost/core/config.production.json`

### Configurar Email
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

## 🔧 Troubleshooting

### Erro de build no Docker (conflito de dependências)
```bash
# Use o Dockerfile.fixed (resolve conflitos)
docker build -f Dockerfile.fixed -t ghost-cms-fork .

# No Easypanel, altere easypanel.json:
"dockerfile": "Dockerfile.fixed"
```

### Ghost não conecta ao MySQL
```bash
docker-compose logs mysql
docker-compose exec mysql mysql -u mysql -p91cf92ea3a47f6ced4f7 -e "SELECT 1"
```

### Erro de permissões
```bash
sudo chown -R 1001:1001 content/
```

### Reset completo
```bash
docker-compose down -v
docker-compose up -d
```

## 📞 Suporte

- **Issues**: [GitHub Issues](https://github.com/seu-usuario/ghost-cms-fork/issues)
- **Docs**: [README.md](README.md)

---

**🎉 Pronto! Seu Ghost CMS está rodando!**
