require 'hammer_cli'

module HammerCLIExperimental

  require 'hammer_cli_experimental/help' if HammerCLI::Settings.get(:experimental, :enable_help)
  require 'hammer_cli_experimental/config' if HammerCLI::Settings.get(:experimental, :enable_config_command)
  require 'hammer_cli_experimental/subcommands' if HammerCLI::Settings.get(:experimental, :enable_fuzzy_subcommands)
  require 'hammer_cli_experimental/full_help' if HammerCLI::Settings.get(:experimental, :enable_full_help_command)
  require 'hammer_cli_experimental/debugging' if HammerCLI::Settings.get(:experimental, :enable_debugging)
end
