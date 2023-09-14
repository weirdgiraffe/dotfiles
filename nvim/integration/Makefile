REPO_DIR:=$(shell git rev-parse --show-toplevel)
THIS_DIR:=${REPO_DIR}/nvim/integration
NVIM_DIR:=${REPO_DIR}/nvim/config
IMAGE_NAME:=neovim-integration

# to avoid annoying messages from docker
export DOCKER_CLI_HINTS=false

.PHONY: run
run: build
	docker container run -q --rm -it \
    	-v $(HOME)/.config/git:/root/.config/git:ro \
    	-v $(HOME)/.ssh:/root/.ssh:ro \
    	-v $(NVIM_DIR):/root/.config/nvim \
    	$(IMAGE_NAME)

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) $(THIS_DIR)

.PHONY: clean
clean:
	docker image rm $(IMAGE_NAME)
