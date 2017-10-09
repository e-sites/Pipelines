all: help

install:
		@read -p "Buildkite API Token: " input; \
		API_TOKEN=$$input; \
		sed -i.bak "s/<BUILDKITE-API-TOKEN>/\"$$API_TOKEN\"/g" Pipelines/Classes/Constants.swift; \
		npm install apollo-codegen@0.17.0-alpha.7; \
		apollo-codegen download-schema https://graphql.buildkite.com/v1 --output Pipelines/schema.json --header "Authorization: Bearer $$API_TOKEN"

		bundle install

		bundle exec pod install --repo-update

		ruby ./parse_emojis.rb
		
help:
	@echo "Available make commands:"
	@echo "   $$ make help - display this message"
	@echo "   $$ make install - run this prior to opening the project"
