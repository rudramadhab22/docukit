# DocuKit

One Flutter application for document-related operations: convert, merge, split,
compress, secure, and inspect PDFs.

## Architecture

GetX + clean layering for loose coupling:

```text
lib/
  app/           # App shell, routes, theme, initial DI
  core/          # Constants, errors, Result helpers
  domain/        # Entities + repository contracts (no Flutter plugins)
  data/          # Repository implementations + datasources
  presentation/  # GetX modules (bindings / controllers / views)
```

- **Presentation** depends on domain contracts only.
- **Data** implements those contracts; engines can be swapped later.
- **GetX** handles routing, bindings, and reactive state.
- Feature tools are registered in `ToolCatalogService` and opened via a
  shared workspace until their phase is implemented.

## Delivery phases

1. Foundation
2. Core PDF utilities + metadata (pick, preview, inspect)
3. Conversions (Word→PDF, PDF→Images, Images→PDF)
4. Structure tools (merge / split / extract)
5. Edit & optimize (compress / rotate / watermark)
6. Security (protect / unlock)
7. Polish & ship

## Run

```bash
flutter pub get
flutter run
```
