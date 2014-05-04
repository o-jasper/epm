# Introduction

EPM is a package (provision?) manager. It is meant to simplify the management of git hosted repositories which contain Ethereum standard or customized contracts. This package manager should work in the way which most package managers operate -- with the addition that it will be able to interact with the Ethereum BlockChain.

In addition to installing, uninstalling, updating, and upgrading your packages for you, the Gem will also act as a hub for different Ethereum contract building, testing, simulating, and deploying mechanisms.

The package manager builds in a standard tipping system which is -- by convention -- built to allow tipping of the EPM system as well as the other tools which developers use to build, test, and deploy their contracts onto the Ethereum BlockChain. The tipping system is on by default as a mechanism to assist in further development of Ethereum contract deployment products. It can, of course, be turned off (this is open source software).

# Installing

This is a Ruby gem and will require that you have Ruby on your system (unless and until someone ports this to Python or Node). Once you have ensured that you have Ruby on your system, `gem install epm`.

# Using

The gem is a command line tool. All of the commands are built to run primarily from the command line. Of course the gem will integrate as a Ruby gem into your Ruby application, but primarily it is meant to work from the command line.

## Contract Tools Features

`epm install` -- used like brew install to install a particular Ethereum tool. Use in conjuction with the `-l` or `--local` flag to install the tool as the local tool only for this particular project. Otherwise will install the tool as a global user tool.

`epm uninstall` -- used like brew uninstall to uninstall a particular Ethereum tool. Same restrictions for the `-l` or `--local` flag as with `epm install` are applicable to `epm uninstall`.

`epm upgrade` -- used like brew upgrade to upgrade a particular Ethereum tool. Same restrictions for the `-l` or `--local` flag as with `epm install` are applicable to `epm upgrade`.

`epm list` -- list installable tools.

`epm list-installed` -- list currently installed tools.

## Package Management Features

`epm pull` -- will pull contract provisions, contracts, or packages of contracts based on the contract definition files in the project folder. If used without calling any contract definition file after `epm pull` will pull all the necessary components for all of the contract definition files viewable from the project root. If used with a contract definition file after `epm pull` will pull all the necessary components for the contract definition file.

`epm push` -- will push contract provisions, contracts, or packages of contracts assembled in the project root to the repository noted in the local configuration file's `repository` setting

`epm update` -- will pull updates to the contract provisions, contracts, or packages of contracts based on the contract definition files in the project folder. Can be used with or without a contract definition file as with `epm pull`.

## Contract Workflow Features

`epm make` -- used to pull Ethereum provisions, contracts, or packaged and build out the application or package(s) in this project based on the contract definition files. If used without calling a particular contract definition file after `epm make` will make all the contract definition files visible from the project root (which is where epm make should be called from). If used with a particular contract definition file after `epm make` will only make that particular contract definition.

`epm test` -- used to test Ethereum contracts based upon the tester included in the global or local configuration file.

`epm simulate` -- used to simulate Ethereum contracts or sets of contracts based upon the simulator included in the global or locla configuration file.

`epm deploy` -- used to deploy contracts to the Ethereum blockchain.

`epm update-deployed` -- used to send a command to currently running contracts on the Ethereum blockchain to update themselves based on the git diff between the most recent commit of the project repository and the current commit when the contracts were deployed to the blockchain.

`epm destroy` -- used to send a suicide command to all of the contracts in the Ethereum blockchain which are derived from the project root.

## EPM Self-Reflective Features

`epm configure-local` -- open the local configuration file in the default editor.

`epm configure-global` -- open the global configuration file in the default editor.

`epm self-update` -- update the EPM tool to the latest version.

`epm implode` -- remove EPM entirely.

## Package Management Features

`epm install` --

`epm pull` --

`epm push` --

`epm destroy` --

`epm update` --

`epm list` --

## Contract Workflow Features

`epm make` --

`epm test` --

`epm simulate` --

`epm deploy` --

# Configuration Options

EPM uses what should be a fairly approachable two configuration layers approach to managing configurations. The first level which the gem will look at will be the `~/.epm/config.epm` file. These are the user global configurations. The global configurations will be overwritten by local configuration files in the config.epm file of the root directory of the project you are working on (for the time being epm should be called from this directory). The config.epm file is a [TOML](https://github.com/mojombo/toml) formated configuration file with the following options.

## Global Configuration Options

`editor` -- String denoting the path which EPM should call in order to edit the contract. Default: shell environment's editor.

`linter` -- String denoting the path which EPM should call in order to lint a contract. Default: ???

`tester` -- String denoting the path which EPM should call in order to run your test suite. Default: ???

`simulator` -- String denoting the path which EPM should call in order to start the simulator. Default: ???

`compiler` -- String denoting the path which EPM should call in order to compile the contract into the byte language for deployment to the Ethereum BlockChain. Default: ???

`blacklisted-repos` -- Array of strings denoting github or other git repos which are Blacklisted. Default: []

`deployer-keys` -- String denoting the public key of the deploying coder|lawyer -- which some or all contracts can use to ensure a tip is sent to the deployer.

`infrastructure-keys` -- Array of strings denoting the public keys of the testers, linters, simulators, package managers, and other infrastructure which the deployer used to assist in the deployment of the contract. Strings should be in the form `KEY:AMOUNT:MESSAGE` where KEY is the public hash which the contract will send the tip and where AMOUNT is the **percentage** of the tip which will go to this key. MESSAGE is the signing message of the tip and is optional.

## Local Configuration Options

The local configuration options include *all* of the global configuration options, and local configuration options will override the global configuration options. In addition, there are a few local configuration options which are not read by the global config file.

`name` -- String denoting the name of the package. If the package contains one contract the package and the contract will be the same thing. If the package contains more than one contract then the package will include all of the contracts.

`author` -- String denoting the author of the package.

`author-address` -- String denoting the Ethereum address of the author of the package (used for tipping system when others reuse the contract or package).

`repository` -- String denoting the remote git repository for the package. When the user calls `epm push` EPM will send the package to this address.

# Contract and Package Definition Files

EPM uses contract definition files to build and maintain contracts. Contract definition files are TOML files.

## Package Definition Files

Define the contracts used in the package and the relationships between them. TODO.

## Contract Definition Files -- Shortform

The shortform contract definition allows coder|lawyers to pull in \*.ethereum-contract files to the working folder to be tested, simulated, and deployed from established git repositories.

EPM will pull from any git repository, but it will default to github repositories, so when you send it the following repository: `watershedlegal/ethereum-boilerplate-prefaces` it will know that that is a github address. If you would like to add a private repository or a bitbucket or any other repository simply add the full address to the line. If the repository contains multiple `.ethereum-contract` files and you only want one of those files, you can state the contract you want EPM to pull into the working directory by specifying that instead of the repository in the `XXXXXXX.ethereum-definition` file.

The `XXXX.ethereum-definition` file will simply be a list of the repositories or contract files which EPM should import into the working directory's repo folder. After that it will be up to the coder|lawyer to build the contracts into a working network or meta contract, test, simulate, and deploy.

## Contract Definition Files -- Longform

The longform contract definition allows coder|lawyers to pull in pieces of contracts from different sources and have EPM attempt to assemble a cohesive contract in which the lawyer|coder can then edit before linting, testing, simulating, and deploying.

As with the shortform contract definitions, EPM will pull from any repository based on the rules described above. Addresses may point to the entire repository, in which case EPM will pull in all \*.ethereum-provision files. If only one file is wanted for the preface section, that file path can be specified after the repository address. In addition, if only certain line numbers of a certain file are desired to be pulled in then EPM will know to look for that when you add the following string: `REPONAME/FILEPATH:STARTLINE_ENDLINE` where STARTLINE and ENDLINE are the line numbers which you would like to be pulled in.

The contract definition file is also a TOML formatted configuration file. There are three sections to the contract definition file (which by convention should be XXXXX.ethereum-definition where XXXX is the name of the contract):

1. `provisions` -- Array of strings denoting the repository addresses which EPM will pull from and formulate into the main provisions of this contract.
2. `constants` -- Array of KEY:VALUE pairs which set the constant values after building a contract.
3. `tip-amount` -- Integer denoting the amount of ether to be distributed to the infrastructure network which helped you build and deploy this contract or system of contracts.
4. `constants` -- Array of KEY:VALUE pairs which set the constant values after building a contract.
5. `tip-amount` -- Integer denoting the amount of ether to be distributed to the infrastructure network which helped you build and deploy this contract or system of contracts.

# Roadmap / TODO

- [ ] Everything

# Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Add Tests (and feel free to help here since I don't (yet) really know how to do that.).
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create new Pull Request.

# License

MIT License - (c) 2014 - Watershed Legal Services, PLLC. All copyrights are owned by [Watershed Legal Services, PLLC](http://watershedlegal.com).

See License file.