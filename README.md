# MDGym

Registro de treinos de academia, escuro e **offline**. Escolha os músculos num
mapa corporal, registre suas séries e acompanhe a evolução.

Este repositório é um **fork web** do [GymMane](https://github.com/InlitX/GymMane)
(app Android em Flutter, GPLv3), adaptado para rodar no navegador e publicado
na Vercel.

---

## Precisa de banco de dados? Não.

O app é offline por natureza — foi desenhado assim no projeto original. **Não há
backend, conta de usuário, API key nem variável de ambiente.** Tudo o que você
registra fica no próprio navegador:

| O que | Onde fica na web |
| --- | --- |
| Perfil, treinos, séries, rotinas, recordes, medidas | `localStorage` (via `shared_preferences`) |
| Preferências e tema | `localStorage` |

Consequências práticas, importantes para um protótipo:

- Os dados são **por navegador e por dispositivo**. Abrir em outro aparelho
  começa do zero, e limpar os dados do site apaga o histórico.
- Não há sincronização entre dispositivos — isso exigiria, aí sim, um backend.

## Rodando localmente

Requer o [Flutter](https://docs.flutter.dev/get-started/install) (canal `stable`).

```bash
flutter pub get
flutter run -d chrome          # desenvolvimento
flutter build web --release    # gera build/web
```

## Deploy na Vercel

O repositório já vem configurado — basta importar o projeto na Vercel e dar
deploy. Não há nada a preencher em *Environment Variables*.

O que está pronto:

- **`vercel.json`** — aponta a saída para `build/web`, com cache longo para
  assets e sem cache para `index.html`.
- **`tool-web/vercel-build.sh`** — a imagem de build da Vercel não tem Flutter,
  então o script baixa o SDK (`stable`) e roda `flutter build web --release`.

O primeiro build leva alguns minutos, pois inclui o download do SDK.

> Se preferir não buildar na Vercel, rode `flutter build web --release`
> localmente e publique a pasta `build/web` como site estático.

## O que muda na web

O app nasceu para Android e usa recursos que o navegador não oferece. Nada disso
quebra a aplicação — o código já trata as falhas e segue funcionando —, mas
estes pontos ficam inativos no navegador:

| Recurso | Status na web |
| --- | --- |
| Registrar treinos, séries, rotinas, progresso, medidas, conquistas | ✅ funciona |
| Mapa corporal, catálogo de exercícios e ilustrações | ✅ funciona |
| Cronômetro de descanso dentro do app | ✅ funciona |
| Notificações e lembretes agendados | ❌ indisponível (`zonedSchedule` não existe na web) |
| Alarme de descanso tocando em segundo plano | ❌ indisponível |
| Widgets de tela inicial | ❌ exclusivo do Android |
| Importar/exportar backup e mídia em arquivos locais | ⚠️ limitado (depende do sistema de arquivos) |

A interface é desenhada para telas de celular. Em janelas largas o app é
centralizado numa coluna com largura de celular — sem isso, o mapa corporal
estica e os botões abaixo dele saem da tela.

## Diferenças em relação ao projeto original

- Renomeado de GymMane para MDGym (incluindo o pacote `com.mdgym.app`).
- Adicionada a plataforma web (`web/`), com splash de carregamento, ícones e
  manifesto próprios.
- `assets/shaders/medal.frag`: `fwidth()` não existe no SkSL compilado para web.
  Como `uv` é linear em `fragCoord`, a derivada foi substituída pelo seu
  equivalente analítico — mesmo resultado, em todas as plataformas.
- O app é limitado à largura de um celular quando roda no navegador.
- Configuração de deploy na Vercel.

## Licença e créditos

Trabalho derivado do [GymMane](https://github.com/InlitX/GymMane), de
[InlitX](https://github.com/InlitX).

- Código: **GPLv3** — veja [LICENSE](LICENSE).
- Ilustrações dos exercícios: **CC BY-SA 4.0** — veja [CREDITS.md](CREDITS.md)
  para a cadeia completa de atribuição (Workout Guide, Everkinetic) e as fontes.

O README original, em inglês, está em
[docs/readme/README.upstream-en.md](docs/readme/README.upstream-en.md).
