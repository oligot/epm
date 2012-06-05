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
	KL_SHARED_EXECUTION_ENVIRONMENT
	KL_SHARED_FILE_SYSTEM
	SHARED_EJSON

create
	make

feature {NONE} -- Initialization

	make
			-- Run the application with options.
		local
			l_converter: JSON_EPM_PACKAGE_CONVERTER
			l_parser: AP_PARSER
			l_commands: DS_HASH_TABLE [PROCEDURE [ANY, TUPLE], STRING]
		do
			create l_converter.make
			json.add_converter (l_converter)
			Arguments.set_program_name ("epm")
			create l_parser.make
			l_parser.set_application_description ("Eiffel Package Manager")
			l_parser.set_parameters_description ("<command> where <command> is one of: init, install, pack")
			l_parser.parse_arguments
			if l_parser.parameters.count < 1 then
				l_parser.help_option.display_help (l_parser)
			else
				create l_commands.make (3)
				l_commands.force_last (agent init, "init")
				l_commands.force_last (agent install, "install")
				l_commands.force_last (agent pack, "pack")
				if not l_commands.has (l_parser.parameters.first) then
					l_parser.help_option.display_help (l_parser)
				else
					l_commands.item (l_parser.parameters.first).call ([l_parser.parameters])
				end
			end
		end

feature -- Basic operations

	init (parameters: DS_LIST [STRING])
			-- Interactively create a package.json file.
		local
			l_default_package_name: STRING
			l_name, l_description, l_version: STRING
			l_package: EPM_PACKAGE
			l_file_name: STRING
			l_file: KL_TEXT_OUTPUT_FILE
		do
			l_default_package_name := File_system.basename (File_system.cwd)
			io.put_new_line
			io.put_string ("Package name: (" + l_default_package_name + ") ")
			io.read_line
			if not io.last_string.is_empty then
				l_name := io.last_string.twin
			else
				l_name := l_default_package_name
			end
			io.put_new_line
			io.put_string ("Description: ")
			io.read_line
			if not io.last_string.is_empty then
				l_description := io.last_string.twin
			end
			io.put_new_line
			io.put_string ("Package version: (" + Default_version + ") ")
			io.read_line
			if not io.last_string.is_empty then
				l_version := io.last_string.twin
			else
				l_version := Default_version
			end
			create l_package.make (l_name, l_version)
			if l_description /= Void then
				l_package.set_description (l_description)
			end
			if attached {JSON_VALUE} json.value (l_package) as jv then
				l_file_name := File_system.pathname (File_system.cwd, Package_file_name)
				io.put_new_line
				io.put_string ("About to write to " + l_file_name)
				io.put_new_line
				io.put_new_line
				io.put_string (jv.representation)
				io.put_new_line
				io.put_new_line
				io.put_string ("Is this ok? (yes) ")
				io.read_line
				if io.last_string.is_empty or else io.last_string.is_equal ("y") or else io.last_string.is_equal ("yes") then
					create l_file.make (l_file_name)
					l_file.open_write
					if l_file.is_open_write then
						l_file.put_string (jv.representation)
						l_file.close
					else
						io.put_string ("Unable to open file " + l_file.name)
					end
				end
				io.put_new_line
			end
		end

	install (parameters: DS_LIST [STRING])
			-- Install a package.
		local
			l_execution_environment: EXECUTION_ENVIRONMENT
			l_file, l_epm_directory, l_cwd, l_directory_name, l_command: STRING
			l_directory: KL_DIRECTORY
			i: INTEGER
		do
			l_epm_directory := "/tmp/epm"
			check_epm_libraries
			if parameters.count > 1 then
				l_file := parameters.item (2)
				File_system.create_directory (l_epm_directory)
				l_cwd := File_system.cwd
				File_system.cd (l_epm_directory)
				l_command := "tar xfz " + File_system.pathname (l_cwd, l_file)
				create l_execution_environment
				l_execution_environment.system (l_command)
				if l_execution_environment.return_code /= 0 then
					io.put_string ("Error code " + l_execution_environment.return_code.out + " while running " + l_command)
				else
					i := l_file.index_of ('-', 1)
					if i > 0 then
						l_directory_name := File_system.pathname (l_epm_directory, l_file.substring (1, i - 1))
					else
						io.put_string ("Wrong file name format " + l_file)
					end
				end
				File_system.cd (l_cwd)
			else
				l_directory_name := File_system.cwd
			end
			create l_directory.make (l_directory_name)
			l_directory.open_read
			if l_directory.is_open_read then
				read_package (l_directory.name)
				if package /= Void then
					io.put_string ("Installing package " + package.name + " version " + package.version + "...")
					File_system.recursive_copy_directory (l_directory.name, File_system.pathname (
						Execution_environment.interpreted_string (Execution_environment.variable_value (Epm_libraries_name)),
						File_system.basename (l_directory.name)))
					io.put_string ("done")
					io.put_new_line
                end
			else
				io.put_string ("Unable to open directory " + l_directory.name)
			end
			File_system.delete_directory (l_epm_directory)
		end

	pack (parameters: DS_LIST [STRING])
			-- Create a tarball from a package.
		local
			l_execution_environment: EXECUTION_ENVIRONMENT
			l_command, l_cwd, l_package: STRING
		do
			read_package (File_system.cwd)
			if package /= Void then
				l_cwd := File_system.cwd
				File_system.cd ("..")
				l_package := package.name + "-" + package.version + ".tgz"
				l_command := "tar cfz " + l_package + " " + File_system.basename (l_cwd)
				create l_execution_environment
				l_execution_environment.system (l_command)
				if l_execution_environment.return_code /= 0 then
					io.put_string ("Error code " + l_execution_environment.return_code.out + " while running " + l_command)
				else
					File_system.rename_file (l_package, File_system.pathname (File_system.basename (l_cwd), l_package))
					io.put_string ("./" + l_package)
					io.put_new_line
				end
				File_system.cd (l_cwd)
			end
		end

feature {NONE} -- Implementation

	Package_file_name: STRING = "package.json"
			-- Package file name

	Epm_libraries_name: STRING = "EPM_LIBRARIES"
			-- Epm libraries environment variable name

	Epm_libraries_default_value: STRING = "$HOME/epm_libraries"
			-- Epm libraries environment variable default value

	Default_version: STRING = "0.0.0"
			-- Default version number

	package: EPM_PACKAGE
			-- Package definition

	check_epm_libraries
			-- Check that the environment variable `Epm_libraries_name' is defined
			-- and that the directory corresponding to the value of `Epm_libraries_name' exists.
		local
			l_value, l_directory: STRING
		do
			l_value := Execution_environment.variable_value (Epm_libraries_name)
			if l_value = Void then
				Execution_environment.set_variable_value (Epm_libraries_name, Epm_libraries_default_value)
				l_value := Execution_environment.variable_value (Epm_libraries_name)
			end
			l_directory := Execution_environment.interpreted_string (l_value)
			if not File_system.directory_exists (l_directory) then
				File_system.recursive_create_directory (l_directory)
			end
		end

	read_package (a_directory: STRING)
			-- Read the package definition.
		local
			l_file: KL_TEXT_INPUT_FILE
			l_parser: JSON_PARSER
		do
			create l_file.make (file_system.pathname (a_directory, Package_file_name))
			l_file.open_read
			if l_file.is_open_read then
				l_file.read_string (l_file.count)
				create l_parser.make_parser (l_file.last_string)
				if attached l_parser.parse as jv and l_parser.is_parsed then
					package ?= json.object (jv, "EPM_PACKAGE")
				else
					io.put_string ("Unable to parse " + l_file.last_string)
                end
			else
				io.put_string ("Unable to open file " + l_file.name)
			end
		end

end
