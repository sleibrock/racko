# Racko makefile

NAME=racko
CLEAN_FILES=compiled doc
RM=rm -rf

install:
	raco pkg install

.PHONY=clean
clean:
	@echo "[CLEAN] Cleaning up unnecessary files"
	@$(RM) $(CLEAN_FILES)
	@echo "[CLEAN] Removing racko from Racket"
	@raco pkg remove $(NAME)

