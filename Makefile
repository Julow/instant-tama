# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jaguillo <jaguillo@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/06/20 11:16:05 by jaguillo          #+#    #+#              #
#    Updated: 2015/06/28 12:25:07 by ngoguey          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Executable name
NAME := tama

# Dirs
OBJS_DIR := bin/
SRCS_DIR := srcs/

# Sources files (.ml)
SRCS := \
		Try.ml Config.ml \
		Image.ml Sprite.ml Stat.ml Action.ml \
		Data.ml \
		UI.ml \
		main.ml

# Compilation flags
FLAGS := -I $(OBJS_DIR) -I ~/.brew/lib/ocaml/sdl

# Linking flags
LINKS := $(FLAGS) -cclib "`sdl-config --libs`"
LINKS_BYT := bigarray.cma sdl.cma sdlloader.cma sdlttf.cma sdlgfx.cma
LINKS_OPT := bigarray.cmxa sdl.cmxa sdlloader.cmxa sdlttf.cmxa sdlgfx.cmxa

# Compilers
OCAMLC := ocamlc
OCAMLOPT := ocamlopt

# Internal
BYT_OBJS := \
	$(addprefix $(OBJS_DIR),$(SRCS:.ml=.cmo))
OPT_OBJS := \
	$(addprefix $(OBJS_DIR),$(SRCS:.ml=.cmx))
GARBAGES := \
	$(addprefix $(OBJS_DIR),$(SRCS:.ml=.cmi)) \
	$(addprefix $(OBJS_DIR),$(SRCS:.ml=.o))

all: $(NAME)

$(NAME): $(OBJS_DIR)$(NAME).opt
	@ln -sf $(OBJS_DIR)$(NAME).opt $@
	@echo "\033[32m$@\033[0m"

byt: $(OBJS_DIR)$(NAME).byt
	@ln -sf $(OBJS_DIR)$(NAME).byt $(NAME)
	@echo "\033[32m$@\033[0m"

$(OBJS_DIR)$(NAME).byt: $(OBJS_DIR) $(BYT_OBJS)
	@$(OCAMLC) $(LINKS) $(LINKS_BYT) -o $@ $(BYT_OBJS)

opt: $(OBJS_DIR)$(NAME).opt
	@ln -sf $(OBJS_DIR)$(NAME).opt $(NAME)
	@echo "\033[32m$@\033[0m"

$(OBJS_DIR)$(NAME).opt: $(OBJS_DIR) $(OPT_OBJS)
	@$(OCAMLOPT) $(LINKS) $(LINKS_OPT) -o $@ $(OPT_OBJS)

.depend: Makefile $(SRCS_DIR)
	@ocamldep -I $(SRCS_DIR) $(addprefix $(SRCS_DIR),$(SRCS)) | \
		sed -E 's;([^ ]+/)?([^ \./]+\.[^ :]+);$(OBJS_DIR)\2;g' > .depend

$(OBJS_DIR)%.cmo: $(SRCS_DIR)%.ml
	@$(OCAMLC) -g $(FLAGS) -o $@ -c $<
	@echo "\033[92m$@\033[0m"

$(OBJS_DIR)%.cmx: $(SRCS_DIR)%.ml
	@$(OCAMLOPT) $(FLAGS) -o $@ -c $<
	@echo "\033[92m$@\033[0m"

$(OBJS_DIR)%.cmi: $(SRCS_DIR)%.mli
	@$(OCAMLOPT) $(LINKS) $(LINKS_OPT) -I $(OBJS_DIR) -o $@ -c $<
	@echo "\033[93m$@\033[0m"

$(OBJS_DIR) $(SRCS_DIR):
	@mkdir -p $@

i:
	@for i in $(addprefix $(SRCS_DIR),$(SRCS)); do \
		echo "\033[33m --> $$i\033[0m"; \
		$(OCAMLOPT) $(FLAGS) -i $$i; \
	done

clean:
	@rm -f $(BYT_OBJS) $(OPT_OBJS) $(GARBAGES)

fclean: clean
	@rm -f .depend $(NAME) $(OBJS_DIR)$(NAME).opt $(OBJS_DIR)$(NAME).byt
	@rmdir $(OBJS_DIR) 2> /dev/null || true

re: fclean all

.PHONY: all clean fclean re byt opt

-include .depend
