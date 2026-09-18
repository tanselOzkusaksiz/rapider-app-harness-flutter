# Rapider Flutter/Dart Isolated Pages POC - Implementation Plan

This implementation plan covers how to introduce the ability to generate isolated Flutter/Dart pages while retaining the current HTML page generation. This allows the AI to continue fast generation to CDN using HTML when appropriate, while gradually introducing Dart support for robust web/mobile deployments.

## 1. Goal & Strategy
Build a dual-target AI page generation architecture where a page can be either HTML or a Dart package. 
* **HTML Pages** remain as they are: deployed to a CDN and loaded directly in the Angular iframe.
* **Dart Pages** are generated as separate Dart packages, compiled to Flutter Web to run in the Angular iframe, and also natively bundled into iOS and Android applications.

## 2. Architecture Additions

### 2.1 Monorepo Setup for Dart
We will create a new directory (e.g., `rapider-flutter`) alongside the existing `rapider-ui` and `rapider-server`.
```text
rapider-flutter/
├── packages/
│   ├── rapider_sdk/            # The common bridge SDK
│   ├── rapider_ui/             # Reusable AI-friendly widgets
│   └── rapider_page_contract/  # Page metadata and builder interface
├── pages/
│   └── (Generated Dart page packages go here, e.g., customers, dashboard)
├── runners/
│   └── web_page_runner/        # Generic runner to compile single page for Flutter Web
├── apps/
│   └── mobile_wrapper/         # Host app that imports all Dart pages for iOS/Android
└── scripts/
    └── build_pipeline.sh
```

### 2.2 Dual Manifest Support
We will update `app.manifest.json` to handle multiple page types. The Angular shell will read this to determine what URL to load in the iframe.

```json
{
  "pages": [
    {
      "name": "dashboard",
      "type": "html",
      "version": "12",
      "entry": "/apps/crm/v12/pages/dashboard/dashboard.html"
    },
    {
      "name": "customers",
      "type": "flutter-web",
      "version": "17",
      "entry": "/apps/crm/v17/pages/customers/index.html"
    }
  ]
}
```

### 2.3 SDK Implementation
To keep pages isolated from the host (Angular iframe or Native Mobile):
1. **`rapider_page_contract`**: Pages export a `RapiderPageDefinition` builder.
2. **`rapider_sdk`**: Pages use `rapider.data.list(...)` or `rapider.navigation.navigate(...)`.
3. **Web Adapter (`RapiderWebSDK`)**: Implemented in `web_page_runner`. Translates SDK calls into `window.parent.postMessage(...)` to talk to the Angular shell (acting identically to `window.rapiderApi` in HTML).
4. **Mobile Adapter (`RapiderMobileSDK`)**: Implemented in `mobile_wrapper`. Uses native Flutter navigation and directly calls Rapider backend APIs (via standard REST/GraphQL).

## 3. AI Generation Pipeline
The AI Generator will have completely separate prompts, functions, and rules for `html` versus `dart` generation to ensure highly focused outputs.

**For Dart Generation:**
1. AI generates the requested page inside `rapider-flutter/pages/[page_name]` using a specialized Dart-focused system prompt.
2. AI adheres strictly to the allowlist (no hardcoded API calls, depends on `rapider_sdk` and `rapider_ui`).
3. Automated CI validates the Dart package (`dart format`, `flutter analyze`, `flutter test`).
4. Pipeline runs `web_page_runner` for this specific page package to build a Flutter Web artifact.
5. The artifact is deployed to the CDN at `/apps/[app_id]/v[version]/pages/[page_name]/`.
6. The `app.manifest.json` is updated with `"type": "flutter-web"`.

## 4. Angular Shell Updates
The existing Rapider Web (Angular) shell will be updated to:
1. Parse the page `type` from the manifest.
2. Set the `iframe.src` to the appropriate CDN URL.
3. Listen for `postMessage` events from `flutter-web` pages to fulfill SDK requests (e.g., routing requests, data fetching), mapping them to the existing internal Angular services just like the `window.rapiderApi` bridge.

## 5. Mobile Native Build
1. The build script reads `app.manifest.json` and gathers all pages of type `flutter-web`.
2. A `page_registry.dart` file is dynamically generated inside `mobile_wrapper`, registering all AI-generated pages.
3. The `mobile_wrapper` application is compiled using `flutter build ios` and `flutter build appbundle`.
4. **Note:** Pages of type `html` are explicitly excluded entirely from native mobile builds.

## 6. Workspace / Project Selector
We will build a workspace/project selector into the Dart app (`rapider_sdk` / mobile wrapper):
1. After the user logs in, the app queries available workspaces/projects.
2. If the user has only **one** workspace/project, the UI automatically selects it.
3. If multiple exist, the UI prompts the user to select one.
4. The selection is remembered/persisted for future sessions.

## Proposed First Steps (The 3-Page POC)
1. Initialize the `rapider-flutter` monorepo structure.
2. Draft the `rapider_sdk` abstract interfaces (Data, Nav, Actions, Auth, Context).
3. Implement `web_page_runner` and the `RapiderWebSDK` using `postMessage` to communicate with the Angular shell.
4. Manually write the 3 POC pages for the CRM app (Dashboard, Customers, Customer Detail) in Dart to prove the architecture works before fully wiring the AI prompt generator.
5. Update Angular shell to handle the `postMessage` bridge.
6. Implement the Workspace/Project selector flow in the Dart app.

Please review and confirm if this hybrid approach aligns with your vision.
