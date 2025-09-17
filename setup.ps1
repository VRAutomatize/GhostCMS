# Script de setup para Ghost CMS Fork (PowerShell)
# Configura o ambiente completo para desenvolvimento e produção

param(
    [switch]$SkipSeed
)

# Configurar cores para output
$Host.UI.RawUI.ForegroundColor = "White"

function Write-Info {
    param($Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param($Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param($Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Configurando Ghost CMS Fork..." -ForegroundColor Blue

# Verificar se Docker está instalado
try {
    docker --version | Out-Null
    Write-Info "Docker encontrado"
} catch {
    Write-Error "Docker não está instalado. Por favor, instale o Docker Desktop primeiro."
}

# Verificar se Docker Compose está instalado
try {
    docker-compose --version | Out-Null
    Write-Info "Docker Compose encontrado"
} catch {
    Write-Error "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
}

# Verificar se Node.js está instalado
$NodeAvailable = $false
try {
    node --version | Out-Null
    Write-Info "Node.js encontrado"
    $NodeAvailable = $true
} catch {
    Write-Warning "Node.js não está instalado. Instalando dependências apenas via Docker..."
}

# Verificar se Yarn está instalado
if ($NodeAvailable) {
    try {
        yarn --version | Out-Null
        Write-Info "Yarn encontrado"
    } catch {
        Write-Warning "Yarn não está instalado. Instalando..."
        npm install -g yarn
    }
}

Write-Info "Criando diretório de conteúdo..."
if (!(Test-Path "content")) {
    New-Item -ItemType Directory -Path "content" | Out-Null
}

Write-Info "Construindo imagem Docker..."
docker build -t ghost-cms-fork .

if ($LASTEXITCODE -ne 0) {
    Write-Error "Falha ao construir a imagem Docker"
}

Write-Info "Subindo serviços..."
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Error "Falha ao iniciar os serviços"
}

Write-Info "Aguardando serviços iniciarem..."
Start-Sleep -Seconds 30

# Verificar se os serviços estão rodando
$Services = docker-compose ps --services
$RunningServices = docker-compose ps --services --filter "status=running"

if ($RunningServices.Count -eq 0) {
    Write-Error "Falha ao iniciar os serviços. Verifique os logs com: docker-compose logs"
}

Write-Info "Verificando saúde dos serviços..."
Start-Sleep -Seconds 10

# Verificar MySQL
try {
    docker-compose exec mysql mysqladmin ping -h localhost -u mysql -p91cf92ea3a47f6ced4f7 --silent
    Write-Info "✅ MySQL está rodando"
} catch {
    Write-Warning "⚠️ MySQL pode não estar totalmente pronto ainda"
}

# Verificar Ghost
try {
    $Response = Invoke-WebRequest -Uri "http://localhost:2368/ghost/" -UseBasicParsing -TimeoutSec 5
    Write-Info "✅ Ghost está rodando"
} catch {
    Write-Warning "⚠️ Ghost pode não estar totalmente pronto ainda"
}

# Executar seed se solicitado
if (!$SkipSeed -and $NodeAvailable) {
    Write-Info "Executando seed..."
    try {
        yarn install
        node seed.js
        Write-Info "✅ Seed executado com sucesso"
    } catch {
        Write-Warning "Seed falhou ou já foi executado"
    }
} elseif (!$SkipSeed) {
    Write-Warning "Seed não executado - Node.js não disponível localmente"
}

Write-Host ""
Write-Host "🎉 Setup concluído!" -ForegroundColor Blue
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Green
Write-Host "1. Acesse: http://localhost:2368"
Write-Host "2. Admin: http://localhost:2368/ghost/"
Write-Host "3. Login: admin@clebersocial.com.br / admin123!@#"
Write-Host ""
Write-Host "🔧 Comandos úteis:" -ForegroundColor Green
Write-Host "• Ver logs: docker-compose logs -f"
Write-Host "• Parar: docker-compose down"
Write-Host "• Reiniciar: docker-compose restart"
Write-Host "• Shell: docker-compose exec ghost-fork /bin/bash"
Write-Host ""
Write-Host "📚 Para deploy no Easypanel:" -ForegroundColor Green
Write-Host "1. Commit e push do código"
Write-Host "2. Importe o repositório no Easypanel"
Write-Host "3. Configure o domínio: blog.clebersocial.com.br"
Write-Host ""
Write-Host "⚠️ IMPORTANTE: Altere a senha padrão após o primeiro login!" -ForegroundColor Yellow
