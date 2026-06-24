PREFIX  := $(HOME)/local
BIN_DIR := $(PREFIX)/bin
TMP_DIR := $(HOME)/tmp

$(BIN_DIR):
	mkdir -p "$(BIN_DIR)"

$(TMP_DIR):
	mkdir -p "$(TMP_DIR)"

.PHONY: all
all: kitty lazygit nvim eza delta fzf ripgrep

###############################################################################
# Kitty / kitten
###############################################################################
KITTY_INSTALL_DIR := $(HOME)/.local/kitty.app
KITTY_BIN         := $(KITTY_INSTALL_DIR)/bin/kitty
KITTEN_BIN        := $(KITTY_INSTALL_DIR)/bin/kitten
KITTY_LINK        := $(BIN_DIR)/kitty
KITTEN_LINK       := $(BIN_DIR)/kitten

$(KITTY_BIN):
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

$(KITTY_LINK): $(KITTY_BIN) | $(BIN_DIR)
	ln -sf "$(KITTY_BIN)" "$(KITTY_LINK)"

$(KITTEN_LINK): $(KITTEN_BIN) | $(BIN_DIR)
	ln -sf "$(KITTEN_BIN)" "$(KITTEN_LINK)"

.PHONY: kitty
kitty: $(KITTY_LINK) $(KITTEN_LINK)

###############################################################################
# Lazygit
###############################################################################
LAZYGIT_URL      := https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_0.62.2_Linux_x86_64.tar.gz
LAZYGIT_ARCHIVE  := $(TMP_DIR)/lazygit.tar.gz
LAZYGIT_DIR      := $(PREFIX)/lazygit
LAZYGIT_BIN      := $(LAZYGIT_DIR)/lazygit
LAZYGIT_LINK     := $(BIN_DIR)/lazygit

$(LAZYGIT_ARCHIVE): | $(TMP_DIR)
	curl -L "$(LAZYGIT_URL)" -o "$(LAZYGIT_ARCHIVE)"

$(LAZYGIT_DIR):
	mkdir -p "$(LAZYGIT_DIR)"

$(LAZYGIT_BIN): $(LAZYGIT_ARCHIVE) | $(LAZYGIT_DIR)
	tar -xzf "$(LAZYGIT_ARCHIVE)" -C "$(LAZYGIT_DIR)"

$(LAZYGIT_LINK): $(LAZYGIT_BIN) | $(BIN_DIR)
	ln -sf "$(LAZYGIT_BIN)" "$(LAZYGIT_LINK)"

.PHONY: lazygit
lazygit: $(LAZYGIT_LINK)

###############################################################################
# Neovim (nvim)
###############################################################################
NVIM_URL      := https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
NVIM_ARCHIVE  := $(TMP_DIR)/nvim.tar.gz
NVIM_DIR      := $(PREFIX)/nvim
NVIM_BIN      := $(NVIM_DIR)/bin/nvim
NVIM_LINK     := $(BIN_DIR)/nvim

$(NVIM_ARCHIVE): | $(TMP_DIR)
	curl -L "$(NVIM_URL)" -o "$(NVIM_ARCHIVE)"

$(NVIM_DIR):
	mkdir -p "$(NVIM_DIR)"

$(NVIM_BIN): $(NVIM_ARCHIVE) | $(NVIM_DIR)
	tar -xzf "$(NVIM_ARCHIVE)" -C "$(NVIM_DIR)" --strip-components=1

$(NVIM_LINK): $(NVIM_BIN) | $(BIN_DIR)
	ln -sf "$(NVIM_BIN)" "$(NVIM_LINK)"

.PHONY: nvim
nvim: $(NVIM_LINK)

###############################################################################
# eza
###############################################################################
EZA_URL      := https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
EZA_ARCHIVE  := $(TMP_DIR)/eza.tar.gz
EZA_DIR      := $(PREFIX)/eza
EZA_BIN      := $(EZA_DIR)/eza
EZA_LINK     := $(BIN_DIR)/eza

$(EZA_ARCHIVE): | $(TMP_DIR)
	curl -L "$(EZA_URL)" -o "$(EZA_ARCHIVE)"

$(EZA_DIR):
	mkdir -p "$(EZA_DIR)"

$(EZA_BIN): $(EZA_ARCHIVE) | $(EZA_DIR)
	tar -xzf "$(EZA_ARCHIVE)" -C "$(EZA_DIR)"
	# adjust if tarball layout differs

$(EZA_LINK): $(EZA_BIN) | $(BIN_DIR)
	ln -sf "$(EZA_BIN)" "$(EZA_LINK)"

.PHONY: eza
eza: $(EZA_LINK)

###############################################################################
# delta (git-delta)
###############################################################################
DELTA_URL      := https://github.com/dandavison/delta/releases/latest/download/delta-0.19.2-x86_64-unknown-linux-gnu.tar.gz
DELTA_ARCHIVE  := $(TMP_DIR)/delta.tar.gz
DELTA_DIR      := $(PREFIX)/delta
DELTA_BIN      := $(DELTA_DIR)/delta
DELTA_LINK     := $(BIN_DIR)/delta

$(DELTA_ARCHIVE): | $(TMP_DIR)
	curl -L "$(DELTA_URL)" -o "$(DELTA_ARCHIVE)"

$(DELTA_DIR):
	mkdir -p "$(DELTA_DIR)"

$(DELTA_BIN): $(DELTA_ARCHIVE) | $(DELTA_DIR)
	tar -xzf "$(DELTA_ARCHIVE)" -C "$(DELTA_DIR)" --strip-components=1

$(DELTA_LINK): $(DELTA_BIN) | $(BIN_DIR)
	ln -sf "$(DELTA_BIN)" "$(DELTA_LINK)"

.PHONY: delta
delta: $(DELTA_LINK)

###############################################################################
# fzf
###############################################################################
# Example URL for Linux x86_64; adjust version/arch as needed
FZF_URL      := https://github.com/junegunn/fzf/releases/latest/download/fzf-0.73.1-linux_amd64.tar.gz
FZF_ARCHIVE  := $(TMP_DIR)/fzf.tar.gz
FZF_DIR      := $(PREFIX)/fzf
FZF_BIN      := $(FZF_DIR)/fzf
FZF_LINK     := $(BIN_DIR)/fzf

$(FZF_ARCHIVE): | $(TMP_DIR)
	curl -L "$(FZF_URL)" -o "$(FZF_ARCHIVE)"

$(FZF_DIR):
	mkdir -p "$(FZF_DIR)"

$(FZF_BIN): $(FZF_ARCHIVE) | $(FZF_DIR)
	tar -xzf "$(FZF_ARCHIVE)" -C "$(FZF_DIR)"
	# adjust if tarball layout differs

$(FZF_LINK): $(FZF_BIN) | $(BIN_DIR)
	ln -sf "$(FZF_BIN)" "$(FZF_LINK)"

.PHONY: fzf
fzf: $(FZF_LINK)

###############################################################################
# ripgrep (rg)
###############################################################################
# Example URL for Linux x86_64; adjust version/arch as needed
RG_URL      := https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz
RG_ARCHIVE  := $(TMP_DIR)/ripgrep.tar.gz
RG_DIR      := $(PREFIX)/ripgrep
RG_BIN      := $(RG_DIR)/rg
RG_LINK     := $(BIN_DIR)/rg

$(RG_ARCHIVE): | $(TMP_DIR)
	curl -L "$(RG_URL)" -o "$(RG_ARCHIVE)"

$(RG_DIR):
	mkdir -p "$(RG_DIR)"

$(RG_BIN): $(RG_ARCHIVE) | $(RG_DIR)
	tar -xzf "$(RG_ARCHIVE)" -C "$(RG_DIR)" --strip-components=1
	# many ripgrep tarballs contain ./rg in the root after strip-components=1

$(RG_LINK): $(RG_BIN) | $(BIN_DIR)
	ln -sf "$(RG_BIN)" "$(RG_LINK)"

.PHONY: ripgrep
ripgrep: $(RG_LINK)

###############################################################################
# Cleanup
###############################################################################
.PHONY: clean
clean:
	rm -rf "$(TMP_DIR)"
