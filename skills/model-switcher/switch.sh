#!/bin/sh

# Set target model aliases
case "$1" in
  gemini-3.1|3.1|3.1-pro)
    TARGET="google/gemini-3.1-pro-preview"
    ;;
  gemini-3|3|3-pro)
    TARGET="google/gemini-3-pro-preview"
    ;;
  flash|2.5)
    TARGET="google/gemini-2.5-flash"
    ;;
  flash-lite|lite)
    TARGET="google/gemini-2.5-flash-lite"
    ;;
  glm-4|glm|glm4)
    TARGET="amazon-bedrock/zai.glm-4.7"
    ;;
  ark|ark-code)
    TARGET="volcengine-plan/ark-code-latest"
    ;;
  qwen|coder-mode)
    TARGET="qwen-portal/coder-mode"
    ;;
  *)
    # Fallback: Assume it's a full model ID if no alias matches
    TARGET="$1"
    ;;
esac

echo "Switching primary model to: $TARGET"

# Check if openclaw command exists
if ! command -v openclaw >/dev/null 2>&1; then
  echo "Error: 'openclaw' command not found. Cannot update config."
  exit 1
fi

# Apply the config
# We target agents.defaults.model.primary
openclaw config set agents.defaults.model.primary "$TARGET"

if [ $? -eq 0 ]; then
  echo "✅ Configuration updated successfully."
  echo "The new primary model is: $TARGET"
  echo "🔄  Restarting the gateway automatically..."
  openclaw gateway restart
else
  echo "❌ Failed to update configuration."
  exit 1
fi
