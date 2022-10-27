# Advanced Solidity Programming: YUL

Yul, also know as EVM assembly, is a low level language for creating smart contracts and for providing more control over the execution environment when using Solidity as the primary language. Although it enables more possibilities to manage memory, using Yul does not imply a performance improvement. In Solang, all Yul constructs are processed using the same pipeline as Solidity.

Solidity Documentation: https://docs.soliditylang.org/en/latest/yul.html

Solang Readthedocs: https://solang.readthedocs.io/en/latest/yul_language/yul.html

University of Texas Documentation: https://www.cs.utexas.edu/users/moore/acl2/manuals/current/manual/index-seo.php/YUL____YUL

Solidity-Fork: https://solidity-fork.readthedocs.io/en/latest/yul.html


Herein you will find some simple contracts demonstrating the capabilities of Yul along with unit tests

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.js
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
