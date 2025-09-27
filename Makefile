# Makefile for Emacs Configuration Management
# This file helps synchronize the Emacs config with the orgmode files repository

ORGMODE_DIR = $(HOME)/orgmode
ORGMODE_REPO = https://github.com/adamkali/orgmode-files.git
EMACS_CONFIG_DIR = $(HOME)/.emacs.d

# Default target - show interactive menu
.DEFAULT_GOAL := menu

.PHONY: help menu sync-orgmode pull-orgmode push-orgmode status clean install sync-all sync-all-remote sync interactive

# Interactive menu (default when running 'make' without arguments)
menu:
	@echo "🔧 Emacs Configuration Management"
	@echo "=================================="
	@echo ""
	@echo "Quick Actions:"
	@echo "  1) make sync        - 🔄 Complete sync (local + remote + keybindings)"
	@echo "  2) make status      - 📊 Show repository status"
	@echo "  3) make clean       - 🧹 Clean temporary files"
	@echo ""
	@echo "Sync Options:"
	@echo "  sync-all           - 🏠 Local sync only"
	@echo "  sync-all-remote    - ☁️  Remote GitHub Actions sync"
	@echo "  sync-orgmode       - 📝 Orgmode files only"
	@echo ""
	@echo "Other Commands:"
	@echo "  install            - 📦 Setup orgmode repository"
	@echo "  help               - ❓ Show detailed help"
	@echo "  interactive        - 🎯 Interactive command selection"
	@echo ""
	@echo "💡 Tip: Run 'make help' for detailed descriptions"
	@echo "💡 Tip: Run 'make interactive' for guided selection"

# Interactive command selection
interactive:
	@echo "🎯 Interactive Emacs Config Management"
	@echo "======================================"
	@echo ""
	@echo "What would you like to do?"
	@echo ""
	@echo "1) Complete synchronization (recommended)"
	@echo "2) Check status of repositories"
	@echo "3) Sync only orgmode files"
	@echo "4) Sync only emacs config"
	@echo "5) Trigger remote sync + keybindings update"
	@echo "6) Clean temporary files"
	@echo "7) Install/setup orgmode repository"
	@echo "0) Exit"
	@echo ""
	@read -p "Enter your choice (0-7): " choice; \
	case $$choice in \
		1) echo "Running complete synchronization..."; $(MAKE) sync ;; \
		2) echo "Checking repository status..."; $(MAKE) status ;; \
		3) echo "Syncing orgmode files..."; $(MAKE) sync-orgmode ;; \
		4) echo "Syncing emacs config..."; $(MAKE) push-emacs ;; \
		5) echo "Triggering remote sync..."; $(MAKE) sync-all-remote ;; \
		6) echo "Cleaning temporary files..."; $(MAKE) clean ;; \
		7) echo "Setting up orgmode repository..."; $(MAKE) install ;; \
		0) echo "Goodbye! 👋" ;; \
		*) echo "Invalid choice. Please run 'make interactive' again." ;; \
	esac

help:
	@echo "📖 Emacs Configuration Management - Detailed Help"
	@echo "================================================="
	@echo ""
	@echo "🚀 QUICK START:"
	@echo "  make             - Show interactive menu (default)"
	@echo "  make sync        - Complete synchronization (recommended)"
	@echo "  make status      - Check what needs syncing"
	@echo ""
	@echo "🔄 SYNCHRONIZATION COMMANDS:"
	@echo "  sync             - Complete sync: local + remote + keybindings update"
	@echo "  sync-all         - Local sync only (orgmode + emacs config)"
	@echo "  sync-all-remote  - Remote GitHub Actions sync + keybindings"
	@echo "  sync-orgmode     - Orgmode files only (pull + push)"
	@echo ""
	@echo "📂 INDIVIDUAL OPERATIONS:"
	@echo "  pull-orgmode     - Pull latest orgmode files from repository"
	@echo "  push-orgmode     - Push local orgmode changes to repository"
	@echo "  push-emacs       - Push emacs config changes"
	@echo ""
	@echo "🔧 UTILITY COMMANDS:"
	@echo "  status           - Show git status of both repositories"
	@echo "  install          - Clone orgmode repository if missing"
	@echo "  clean            - Clean temporary and backup files"
	@echo "  interactive      - Interactive command selection menu"
	@echo ""
	@echo "💡 EXAMPLES:"
	@echo "  make                    # Show menu"
	@echo "  make sync              # Full sync everything"
	@echo "  make status            # Check what changed"
	@echo "  make interactive       # Guided selection"
	@echo ""
	@echo "🎯 ALIASES (shortcuts):"
	@echo "  s = sync, st = status, i = interactive, c = clean"

# Install orgmode repository if it doesn't exist
install:
	@if [ ! -d "$(ORGMODE_DIR)/.git" ]; then \
		echo "Cloning orgmode repository..."; \
		git clone $(ORGMODE_REPO) $(ORGMODE_DIR); \
	else \
		echo "Orgmode repository already exists"; \
	fi

# Pull latest changes from orgmode repository
pull-orgmode: install
	@echo "Pulling latest orgmode files..."
	@cd $(ORGMODE_DIR) && \
		git fetch origin && \
		if [ -n "$$(git status --porcelain)" ]; then \
			echo "Local changes detected. Stashing before pull..."; \
			git stash push -m "Auto-stash before pull $$(date)"; \
			git pull origin master; \
			echo "Applying stashed changes..."; \
			git stash pop; \
		else \
			git pull origin master; \
		fi

# Push local orgmode changes to repository
push-orgmode:
	@echo "Pushing orgmode changes..."
	@cd $(ORGMODE_DIR) && \
		if [ -n "$$(git status --porcelain)" ]; then \
			git add .; \
			git commit -m "Update org files - $$(date '+%Y-%m-%d %H:%M:%S')\n\n🤖 Auto-commit from Makefile\n\nCo-Authored-By: Makefile <makefile@local>"; \
			git push origin master; \
		else \
			echo "No changes to push"; \
		fi

# Synchronize both ways - pull then push
sync-orgmode: pull-orgmode push-orgmode
	@echo "Orgmode synchronization complete"

# Show status of both repositories
status:
	@echo "=== Emacs Config Repository Status ==="
	@cd $(EMACS_CONFIG_DIR) && git status --short
	@echo ""
	@echo "=== Orgmode Repository Status ==="
	@if [ -d "$(ORGMODE_DIR)/.git" ]; then \
		cd $(ORGMODE_DIR) && git status --short; \
	else \
		echo "Orgmode repository not found. Run 'make install' first."; \
	fi

# Clean temporary and backup files
clean:
	@echo "Cleaning temporary files..."
	@find $(ORGMODE_DIR) -name "*~" -delete 2>/dev/null || true
	@find $(ORGMODE_DIR) -name "\#*\#" -delete 2>/dev/null || true
	@find $(ORGMODE_DIR) -name ".#*" -delete 2>/dev/null || true
	@echo "Cleanup complete"

# Push emacs config changes
push-emacs:
	@echo "Pushing emacs config changes..."
	@cd $(EMACS_CONFIG_DIR) && \
		if [ -n "$$(git status --porcelain)" ]; then \
			git add .; \
			git commit -m "Update emacs configuration - $$(date '+%Y-%m-%d %H:%M:%S')\n\n🤖 Auto-commit from Makefile\n\nCo-Authored-By: Makefile <makefile@local>"; \
			git push origin master; \
		else \
			echo "No changes to push"; \
		fi

# Full synchronization of both repositories
sync-all: sync-orgmode push-emacs
	@echo "Full synchronization complete"

# Trigger GitHub Actions sync-all workflow with keybindings update
sync-all-remote:
	@echo "Triggering GitHub Actions sync-all workflow..."
	@if command -v gh >/dev/null 2>&1; then \
		gh workflow run sync-all.yml --ref master; \
		echo "GitHub Actions sync-all workflow triggered successfully"; \
		echo "This will sync repositories and update keybindings documentation"; \
		echo "Check workflow status at: https://github.com/$$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/actions"; \
	else \
		echo "Error: GitHub CLI (gh) is not installed or not in PATH"; \
		echo "Please install gh CLI or manually trigger the workflow at:"; \
		echo "https://github.com/$$(git remote get-url origin | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions/workflows/sync-all.yml"; \
	fi

# Complete synchronization: local sync followed by remote GitHub Actions
sync: sync-all sync-all-remote
	@echo ""
	@echo "=== Complete Synchronization Summary ==="
	@echo "✓ Local repositories synchronized (orgmode + emacs config)"
	@echo "✓ GitHub Actions workflow triggered for remote sync + keybindings update"
	@echo ""
	@echo "All synchronization tasks completed!"
	@echo "Monitor the GitHub Actions workflow for keybindings documentation updates."