.PHONY: default copy-skills list-skills

default: copy-skills

copy-skills:
	bash link-skills.sh

list-skills:
	bash list-skills.sh
