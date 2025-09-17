#!/usr/bin/env node

/**
 * Script de inicialização para Ghost CMS Fork
 * Cria usuário admin inicial e post de boas-vindas
 */

const knex = require('knex');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

// Configuração do banco de dados
const dbConfig = {
  client: 'mysql2',
  connection: {
    host: process.env.DB_HOST || 'cms_ghost-db',
    user: process.env.DB_USER || 'mysql',
    password: process.env.DB_PASSWORD || '91cf92ea3a47f6ced4f7',
    database: process.env.DB_NAME || 'cms',
    charset: 'utf8mb4'
  }
};

const db = knex(dbConfig);

async function createAdminUser() {
  console.log('🔐 Criando usuário administrador...');
  
  const adminEmail = 'admin@clebersocial.com.br';
  const adminPassword = 'admin123!@#';
  const hashedPassword = await bcrypt.hash(adminPassword, 10);
  
  const userId = uuidv4();
  const userSlug = 'admin';
  
  try {
    // Verificar se já existe um usuário admin
    const existingUser = await db('users').where('email', adminEmail).first();
    
    if (existingUser) {
      console.log('✅ Usuário admin já existe');
      return existingUser.id;
    }
    
    // Criar usuário admin
    const [user] = await db('users').insert({
      id: userId,
      name: 'Administrador',
      slug: userSlug,
      email: adminEmail,
      password: hashedPassword,
      status: 'active',
      created_at: new Date(),
      updated_at: new Date()
    }).returning('id');
    
    // Criar role de Owner
    const [role] = await db('roles').insert({
      id: uuidv4(),
      name: 'Owner',
      description: 'Administrador do blog',
      created_at: new Date(),
      updated_at: new Date()
    }).returning('id');
    
    // Associar usuário ao role
    await db('users_roles').insert({
      id: uuidv4(),
      user_id: userId,
      role_id: role[0].id,
      created_at: new Date(),
      updated_at: new Date()
    });
    
    console.log('✅ Usuário admin criado com sucesso!');
    console.log(`📧 Email: ${adminEmail}`);
    console.log(`🔑 Senha: ${adminPassword}`);
    console.log('⚠️  IMPORTANTE: Altere a senha após o primeiro login!');
    
    return userId;
  } catch (error) {
    console.error('❌ Erro ao criar usuário admin:', error.message);
    throw error;
  }
}

async function createWelcomePost() {
  console.log('📝 Criando post de boas-vindas...');
  
  const postId = uuidv4();
  const postSlug = 'bem-vindo-ao-blog-cleber-social';
  
  try {
    // Verificar se já existe um post de boas-vindas
    const existingPost = await db('posts').where('slug', postSlug).first();
    
    if (existingPost) {
      console.log('✅ Post de boas-vindas já existe');
      return;
    }
    
    // Criar post de boas-vindas
    await db('posts').insert({
      id: postId,
      title: 'Bem-vindo ao Blog Cleber Social! 🎉',
      slug: postSlug,
      mobiledoc: JSON.stringify({
        version: '0.3.1',
        atoms: [],
        cards: [],
        markups: [],
        sections: [
          [1, 'p', [
            [0, [], 0, 'Olá! Seja bem-vindo ao nosso blog. Este é o primeiro post do seu novo Ghost CMS!']
          ]],
          [1, 'p', [
            [0, [], 0, 'Aqui você pode compartilhar suas ideias, experiências e conhecimentos com o mundo.']
          ]],
          [1, 'p', [
            [0, [], 0, 'Para começar:']
          ]],
          [1, 'ul', [
            [1, 'li', [
              [0, [], 0, 'Acesse o painel administrativo em /ghost/']
            ]],
            [1, 'li', [
              [0, [], 0, 'Configure suas preferências']
            ]],
            [1, 'li', [
              [0, [], 0, 'Crie seu primeiro post personalizado']
            ]],
            [1, 'li', [
              [0, [], 0, 'Personalize o tema do seu blog']
            ]]
          ]],
          [1, 'p', [
            [0, [], 0, 'Boa sorte com seu novo blog! 🚀']
          ]]
        ]
      }),
      html: '<p>Olá! Seja bem-vindo ao nosso blog. Este é o primeiro post do seu novo Ghost CMS!</p><p>Aqui você pode compartilhar suas ideias, experiências e conhecimentos com o mundo.</p><p>Para começar:</p><ul><li>Acesse o painel administrativo em /ghost/</li><li>Configure suas preferências</li><li>Crie seu primeiro post personalizado</li><li>Personalize o tema do seu blog</li></ul><p>Boa sorte com seu novo blog! 🚀</p>',
      plaintext: 'Olá! Seja bem-vindo ao nosso blog. Este é o primeiro post do seu novo Ghost CMS! Aqui você pode compartilhar suas ideias, experiências e conhecimentos com o mundo. Para começar: Acesse o painel administrativo em /ghost/, Configure suas preferências, Crie seu primeiro post personalizado, Personalize o tema do seu blog. Boa sorte com seu novo blog! 🚀',
      status: 'published',
      created_at: new Date(),
      updated_at: new Date(),
      published_at: new Date()
    });
    
    console.log('✅ Post de boas-vindas criado com sucesso!');
  } catch (error) {
    console.error('❌ Erro ao criar post de boas-vindas:', error.message);
    throw error;
  }
}

async function createDefaultSettings() {
  console.log('⚙️ Configurando configurações padrão...');
  
  try {
    const settings = [
      { key: 'title', value: 'Blog Cleber Social' },
      { key: 'description', value: 'Um blog sobre tecnologia, desenvolvimento e inovação' },
      { key: 'logo', value: '' },
      { key: 'cover_image', value: '' },
      { key: 'icon', value: '' },
      { key: 'lang', value: 'pt' },
      { key: 'timezone', value: 'America/Sao_Paulo' },
      { key: 'codeinjection_head', value: '' },
      { key: 'codeinjection_foot', value: '' },
      { key: 'navigation', value: JSON.stringify([
        { label: 'Home', url: '/' },
        { label: 'Sobre', url: '/sobre/' }
      ]) },
      { key: 'secondary_navigation', value: JSON.stringify([]) },
      { key: 'meta_title', value: 'Blog Cleber Social' },
      { key: 'meta_description', value: 'Um blog sobre tecnologia, desenvolvimento e inovação' },
      { key: 'og_image', value: '' },
      { key: 'og_title', value: 'Blog Cleber Social' },
      { key: 'og_description', value: 'Um blog sobre tecnologia, desenvolvimento e inovação' },
      { key: 'twitter_image', value: '' },
      { key: 'twitter_title', value: 'Blog Cleber Social' },
      { key: 'twitter_description', value: 'Um blog sobre tecnologia, desenvolvimento e inovação' }
    ];
    
    for (const setting of settings) {
      await db('settings').insert({
        id: uuidv4(),
        key: setting.key,
        value: setting.value,
        type: 'blog',
        created_at: new Date(),
        updated_at: new Date()
      }).onConflict('key').merge();
    }
    
    console.log('✅ Configurações padrão aplicadas!');
  } catch (error) {
    console.error('❌ Erro ao configurar settings:', error.message);
    throw error;
  }
}

async function main() {
  console.log('🚀 Iniciando seed do Ghost CMS Fork...\n');
  
  try {
    // Aguardar conexão com o banco
    await db.raw('SELECT 1');
    console.log('✅ Conexão com banco de dados estabelecida\n');
    
    // Executar seed
    await createDefaultSettings();
    await createAdminUser();
    await createWelcomePost();
    
    console.log('\n🎉 Seed concluído com sucesso!');
    console.log('\n📋 Próximos passos:');
    console.log('1. Acesse https://blog.clebersocial.com.br/ghost/');
    console.log('2. Faça login com: admin@clebersocial.com.br / admin123!@#');
    console.log('3. Altere a senha padrão');
    console.log('4. Configure suas preferências');
    console.log('5. Comece a criar conteúdo!');
    
  } catch (error) {
    console.error('\n❌ Erro durante o seed:', error.message);
    process.exit(1);
  } finally {
    await db.destroy();
  }
}

// Executar apenas se chamado diretamente
if (require.main === module) {
  main();
}

module.exports = { createAdminUser, createWelcomePost, createDefaultSettings };
