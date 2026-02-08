📖 Palavra Viva - App Bíblico com IA
Palavra Viva é um aplicativo móvel desenvolvido em Flutter que oferece uma experiência moderna de leitura bíblica. O grande diferencial do projeto é a integração com a Inteligência Artificial da OpenAI, transformando qualquer capítulo da Bíblia em um audiobook narrado com voz natural e humana.

✨ Funcionalidades
Versículo do Dia: Exibe um versículo diário com cache local (funciona offline após o primeiro carregamento).

Bíblia em Áudio (IA): Integração com a API OpenAI TTS (Text-to-Speech) para narrar capítulos inteiros com alta fidelidade.

Bíblia Completa: Navegação intuitiva entre os 66 livros e seus capítulos.

Design Moderno: Interface limpa, com grade de livros colorida dinamicamente.

Leitura Focada: Modo de leitura sem distrações com navegação facilitada entre capítulos.

Multilíngue (Texto): Suporte para alternar entre versões (PT-BR e EN).

🛠️ Tecnologias Utilizadas
Frontend: Flutter & Dart

Arquitetura: Clean Architecture (separação de Repositories, Models e UI)

APIs:

ABibliaDigital (Fonte dos textos bíblicos)

OpenAI API (Geração de áudio - Modelo TTS-1)

Gerenciamento de Estado: setState nativo otimizado.

Armazenamento Local: shared_preferences para cache de dados.

HTTP: Pacote http para requisições REST.
