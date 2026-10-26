# Dépôt « prêt à coder » : Flutter (épinglé via fvm), Android SDK minimal,
# Supabase CLI et lefthook préinstallés, identiques quel que soit l'hôte
# (Linux/Mac/Windows) — voir AGENTS.md et BOOTSTRAP.md Annexe A pour le détail
# de chaque outil et pourquoi cette version précise.
#
# Ce que ce conteneur NE fait PAS : lancer un émulateur Android (accès
# GPU/KVM non fiable en conteneur) — `flutter build apk` fonctionne en tâche
# de fond, mais teste sur un appareil réel (adb, USB) ou Android Studio hors
# conteneur : l'app se voit dans le navigateur (`melos run app`, voir
# README) ou sur un téléphone en ADB sans fil. Docker (pour `supabase start`)
# est fourni par la feature docker-in-docker (voir devcontainer.json).
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-21-jdk-headless \
        unzip xz-utils zip \
    && rm -rf /var/lib/apt/lists/*

USER vscode
ENV PATH="/home/vscode/fvm/bin:/home/vscode/fvm/default/bin:/home/vscode/.pub-cache/bin:${PATH}"

# --- Flutter, épinglé à la version de .fvmrc (3.47.4) ---
# L'installeur fvm pose le binaire dans ~/fvm/bin ; `fvm global` crée le lien
# ~/fvm/default -> ~/fvm/versions/3.47.4, d'où le PATH ci-dessus.
RUN curl -fsSL https://fvm.app/install.sh | bash \
    && fvm install 3.47.4 \
    && fvm global 3.47.4 \
    && flutter --version \
    && flutter config --no-analytics

# --- Android SDK minimal (cmdline-tools + platform-tools + un seul niveau
# d'API) : suffisant pour `flutter analyze`/`flutter build apk`. Le build
# number ci-dessous (13114758) est celui vérifié en 2026 ; si le téléchargement
# échoue (404), prendre le lien à jour sur
# https://developer.android.com/studio#command-line-tools-only ---
ENV ANDROID_SDK_ROOT="/home/vscode/android-sdk"
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"
RUN mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools" \
    && curl -fsSL -o /tmp/cmdline-tools.zip \
        "https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip" \
    && unzip -q /tmp/cmdline-tools.zip -d "$ANDROID_SDK_ROOT/cmdline-tools" \
    && mv "$ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools" "$ANDROID_SDK_ROOT/cmdline-tools/latest" \
    && rm /tmp/cmdline-tools.zip \
    && yes | sdkmanager --sdk_root="$ANDROID_SDK_ROOT" --licenses > /dev/null \
    && sdkmanager --sdk_root="$ANDROID_SDK_ROOT" "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# --- Supabase CLI, épinglé (même version que la CI, ci-supabase.yml) ---
ARG SUPABASE_CLI_VERSION=2.117.0
RUN curl -fsSL -o /tmp/supabase.deb \
        "https://github.com/supabase/cli/releases/download/v${SUPABASE_CLI_VERSION}/supabase_${SUPABASE_CLI_VERSION}_linux_amd64.deb" \
    && sudo dpkg -i /tmp/supabase.deb \
    && rm /tmp/supabase.deb \
    && supabase --version

# --- lefthook (hooks Git pre-commit/pre-push, AD-14) ---
RUN curl -1sLf 'https://dl.cloudsmith.io/public/evilmartians/lefthook/setup.deb.sh' | sudo -E bash \
    && sudo apt-get install -y lefthook \
    && sudo rm -rf /var/lib/apt/lists/*

# --- melos (lanceur de scripts du workspace, activé globalement pour que
# `melos run <script>` fonctionne tel quel, comme documenté dans AGENTS.md) ---
RUN dart pub global activate melos 8.7.0

WORKDIR /workspaces/Histolyon
