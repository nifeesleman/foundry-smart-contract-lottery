-include .env

.PHONY: all test deploy

build:
	forge build

test:
	forge test

install:
	forge install cyfrin/foundry-devops --no-commit && \
	forge install smartcontractkit/chainlink-brownie-contract --no-commit && \
	forge install foundry-rs/forge-std --no-commit && \
	forge install transmissions11/solmate --no-commit

:
deploy-sepolia:
	@forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify -vvvv
