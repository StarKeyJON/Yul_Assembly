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
