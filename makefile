ANSIBLE_CMD=ansible-playbook -i inventaire/host.ini
ANSIBLE_STRATEGY=mitogen_linear
ANSIBLE_STRATEGY_PLUGINS=/home/yannig/dev/mitogen/ansible_mitogen/plugins

clean:
	rm -f playbooks/*.retry

linear-strategy: play-create-env play-install-php play-install-mariadb play-configure-mariadb play-install-wordpress

play-%:
	$(ANSIBLE_CMD) playbooks/group-machine.yml playbooks/$*.yml

mitogen-strategy: mito-create-env mito-install-php mito-install-mariadb mito-configure-mariadb mito-install-wordpress

mito-%:
	ANSIBLE_STRATEGY=$(ANSIBLE_STRATEGY) ANSIBLE_STRATEGY_PLUGINS=$(ANSIBLE_STRATEGY_PLUGINS) $(ANSIBLE_CMD) playbooks/group-machine.yml playbooks/$*.yml

cow-say:
	ANSIBLE_NOCOWS=0 $(ANSIBLE_CMD) playbooks/hello-people.yml

turkey-say:
	ANSIBLE_NOCOWS=0 ANSIBLE_COW_SELECTION=turkey $(ANSIBLE_CMD) playbooks/hello-people.yml

logstash-say:
	ANSIBLE_CALLBACK_WHITELIST=logstash LOGSTASH_PORT=5555 $(ANSIBLE_CMD) playbooks/hello-people.yml

netcat:
	nc -lk 0.0.0.0 5555 | jq .
