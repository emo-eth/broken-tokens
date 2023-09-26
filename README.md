# BrokenToken

A simple token contract that allows users to create ERC721 tokens that might fail on transfer.

## mint()

Mint a normal token

## mintSoulbound()

Mint a soulbound token that reverts with `error Soulbound()` on transfer

## mintCustomRevertString(string calldata)

Mint a token that reverts with a custom string on transfer

# Deploying

Deploy to a network with `forge script DeployBrokenToken --account <deployer account> --rpc-url <rpc url>` or `forge scrpit DeployBrokenToken --private-key <deployer private key> --rpc-url <rpc url>`
You will need to set the `DEPLOYER` environment variable to the address of the deployer account, either via a `.env` file or directly in the shell.
