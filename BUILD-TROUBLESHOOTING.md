# 🔧 Solução de Problemas de Build - Ghost CMS Fork

## 🚨 Problemas Comuns e Soluções

### 1. Erro: `@tryghost/i18n@0.0.0 is not in this registry`

**Causa**: Dependência interna do Ghost não publicada no npm

**Solução**: Use `Dockerfile.minimal`
```bash
# No easypanel.json:
"dockerfile": "Dockerfile.minimal"
```

### 2. Erro: `ERESOLVE unable to resolve dependency tree`

**Causa**: Conflito entre versões de knex e bookshelf

**Solução**: Use `Dockerfile.fixed`
```bash
# No easypanel.json:
"dockerfile": "Dockerfile.fixed"
```

### 3. Erro: `yarn install --frozen-lockfile` failed

**Causa**: yarn.lock não encontrado ou incompatível

**Solução**: Use `Dockerfile.yarn`
```bash
# No easypanel.json:
"dockerfile": "Dockerfile.yarn"
```

### 4. Erro: Build muito lento ou timeout

**Causa**: Instalação de muitas dependências

**Solução**: Use `Dockerfile.official`
```bash
# No easypanel.json:
"dockerfile": "Dockerfile.official"
```

## 📋 Ordem de Prioridade dos Dockerfiles

1. **`Dockerfile.minimal`** - Mais estável, ignora dependências problemáticas
2. **`Dockerfile.official`** - Baseado na imagem oficial do Ghost
3. **`Dockerfile.yarn`** - Usa Yarn (mais compatível com Ghost)
4. **`Dockerfile.fixed`** - Resolve conflitos de dependências
5. **`Dockerfile.robust`** - Versão robusta com otimizações
6. **`Dockerfile.simple`** - Versão simplificada

## 🔄 Como Trocar de Dockerfile no Easypanel

1. **Edite o `easypanel.json`**:
   ```json
   {
     "source": {
       "type": "dockerfile",
       "dockerfile": "Dockerfile.minimal"
     }
   }
   ```

2. **Commit e push**:
   ```bash
   git add easypanel.json
   git commit -m "Switch to Dockerfile.minimal"
   git push origin main
   ```

3. **Force redeploy** no Easypanel

## 🧪 Teste Local

Para testar um Dockerfile localmente:

```bash
# Teste o Dockerfile.minimal
docker build -f Dockerfile.minimal -t ghost-test .

# Teste o Dockerfile.official
docker build -f Dockerfile.official -t ghost-test .

# Teste o Dockerfile.yarn
docker build -f Dockerfile.yarn -t ghost-test .
```

## 📊 Comparação dos Dockerfiles

| Dockerfile | Tamanho | Velocidade | Estabilidade | Compatibilidade |
|------------|---------|------------|--------------|-----------------|
| minimal | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| official | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| yarn | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| fixed | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| robust | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| simple | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

## 🎯 Recomendação Final

**Para Easypanel**: Use `Dockerfile.minimal`
- ✅ Mais estável
- ✅ Ignora dependências problemáticas
- ✅ Build mais rápido
- ✅ Menor chance de erro

**Para desenvolvimento local**: Use `Dockerfile.yarn`
- ✅ Mais compatível com Ghost
- ✅ Usa Yarn como o Ghost original
- ✅ Melhor para desenvolvimento

---

**💡 Dica**: Se um Dockerfile falhar, tente o próximo na lista de prioridade!
