---
name: model-switcher
description: Quickly switch the primary AI model used by OpenClaw. Supports aliases like 'flash', 'gemini-3.1', 'gemini-3', 'glm-4'.
metadata:
  openclaw:
    emoji: 🤖
    requires:
      bins: ["openclaw", "jq"]
---

To use the model switcher:

1.  **Parse the user's request** to identify the target model.
    *   Recognize common aliases:
        *   "Gemini 3.1 Pro" or "3.1" -> `gemini-3.1`
        *   "Gemini 3 Pro" or "3" -> `gemini-3`
        *   "Flash" or "2.5" -> `flash`
        *   "Flash Lite" -> `flash-lite`
        *   "GLM 4" -> `glm-4`
        *   "Ark Code" -> `ark`
2.  **Execute the switch script**:
    Run the `switch.sh` script with the target model alias or full ID.

    ```bash
    {baseDir}/switch.sh "<model_alias_or_id>"
    ```

3.  **Report the result**:
    The script will output the new configuration. Tell the user what happened and remind them to restart the gateway if the script says so.
