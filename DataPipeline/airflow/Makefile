
VENV=venv/bin
WITH_VENV=. $(VENV)/activate;

.PHONY: venv
venv: venv/bin/activate
venv/bin/activate: requirements.txt
ifneq ($(wildcard ./venv/.*),)
	@echo "venv loaded!"
else
	@echo "Installing dependencies"
	@test -d venv || python3 -m venv venv
	@$(VENV)/python3 -m pip install --upgrade pip
	@$(VENV)/pip install -Ur requirements.txt
	@touch $(VENV)/activate
endif

.PHONY: lint
lint: venv
	@$(VENV)/python3 -m ruff check dags/*.py
	@$(VENV)/python3 -m ruff check plugins
	@$(VENV)/python3 -m ruff check tests


.PHONY: test
test: venv
	@$(VENV)/python3 -m pytest tests/dags/test_*.py --log-cli-level=info --disable-warnings


DBT_DIR = ./dbt/*/
.PHONY: generate-dbt-docs
generate-dbt-docs: venv
	@for dir in $(DBT_DIR); do \
		(cd ./$$dir && dbt docs generate --empty-catalog --no-compile); \
	done
