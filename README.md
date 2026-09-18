# Rapider Flutter Harness (Master)

This repository serves as the **Master Template** and SDK for the Rapider Flutter ecosystem. It contains the core components, SDKs, and runners required to execute Rapider Flutter applications across Web and Mobile.

## Purpose

The code in this repository is **not** meant to be deployed directly as a standalone application. Instead, it is designed to be **copied into individual Rapider Application repositories** (e.g., a CRM app). 

By isolating the harness from the application-specific pages, we allow apps to maintain their own custom UI logic while seamlessly upgrading to the latest Rapider SDKs.

## Directory Structure

*   **`packages/`**: Contains the core Rapider Flutter SDK (`rapider_sdk`), Page Contracts (`rapider_page_contract`), and reusable UI components (`rapider_ui`).
*   **`runners/`**: Contains shell applications designed to compile the app for specific targets. For example, `web_page_runner` is used to compile the app into a web bundle that can be embedded in the main Rapider UI.
*   **`apps/`**: Contains application wrappers like `mobile_wrapper` designed to run the specific app natively on iOS/Android.
*   **`pages/`**: A sandbox directory used **only for local development** of the harness. When the harness is copied into an actual application repository, this directory is ignored, as the application will provide its own `pages/` directory.

## How Apps Consume the Harness

Individual Rapider Application repositories (e.g., `rapider-app-crm-sys-comprehensive-crm-system`) contain a `flutter/` directory.

Inside that directory, they use an NPM script (`npm run update-harness`) to copy the `apps/`, `packages/`, and `runners/` folders from this master repository into their own codebase. 

Once copied, the app uses `npm run generate-pubspec` to dynamically generate a Dart Workspace `pubspec.yaml` that links the harness SDKs with their own custom UI pages.

## Development Guidelines

1. **Keep it Generic:** Any code added to `packages/` or `runners/` must be completely agnostic of the specific application it will run. It should rely entirely on `rapider_page_contract` to render dynamic content.
2. **Local Testing:** You can use the `pages/` directory in this repository to build mock pages and test changes to the `rapider_sdk` locally before deploying the harness to actual applications.
