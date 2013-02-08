note

	description:

		"Eiffel Package Manager"

	copyright: "Copyright (c) 2012, Olivier Ligot and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

class EPM

inherit
	KL_SHARED_ARGUMENTS
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
			create l_package_converter.make
			package := l_package_converter.object
			json.add_converter (l_package_converter)
			Arguments.set_program_name ("epm")
			create l_parser.make
			l_parser.set_application_description ("Eiffel Package Manager")
			l_parser.set_parameters_description ("<command> where <command> is one of: install, update")
			l_parser.parse_arguments
			if attached l_parser.parameters as l_parameters and then attached l_parser.help_option as l_help_option then
				if l_parameters.count < 1 then
					l_help_option.display_help (l_parser)
				else
					create l_commands.make (3)
					l_commands.force_last (agent install, "install")
					l_commands.force_last (agent update, "update")
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

	install (some_parameters: DS_LIST [detachable STRING])
			-- Install a package.
		do
			sync ("Installing", some_parameters, True)
		end

	update (some_parameters: DS_LIST [detachable STRING])
			-- Update a package.
		do
			sync ("Updating", some_parameters, False)
		end

feature {NONE} -- Implementation

	error_handler: EPM_ERROR_HANDLER
			-- Error handler

	package: EPM_PACKAGE
			-- Package definition

	package_read: BOOLEAN
			-- Has the package been read ?

	Eiffel_library_directory: STRING = "eiffel_library"
			-- Eiffel library directory

	script_file: STRING
			-- Install script file name.
		do
			create Result.make_empty
			Result.append_string ("install.")
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

	sync (a_sync_message: STRING; some_parameters: DS_LIST [detachable STRING]; a_exec_scripts: BOOLEAN)
			-- Sync (install or update) a package.
		local
			l_dependency, l_dir, l_message: STRING
			l_dependencies: DS_LINKED_LIST [detachable STRING]
			l_command: DP_SHELL_COMMAND
			l_clone: GIT_CLONE_COMMAND
			l_checkout: GIT_CHECKOUT_COMMAND
		do
			read_package
			if package_read then
				create l_message.make_empty
				l_message.append_string (a_sync_message)
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
							l_message.append_string (a_sync_message)
							l_message.append_string (" dependency ")
							l_message.append_string (l_dependency)
							l_message.append_string ("...")
							error_handler.report_info_message (l_message)
							l_dir := File_system.pathname (eiffel_library_directory, l_dependency)
							if File_system.is_directory_readable (l_dir) then
								pull (l_cursor.key, l_cursor.item)
							else
								File_system.create_directory (eiffel_library_directory)
								create l_clone.make_directory (l_cursor.item.repository, l_dir)
								l_clone.execute
								create l_checkout.make (l_cursor.item.branch)
								run_in_directory (l_checkout, l_dir)
							end
						end
						l_cursor.forth
					end
				end
				if a_exec_scripts and File_system.is_file_readable (script_file) then
					create l_command.make (command (script_file))
					l_command.execute
				end
				error_handler.report_info_message ("done")
            end
		end

	read_package
			-- Read the package definition.
		local
			l_reader: EPM_PACKAGE_FILE_READER
		do
			create l_reader.make_with_error_handler (error_handler)
			l_reader.read
			if attached l_reader.package as l_package then
				package := l_package
				package_read := True
			end
		end

	pull (a_package: STRING; a_dependency: EPM_PACKAGE_DEPENDENCY)
			-- Pull.
		local
			l_dir: STRING_8
			l_pull: GIT_PULL_COMMAND
			l_checkout: GIT_CHECKOUT_COMMAND
		do
			l_dir := File_system.pathname (eiffel_library_directory, a_package)
			create l_pull.make
			run_in_directory (l_pull, l_dir)
			create l_checkout.make (a_dependency.branch)
			run_in_directory (l_checkout, l_dir)
		end

	run_in_directory (a_command: GIT_COMMAND; a_directory: STRING)
			-- Run `a_command' in `a_directory'.
		local
			l_cwd: STRING
		do
			l_cwd := File_system.cwd
			File_system.cd (a_directory)
			a_command.execute
			File_system.cd (l_cwd)
		end

end
