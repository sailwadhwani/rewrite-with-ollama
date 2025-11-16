![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/macOS-Hammerspoon-blue)
![Model](https://img.shields.io/badge/Ollama-Llama3-orange)

# Rewrite With Ollama

A macOS automation workflow that leverages locally-running Ollama LLM models to intelligently rewrite selected text. This tool provides seamless text enhancement through a single keyboard gesture, featuring an elegant user interface and robust clipboard management.

## Overview

Rewrite With Ollama integrates three powerful technologies to deliver a streamlined text rewriting experience:

- **Hammerspoon** - Advanced macOS automation framework
- **Ollama** - Local LLM inference server
- **Custom ZSH Script** - Lightweight wrapper for efficient API communication

This solution enables you to rewrite any selected text using locally-hosted language models (such as Llama 3 or any Ollama-supported model) through a simple keyboard shortcut.

### Features

1. **Hotkey Activation** - Trigger via `Cmd + Shift + Y` or double-tap modifier keys (Option/Cmd)
2. **Automatic Text Capture** - Intelligently copies the current selection
3. **Local LLM Processing** - Sends text to Ollama's REST API for rewriting
4. **Seamless Integration** - Automatically pastes the rewritten text in place
5. **Clipboard Preservation** - Restores your original clipboard content
6. **Visual Feedback** - Displays an elegant "AI is thinking..." overlay during processing
7. **Privacy-First** - All processing occurs locally with no cloud services

---

## Repository Structure

```
rewrite-with-ollama/
├── bin/
│   └── rewrite-with-ollama    # ZSH script executed by Hammerspoon
├── hammerspoon/
│   └── init.lua                # Hammerspoon automation configuration
├── .github/
│   └── workflows/              # CI/CD workflows (optional)
├── README.md
└── LICENSE
```

---

## Prerequisites

### Required Software

1. **macOS** - This tool is designed specifically for macOS
2. **Hammerspoon** - Free automation framework for macOS
   - Download: [https://www.hammerspoon.org/](https://www.hammerspoon.org/)
3. **Ollama** - Local LLM server
   - Installation: `brew install ollama`
   - Documentation: [https://ollama.ai/](https://ollama.ai/)

### Model Setup

Ensure you have downloaded your preferred language model:

```bash
ollama pull llama3
```

Verify Ollama is running:

```bash
ollama serve
```

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/sailwadhwani/rewrite-with-ollama.git
cd rewrite-with-ollama
```

### 2. Install the ZSH Script

Copy the script to your local bin directory and make it executable:

```bash
cp bin/rewrite-with-ollama ~/bin/rewrite-with-ollama
chmod +x ~/bin/rewrite-with-ollama
```

Ensure `~/bin` is in your PATH, or adjust the path in the Hammerspoon configuration.

### 3. Configure Hammerspoon

Copy the Hammerspoon configuration to your Hammerspoon directory:

```bash
cp hammerspoon/init.lua ~/.hammerspoon/init.lua
```

Alternatively, if you already have a Hammerspoon configuration, append the contents to your existing `init.lua` file.

### 4. Reload Hammerspoon

Open Hammerspoon and click "Reload Config" from the menu bar icon, or press the configured reload hotkey.

---

## Usage

### Basic Operation

1. **Select Text** - Highlight any text in any application
2. **Activate** - Press `Cmd + Shift + Y` or double-tap your configured modifier key
3. **Wait** - Observe the "AI is thinking..." overlay while processing
4. **Review** - The rewritten text is automatically pasted in place

### Customization

Edit `~/.hammerspoon/init.lua` to customize:

- **Hotkey combination** - Change the keyboard shortcut
- **Model selection** - Specify a different Ollama model
- **System prompt** - Modify the rewriting instructions
- **Modifier tap** - Configure double-tap behavior

---

## Configuration

### Changing the LLM Model

Edit the `rewrite-with-ollama` script to use a different model:

```bash
# Default: llama3
# Change to: codellama, mistral, neural-chat, etc.
MODEL="llama3"
```

### Adjusting the System Prompt

Modify the prompt to change rewriting behavior:

```lua
-- Example: Make text more concise
prompt = "Rewrite the following text to be more concise and professional:"

-- Example: Improve grammar only
prompt = "Fix grammar and spelling in the following text:"
```

---

## Troubleshooting

### No Rewrite Occurs

**Potential Causes:**
- Hammerspoon may not have Accessibility permissions
- Another application might be intercepting the same hotkey
- Check the Hammerspoon console for errors

**Solutions:**
1. Grant Accessibility permissions: `System Settings > Privacy & Security > Accessibility`
2. Try an alternative hotkey combination
3. Open Hammerspoon Console (`⌘ + Shift + C`) to view error messages

### Script Produces No Output

**Potential Causes:**
- Ollama server is not running
- Model is not downloaded
- Script path is incorrect

**Solutions:**
1. Start Ollama: `ollama serve`
2. Download model: `ollama pull llama3`
3. Verify script path in Hammerspoon configuration

### Testing Manually

Test the script independently:

```bash
echo "Rewrite this sentence." | ~/bin/rewrite-with-ollama
```

---

## Contributing

Contributions are welcome and appreciated! We're looking for help with:

### Feature Ideas

- Additional modes: Shorten, Expand, Summarize, Translate
- User-selectable prompts via floating Hammerspoon UI
- Unit tests and linting (shellcheck)
- Enhanced banner animations and visual feedback

### How to Contribute

Please open an issue to discuss proposed changes or submit a pull request with your improvements.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

Built with:
- [Hammerspoon](https://www.hammerspoon.org/) - Automation framework
- [Ollama](https://ollama.ai/) - Local LLM inference
- [Llama 3](https://ai.meta.com/llama/) - Language model

---

## Support

If you encounter issues or have questions:

- Open an [issue](https://github.com/sailwadhwani/rewrite-with-ollama/issues)
- Check existing issues for similar problems
- Include error messages and system information when reporting bugs
