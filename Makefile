# Makefile for Emacs Configuration Management
# This file helps synchronize the Emacs config with the orgmode files repository

ORGMODE_DIR = $(HOME)/orgmode
ORGMODE_REPO = https://github.com/adamkali/orgmode-files.git
EMACS_CONFIG_DIR = $(HOME)/.emacs.d

.PHONY: help sync-orgmode pull-orgmode push-orgmode status clean install

help:
	@echo "Available targets:"
	@echo "  sync-orgmode    - Pull latest orgmode files and push any local changes"
	@echo "  pull-orgmode    - Pull latest orgmode files from repository"
	@echo "  push-orgmode    - Push local orgmode changes to repository"
	@echo "  status          - Show git status of both repositories"
	@echo "  install         - Clone orgmode repository if it doesn't exist"
	@echo "  clean           - Clean temporary and backup files"

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