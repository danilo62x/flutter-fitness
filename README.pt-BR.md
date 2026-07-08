# Flutter Fitness

[Read in English](./README.md)

[![Licença: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE) ![Grátis](https://img.shields.io/badge/price-free-brightgreen)

Flutter Fitness é um template gratuito de treino e atividade física construído com Flutter 3.44 e Material 3. São 8 telas com tema claro e escuro: início com anel de meta diária e estatísticas de atividade, detalhe do treino com a lista de exercícios, player de exercício com timer circular, tela de progresso com gráficos de linha e conquistas, planos de treino por nível, tela de nutrição com macros e consumo de água, perfil e ranking com pódio. Os gráficos e anéis são desenhados com CustomPaint, sem pacote de gráficos. Todos os dados são mocks locais, então o app roda sem backend, e os serviços http indicam onde uma API real entraria. Faz parte da faixa gratuita do catálogo [template.dev.br](https://template.dev.br).

## Telas

8 telas mais um shell de abas (`lib/ui/core/widgets/main_shell.dart`):

- Início (`home_screen.dart`): anel de meta diária, estatísticas de atividade e treinos do dia.
- Treino (`workout_detail_screen.dart`): detalhe do treino com a lista de exercícios.
- Exercício (`exercise_player_screen.dart`): player de exercício com timer circular de contagem regressiva.
- Progresso (`progress_screen.dart`): gráficos de linha das métricas ao longo do tempo e conquistas.
- Planos (`plans_screen.dart`): planos de treino agrupados por nível.
- Nutrição (`nutrition_screen.dart`): macros diários, refeições e controle de água.
- Perfil (`profile_screen.dart`): dados do usuário e configurações.
- Ranking (`ranking_screen.dart`): placar com pódio.

### Capturas de tela

A pasta `screenshots/` tem 16 capturas. Uma amostra:

![Início](screenshots/fitness.png)
![Treino](screenshots/fitness-2.png)
![Exercício](screenshots/fitness-3.png)
![Progresso](screenshots/fitness-4.png)
![Planos](screenshots/fitness-5.png)
![Nutrição](screenshots/fitness-6.png)

## Stack

- Flutter 3.44, canal stable (fixado via FVM no `.fvmrc`)
- Dart SDK `^3.12.2`
- Material 3 (`useMaterial3: true`, `ColorScheme.fromSeed`)
- go_router `^17.3.0`: navegação declarativa
- provider `^6.1.5+1`: gerenciamento de estado (view models MVVM)
- http `^1.6.0`: camada de serviços de API
- intl `^0.20.3`: formatação de números e datas
- cupertino_icons `^1.0.8`
- flutter_lints `^6.0.0` (dev)

As versões exatas resolvidas estão no `pubspec.lock`. Plataformas incluídas no repositório: Android, iOS, web e Windows.

## Requisitos

- Flutter SDK, canal stable. O lockfile exige Flutter 3.38 ou mais novo; o template foi construído com a 3.44.
- Dart 3.12.2 ou mais novo (vem junto com o Flutter SDK).
- Ferramentas da plataforma alvo: Android Studio e Android SDK, Xcode para iOS, Chrome para web, ou Visual Studio com o workload de C++ para Windows.
- Opcional: [FVM](https://fvm.app). O repositório tem um `.fvmrc` fixando o canal stable, então `fvm use` seleciona um SDK compatível.

## Como rodar

```bash
flutter pub get
flutter run
```

Escolha o dispositivo com `flutter run -d chrome` (web), `flutter run -d windows`, ou um id listado em `flutter devices`.

Builds de release:

```bash
flutter build apk       # Android
flutter build ipa       # iOS (exige macOS e Xcode)
flutter build web       # Web
flutter build windows   # Windows
```

Com FVM, prefixe os comandos: `fvm flutter pub get`, `fvm flutter run`. Rode os testes de widget com `flutter test`.

## Estrutura do projeto

```
lib/
  main.dart               # ponto de entrada
  app.dart                # MaterialApp.router, temas claro/escuro
  core/
    app_repositories.dart # raiz de composição: monta o grafo de repositórios
    router.dart           # tabela de rotas do go_router
    theme.dart            # tema Material 3 (cor seed, temas de componentes)
  data/
    models/               # modelos de API com fromJson/toJson
    repositories/         # treino, plano, progresso, nutrição, perfil, ranking
    services/             # stubs de serviço de API com http
  domain/
    models/               # Workout, Exercise, TrainingPlan, NutritionDay, Meal,
                          # Macro, MetricSeries, Achievement, RankedUser, UserProfile
  ui/
    core/widgets/         # widgets compartilhados, gráficos em CustomPaint, shell de abas
    features/<feature>/   # views/ (telas) e view_models/ por funcionalidade
```

## Tema e personalização

O tema fica em `lib/core/theme.dart`. Os esquemas claro e escuro são gerados a partir de uma única cor seed:

```dart
static const Color seed = Color(0xFF16A34A); // verde
```

Troque `seed` para mudar a cara do app inteiro: `ColorScheme.fromSeed` deriva todas as cores de superfície e destaque para os dois brilhos. A família de fonte é Roboto, definida no mesmo arquivo, junto com temas de componentes para app bar, botões preenchidos e cards (cantos arredondados, elevação zero). O `app.dart` passa `AppTheme.light()` e `AppTheme.dark()` para o `MaterialApp.router`, então o app segue o tema do sistema. Os anéis de meta e gráficos de linha em `lib/ui/core/widgets/charts.dart` pegam as cores do `ColorScheme` ativo, então também acompanham a seed.

## Gerenciamento de estado

MVVM com provider. Cada tela tem um view model `ChangeNotifier` em `lib/ui/features/<feature>/view_models/`, provido via `ChangeNotifierProvider` em `lib/core/router.dart` e no shell de abas. Os repositórios são montados uma vez em `lib/core/app_repositories.dart` (raiz de composição) e compartilhados com o router e o shell; eles retornam dados mock através dos serviços em `lib/data/services/`.

## Apoie o projeto

Este template é gratuito e tem licença MIT. As doações mantêm os templates gratuitos atualizados a cada versão nova do Flutter: https://template.dev.br/doar?template=flutter-fitness

## Mais templates

O catálogo completo, com templates grátis e premium, está em https://template.dev.br.

## Licença

[MIT](./LICENSE), © 2026 Danilo Quinelato.
