# Atalhos de filiais — Flutter Design System V2

Componente Flutter reutilizável para exibir filiais e oferecer ações individuais ou em lote de adicionar e remover. A V2 aprimora elegibilidade das ações, semântica acessível, foco por teclado, fidelidade visual à referência e cobertura de testes, mantendo a demonstração e a API controlada pelo componente pai.

## Objetivo técnico

Transformar uma exportação visual do Figma em um componente de interface sustentável: separar dados, apresentação e estado demonstrativo; oferecer callbacks tipados; e preservar os principais atributos visuais da referência sem manter o código gerado como arquitetura.

## Tecnologias

- Flutter e Dart (SDK `>=3.3.0 <4.0.0`)
- Material 3
- `ThemeExtension` para tokens visuais
- `flutter_test` e widget tests
- `flutter_lints`

## Estrutura

```text
lib/
  branch_shortcuts.dart
  main.dart
  src/
    component/
      branch_shortcuts_dropdown.dart
    demo/
      branch_shortcuts_demo.dart
    model/
      branch_shortcut.dart
    theme/
      design_system_theme.dart
      shortcut_tokens.dart
test/
  branch_shortcuts_dropdown_test.dart
reference/
  figma_export.txt
  atalhos-figma.png.png
```

## Decisões de arquitetura

- `BranchShortcutsDropdown` é uma composição de apresentação sem estado interno de negócio. A lista, os identificadores selecionados e as ações são recebidos do pai.
- `BranchShortcut` é um modelo imutável de dados de exibição; `BranchAction` e `BranchShortcutVariant` definem ações e variantes com tipos explícitos.
- `BranchShortcutsDemo` mantém o estado local apenas para ilustrar o fluxo controlado e fornece os dados de exemplo.
- A elegibilidade individual é derivada de `selectedBranchIds`: adicionar só fica disponível para uma filial não selecionada; remover, apenas para uma selecionada. Os callbacks tipados comunicam intenções e o pai continua sendo responsável por modificar o estado de negócio.
- A elegibilidade coletiva considera somente as filiais exibidas: adicionar todas fica indisponível quando todas já estão selecionadas; remover todas, quando nenhuma está selecionada. Listas vazias e `enabled` continuam respeitados.
- Os botões Material 3 mantêm interação por teclado e estados visuais desabilitados. O tema aplica contorno de foco visível, e os rótulos semânticos identificam ação e filial sem repetir o texto visível. A informação da filial comunica seu estado de seleção à tecnologia assistiva.
- O painel se adapta à largura disponível, permite que o texto da filial encolha sem overflow e possui estado vazio.
- A referência em `reference/` foi consultada para alinhamento, espaçamento, tipografia, formato dos botões, borda, raio e sombras. O painel preserva sua apresentação aberta, pois a imagem não define interação de abertura/fechamento. O rosa das ações permanece `#D92F55` (em vez do rosa de referência `#F24166`) para melhorar o contraste do texto branco; a família Effra Trial não foi incluída e a tipografia usa as fontes do tema Flutter.

O nome “dropdown” acompanha a nomenclatura da tarefa. A referência disponibilizada representa um painel com as opções já visíveis; portanto, a implementação não adiciona um controle de abrir/fechar nem uma camada overlay que não esteja demonstrada.

## Atomic Design aplicado

- **Átomo:** botões Material 3 e textos são reutilizados diretamente, sem criar wrappers artificiais.
- **Molécula:** `_BranchShortcutRow` compõe os dados de uma filial, seu estado e ação.
- **Organismo:** `BranchShortcutsDropdown` organiza cabeçalho, lista, estado vazio e ação coletiva.
- **Demonstração:** fica fora do componente reutilizável e coordena o estado de exemplo.

## Tema e tokens

`DesignSystemTheme.light()` configura Material 3 e instala `ShortcutTokens`, uma `ThemeExtension` que centraliza cores de superfície, texto, borda, estado desabilitado, espaçamentos e raio. As sombras do cartão também são definidas uma única vez junto aos tokens. `ShortcutTokens.of(context)` fornece os valores de referência quando o widget é usado em um tema sem a extensão. Os controles Material gerenciam interação, dimensionamento do texto e estados nativos; o tema complementa esse comportamento com uma borda de foco.

## API pública

| API | Descrição |
| --- | --- |
| `BranchShortcutsDropdown` | Painel reutilizável de ações de filiais. |
| `BranchShortcut` | Dados imutáveis: `id`, `name` e `customerCount`. |
| `BranchShortcutVariant.add / .remove` | Variante e rótulos correspondentes. |
| `BranchAction.add / .remove` | Ação reportada ao componente pai. |
| `branches` | Lista de filiais recebida externamente. |
| `selectedBranchIds` | IDs das filiais que o pai informa como adicionadas. |
| `onBranchAction(branch, action)` | Callback tipado de ação individual. |
| `onBulkAction(action)` | Callback tipado de ação coletiva. |
| `enabled` | Desabilita os botões individuais e coletivo. |

### Exemplo

```dart
import 'package:branch_shortcuts_design_system/branch_shortcuts.dart';

BranchShortcutsDropdown(
  variant: BranchShortcutVariant.add,
  branches: const [
    BranchShortcut(id: 'sp', name: 'São Paulo', customerCount: 152),
  ],
  selectedBranchIds: const {'sp'},
  onBranchAction: (branch, action) {
    // Atualize o estado no componente pai.
  },
  onBulkAction: (action) {
    // Aplique a ação ao conjunto no componente pai.
  },
)
```

O componente comunica as intenções por callbacks e não define como adicionar/remover uma filial em qualquer domínio específico.

## Executar

Com Flutter instalado:

```bash
flutter pub get
flutter run -d chrome
```

## Testes e análise

```bash
dart format .
flutter analyze
flutter test
```

Os testes de widget existentes foram mantidos e ampliados para cobrir a elegibilidade de ações individuais e coletivas, listas vazias, callbacks, rótulos e estado semântico de seleção, foco e escala de texto ampliada. Os resultados executados nesta revisão estão registrados abaixo:

- `dart format .`: concluído; 8 arquivos Dart verificados, sem alterações pendentes de formatação.
- `flutter analyze`: concluído sem problemas.
- `flutter test`: 15 testes aprovados (os 7 testes anteriores e 8 novos casos).

## Limitações conhecidas

- A tipografia Effra Trial da arte original não está incluída; utiliza-se a tipografia padrão do sistema.
- O painel não abre ou fecha: a imagem de referência apresenta diretamente a lista.
- A demonstração mantém o estado apenas em memória e não persiste alterações.
- A cor da ação difere da referência para favorecer o contraste do rótulo branco; ainda é recomendável validar contraste em cada combinação de tema e acessibilidade adotada pelo produto.
- Os rótulos e mensagens da demonstração estão em português fixo; localização configurável não faz parte da API atual.

## Possíveis evoluções

- Adicionar localização configurável para os rótulos.
- Integrar uma fonte tipográfica licenciada fornecida pelo projeto.
- Criar uma variante overlay/expansível caso esse comportamento seja definido no design.
- Ampliar a validação com leitores de tela reais, tema escuro e testes visuais comparativos com a referência.
