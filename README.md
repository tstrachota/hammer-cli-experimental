# Experimental features for Hammer CLI

A hammer-cli plugin that contains features not mature enough to be merged into the core.

If you have a prototype of a feature which is either not completely stable or you're not sure if it's interesting for users and worth finishing, this is the right place to keep such code. The repository is open for innovative ideas. The only rule is that it must be possible to turn the feature off in the configuration.

* [Current features](#current-features)
  * [config command](#config-command)
  * [Fuzzy matching of subcommands](#fuzzy-matching-of-subcommands)
  * [full-help command](#full-help-command)
  * [Command debugging](#command-debugging)
  * [Condensed help](#condensed-help)
* [Installation](#installation)
* [License](#license)

## Current features

### Config command

A command for printing current hammer configuration. It can print config values split by the file it comes from or the final config mix.

```
$ hammer config -h
Usage:
    hammer config [OPTIONS]

Options:
 --paths                       Show only used paths
 --show                        List final configuration
 --show-by-path                List configurations from each of used files
 -h, --help                    print help
```

You can turn it on by following setting:
```yaml
  # Enable config command
  :enable_config_command: true
```

### Fuzzy matching of subcommands

Enables using shortened versions of subcommend names as long as it matches only one subcommand.
Eg. `hammer org list`.

It also adds aliases of the most common commands:
```
index -> list
show -> info
destroy -> delete
```

You can turn it on by following setting:
```yaml
  # Enable fuzzy matching of subcommands
  :enable_fuzzy_subcommands: true
```

### full-help command

Adds a command for printing help for all hammer commands. It supports either plaintext or markdown format.

```
$ hammer full-help -h
Usage:
    hammer full-help [OPTIONS]

Options:
 --md                          Format output in markdown
 -h, --help                    print help

```

You can turn it on by following setting:
```yaml
  # Enable full-help command
  :enable_full_help_command: true
```

### Command debugging

Adds option `--debug=BREAKPOINT` for all hammer commands. With that option hammer stops
and invokes pry session at one predefined breakpoints:

* `execute` - breaks in the main execution method
* `params` - breaks in the method that collects params for the command's api request
* `transform_result` - breaks in the method that modifies data returned from the server before they're printed
* `handle_exception` - breaks in the exception handler

You can turn it on by following setting:
```yaml
  # Enable command debugging
  :enable_debugging: true
```

### Condensed help

Squeeze options that reference the same resource with different identifiers, eg. `--organization[-id|-label]`. Highly experimental.

You can turn it on by following setting:
```yaml
  # Enable condensed help, highly experimental
  :enable_help: true
```

## Installation

```
# Install the gem
gem install hammer_cli_experimental
# Copy the default config file into your hammer configuration
cp  $(gem which hammer_cli_experimental | sed 's#lib/.*.rb#config/*#') ~/.hammer/cli.modules.d/

# Now edit the config file and enable experimental options at your will
vim ~/.hammer/cli.modules.d/experimental.yml
```

## License

This project is licensed under the GPLv3+.
