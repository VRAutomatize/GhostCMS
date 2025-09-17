# 🚀 Deploy no Easypanel - Ghost CMS Fork

## ⚡ Deploy Rápido

### 1. Preparar o Repositório
```bash
# Commit todas as mudanças
git add .
git commit -m "Deploy ready for Easypanel"
git push origin main
```

### 2. Configurar no Easypanel

1. **Acesse seu painel Easypanel**
2. **Crie novo projeto**: "Ghost CMS Fork"
3. **Importe repositório**: Cole a URL do seu GitHub
4. **Configure domínio**: `blog.clebersocial.com.br`
5. **Deploy automático**: O Easypanel detectará o `easypanel.json`

## 🔧 Configurações Importantes

### Dockerfile Recomendado
O `easypanel.json` já está configurado para usar o `Dockerfile.simple` que é mais estável:

```json
{
  "source": {
    "type": "dockerfile",
    "dockerfile": "Dockerfile.simple"
  }
}
```

### Variáveis de Ambiente (Opcional)
Se necessário, configure no Easypanel:

```env
NODE_ENV=production
DB_HOST=cms_ghost-db
DB_USER=mysql
DB_PASSWORD=91cf92ea3a47f6ced4f7
DB_NAME=cms
```

## 🚨 Solução de Problemas

### Erro de Build
Se o build falhar, altere no `easypanel.json`:

```json
{
  "source": {
    "type": "dockerfile",
    "dockerfile": "Dockerfile.robust"
  }
}
```

### Erro de Dependências
Use o `Dockerfile.simple` que usa npm ao invés de yarn:

```dockerfile
RUN npm install --production --no-optional --no-audit --no-fund
```

### Erro de Permissões
O Dockerfile já está configurado com usuário não-root:

```dockerfile
USER ghost
```

## 📋 Checklist de Deploy

- [ ] Repositório commitado e pushed
- [ ] Domínio configurado: `blog.clebersocial.com.br`
- [ ] MySQL configurado com senha segura
- [ ] Volume persistente configurado
- [ ] Health checks funcionando
- [ ] SSL/HTTPS configurado

## 🔒 Segurança

### Alterar Senhas Padrão
1. **MySQL**: Altere em `easypanel.json` e `docker-compose.yml`
2. **Ghost Admin**: Altere após primeiro login
3. **SSL**: Configure HTTPS no Easypanel

### Backup
Configure backup automático do volume MySQL no Easypanel.

## 📊 Monitoramento

### Health Checks
Os containers incluem health checks automáticos:

- **Ghost**: `http://localhost:2368/ghost/`
- **MySQL**: `mysqladmin ping`

### Logs
Acesse logs no painel Easypanel ou via CLI:

```bash
easypanel logs ghost-fork
easypanel logs mysql
```

## 🎯 Próximos Passos

1. **Deploy**: Aguarde o build completar
2. **Acesse**: https://blog.clebersocial.com.br/ghost/
3. **Login**: admin@clebersocial.com.br / admin123!@#
4. **Configure**: Altere senha e configurações
5. **Personalize**: Configure tema e conteúdo

## 📞 Suporte

- **Easypanel Docs**: [docs.easypanel.io](https://docs.easypanel.io)
- **Ghost Docs**: [ghost.org/docs](https://ghost.org/docs)
- **Issues**: [GitHub Issues](https://github.com/seu-usuario/ghost-cms-fork/issues)

---

**🎉 Seu Ghost CMS estará rodando em produção!**
