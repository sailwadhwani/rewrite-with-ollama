# Rewrite With Ollama

A macOS automation workflow that rewrites selected text using a locally running Ollama LLM model. Select any text, trigger a hotkey (or double-tap modifier), and the rewritten text is automatically pasted back in place — with a polished “AI is thinking…” overlay and safe clipboard restoration.

## 🚀 Overview

This project integrates:

- **Hammerspoon** (macOS automation framework)
- **Ollama** (local LLM server)
- **A lightweight ZSH wrapper script**

Together, they let you rewrite any selected text using a local Llama model (or any model supported by Ollama) using a single keyboard gesture.

### What it does

1. Detects the trigger (Cmd + Shift + Y or double-tap Option/Cmd)  
2. Copies current selection  
3. Sends the text to Ollama’s REST API  
4. Waits for the rewritten result  
5. Pastes the rewritten text automatically  
6. Restores your clipboard  
7. Shows a polished floating banner while the AI is thinking  

No cloud services. All processing is local.

---

## 🧩 Repository Structure

rewrite-with-ollama/
├─ bin/
│  └─ rewrite-with-ollama       # ZSH script executed by Hammerspoon
├─ hammerspoon/
│  └─ init.lua                  # Full Hammerspoon automation config
├─ .github/
│  └─ workflows/                # (optional) CI scripts
├─ README.md
├─ LICENSE
└─ .gitignore

---

## 📦 Requirements

- **macOS**
- **Hammerspoon**  
  Install from: https://www.hammerspoon.org
- **Ollama**  
  Install from: https://github.com/ollama/ollama  
  Must be running so the API is available at:  
  `http://localhost:11434/api/generate`
- **A compatible model**, e.g.:  
  ```bash
  ollama pull llama3:instruct

	•	jq (optional but recommended)

brew install jq



⸻

⚙️ Installation

1. Clone the project

git clone https://github.com/sailwadhwani/rewrite-with-ollama.git
cd rewrite-with-ollama

2. Make the rewrite script executable

chmod +x bin/rewrite-with-ollama

(Optional) Install it into your user bin:

mkdir -p ~/bin
cp bin/rewrite-with-ollama ~/bin/rewrite-with-ollama
chmod +x ~/bin/rewrite-with-ollama

3. Update SCRIPT_PATH in hammerspoon/init.lua

Set it to match where the script is stored, e.g.:

local SCRIPT_PATH = os.getenv("HOME") .. "/bin/rewrite-with-ollama"

4. Reload Hammerspoon

Open the Hammerspoon menu → Reload Config, or run:

hs.reload()

5. Allow Accessibility permissions

macOS → Settings → Privacy & Security → Accessibility → Enable Hammerspoon

⸻

🖥️ Usage
	1.	Select any text (email, document, browser, code, etc.)
	2.	Trigger the rewrite:
	•	Cmd + Shift + Y, or
	•	Double-tap Option (Alt) (default enabled), or
	•	Double-tap Command (if enabled)
	3.	A floating banner appears: “AI is thinking…”
	4.	The rewritten text is pasted automatically
	5.	Your clipboard is restored to its original value

⸻

🛠 Configuration

Edit the top of hammerspoon/init.lua:

Setting	Description	Default
hotModifiers	Hotkey modifier keys	{ "cmd", "shift" }
hotKey	Hotkey trigger key	"Y"
DOUBLE_CMD_ENABLE	Enable double-tap Cmd	false
DOUBLE_OPT_ENABLE	Enable double-tap Option	true
DOUBLE_INTERVAL	Max time between taps (sec)	0.30
TASK_TIMEOUT	Timeout for Ollama request	45 sec
SCRIPT_PATH	Path to ZSH rewrite script	~/bin/rewrite-with-ollama


⸻

📄 Example

Original text:

“I have checked the data and it seems okay but maybe verify again.”

Rewritten:

“I’ve reviewed the data and it looks right, but we should double-check to be sure.”

⸻

🧰 Troubleshooting

“Rewrite failed”
	•	Ollama is not running
Start it:

ollama serve


	•	Wrong model name
Make sure the model is installed:

ollama pull llama3:instruct



No rewrite happens
	•	Hammerspoon may not have Accessibility permissions
	•	Another app might be using the same hotkey
	•	Check Hammerspoon console for errors

Script produces no output

Test it manually:

echo "Rewrite this sentence." | ~/bin/rewrite-with-ollama


⸻

🤝 Contributing

Contributions are welcome!

Ideas:
	•	Add modes: Shorten, Expand, Summarize, Translate
	•	Add user-selectable prompts in a floating Hammerspoon UI
	•	Add unit tests or linting (shellcheck)
	•	Improve banner animations

Please open issues or submit pull requests.

⸻

📜 License

This project is licensed under the MIT License.
