note

	description:

		"Eiffel Package Manager"

	copyright: "Copyright (c) 2013, Olivier Ligot and others"
	license: "MIT License"

class EPM

inherit
	KL_SHARED_ARGUMENTS
	KL_SHARED_EXECUTION_ENVIRONMENT
	KL_SHARED_FILE_SYSTEM
	KL_SHARED_OPERATING_SYSTEM
	SHARED_EJSON

create
	make

feature {NONE} -- Initialization

	make
			-- Run the application with options.
		local
			l_package_converter: JSON_EPM_PACKAGE_CONVERTER
			l_parser: AP_PARSER
			l_commands: DS_HASH_TABLE [PROCEDURE [ANY, TUPLE [DS_LIST [detachable STRING]]], STRING]
		do
			create error_handler.make_standard
			create configuration.make_default
			json.add_converter (create {JSON_EPM_CONFIGURATION_CONVERTER}.make)
			create package_reader.make_with_error_handler (error_handler)
			create l_package_converter.make
			package := l_package_converter.object
			json.add_converter (l_package_converter)
			Arguments.set_program_name ("epm")
			create l_parser.make
			l_parser.set_application_description ("Eiffel Package Manager")
			l_parser.set_parameters_description ("<command> where <command> is one of: sync")
			l_parser.parse_arguments
			if attached l_parser.parameters as l_parameters and then attached l_parser.help_option as l_help_option then
				if l_parameters.count < 1 then
					l_help_option.display_help (l_parser)
				else
					create l_commands.make (1)
					l_commands.force_last (agent sync, "sync")
					if attached l_parameters.first as l_first then
						if not l_commands.has (l_first) then
							l_help_option.display_help (l_parser)
						else
							l_commands.item (l_first).call ([l_parameters])
						end
					end
				end
			end
		end

feature -- Basic operations

	sync (some_parameters: DS_LIST [detachable STRING])
			-- Sync (install or update) a package.
		local
			l_dependency, l_dir, l_message, l_script, l_sync_message: STRING
			l_dependencies: DS_LINKED_LIST [detachable STRING]
			l_command: DP_SHELL_COMMAND
			l_clone: GIT_CLONE_COMMAND
			l_checkout: GIT_CHECKOUT_COMMAND
			l_new, l_new_dependency: BOOLEAN
		do
			read_configuration
			l_new := not File_system.is_directory_readable (configuration.directory)
			if l_new then
				l_sync_message := "Installing"
			else
				l_sync_message := "Updating"
			end
			read_package
			if package_read then
				create l_message.make_empty
				l_message.append_string (l_sync_message)
				l_message.append_string (" package ")
				l_message.append_string (package.name)
				l_message.append_string (" version ")
				l_message.append_string (package.version)
				l_message.append_string ("...")
				error_handler.report_info_message (l_message)
				if attached package.dependencies.new_cursor as l_cursor then
					from
						l_cursor.start
						create l_dependencies.make_equal
						l_dependencies.extend_last (some_parameters)
						if not l_dependencies.is_empty then
							l_dependencies.remove_first
						end
					until
						l_cursor.off
					loop
						l_dependency := l_cursor.key
						if l_dependencies.is_empty or else l_dependencies.has (l_dependency) then
							create l_message.make_empty
							l_message.append_string (l_sync_message)
							l_message.append_string (" dependency ")
							l_message.append_string (l_dependency)
							l_message.append_string ("...")
							error_handler.report_info_message (l_message)
							l_dir := File_system.pathname (configuration.directory, l_dependency)
							l_new_dependency := not File_system.is_directory_readable (l_dir)
							if l_new_dependency then
								File_system.create_directory (configuration.directory)
								create l_clone.make_directory (l_cursor.item.repository, l_dir)
								l_clone.execute
								create l_checkout.make (l_cursor.item.branch)
								l_checkout.set_directory (l_dir)
								l_checkout.execute
							else
								sync_update (l_cursor.key, l_cursor.item)
							end
							if File_system.is_file_readable (File_system.pathname (l_dir, {EPM_PACKAGE_FILE_READER}.Package_file_name)) then
								package_reader.set_directory (l_dir)
								package_reader.read
								if attached package_reader.package as l_package and then attached l_package.environment_variable as l_env then
									Execution_environment.set_variable_value (l_env, File_system.pathname (File_system.cwd, l_dir))
								end
							end
							l_script := File_system.pathname (l_dir, script_file)
							if l_new_dependency and File_system.is_file_readable (l_script) then
								create l_command.make (command (l_script))
								l_command.execute
							end
						end
						l_cursor.forth
					end
				end
				if l_new and File_system.is_file_readable (script_file) then
					create l_command.make (command (script_file))
					l_command.execute
				end
				error_handler.report_info_message ("done")
            end
		end

feature {NONE} -- Implementation

	error_handler: EPM_ERROR_HANDLER
			-- Error handler

	configuration: EPM_CONFIGURATION
			-- Configuration

	package_reader: EPM_PACKAGE_FILE_READER
			-- Package reader

	package: EPM_PACKAGE
			-- Package definition

	package_read: BOOLEAN
			-- Has the package been read ?

	script_file: STRING
			-- Install script file name.
		do
			create Result.make_empty
			Result.append_string ("epm.")
			if Operating_system.is_unix then
				Result.append_string ("sh")
			else
				Result.append_string ("bat")
			end
		end

	command (a_script_name: STRING): STRING
			-- Command line for `a_script_name'.
		do
			if Operating_system.is_unix then
				Result := "./" + a_script_name
			else
				Result := a_script_name
			end
		end

	read_configuration
			-- Read the configuration.
		local
			l_reader: EPM_CONFIGURATION_FILE_READER
		do
			create l_reader.make (error_handler)
			l_reader.read
			if attached l_reader.configuration as l_configuration then
				configuration := l_configuration
			end
		end

	read_package
			-- Read the package definition.
		do
			package_reader.read
			if attached package_reader.package as l_package then
				package := l_package
				package_read := True
			end
		end

	sync_update (a_package: STRING; a_dependency: EPM_PACKAGE_DEPENDENCY)
			-- Update the local repository of `a_dependency'.
		local
			l_dir: STRING_8
			l_fetch: GIT_FETCH_COMMAND
			l_checkout: GIT_CHECKOUT_COMMAND
			l_merge: GIT_MERGE_COMMAND
		do
			l_dir := File_system.pathname (configuration.directory, a_package)
			create l_fetch.make
			l_fetch.set_directory (l_dir)
			l_fetch.execute
			create l_checkout.make (a_dependency.branch)
			l_checkout.set_directory (l_dir)
			l_checkout.execute
			create l_merge.make ("origin/" + a_dependency.branch)
			l_merge.set_directory (l_dir)
			l_merge.execute
		end

end
