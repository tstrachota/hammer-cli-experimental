require 'hammer_cli'

module HammerCLIExperimental

  require 'hammer_cli_experimental/help' if HammerCLI::Settings.get(:experimental, :enable_help)
  require 'hammer_cli_experimental/config' if HammerCLI::Settings.get(:experimental, :enable_config_command)
  require 'hammer_cli_experimental/subcommands' if HammerCLI::Settings.get(:experimental, :enable_fuzzy_subcommands)
end
