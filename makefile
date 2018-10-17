ANSIBLE_CMD=ansible-playbook -i inventaire/host.ini

clean:
	rm -f playbooks/*.retry

all: play-create-env play-install-php play-install-mariadb play-configure-mariadb play-install-wordpress

play-%:
	$(ANSIBLE_CMD) playbooks/group-machine.yml playbooks/$*.yml

