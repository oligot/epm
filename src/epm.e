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
	KL_SHARED_EXECUTION_ENVIRONMENT
	SHARED_EJSON

create
	make

feature {NONE} -- Initialization

	make
			-- Run the application with options.
		do
			Arguments.set_program_name ("epm")
			create parser.make
			parser.set_application_description ("Eiffel Package Manager")
			parser.set_parameters_description ("install package")
			parser.parse_arguments
			if parser.parameters.count /= 1 or else not parser.parameters.first.is_equal ("install") then
				parser.help_option.display_help (parser)
			else
				install_package
			end
		end

feature {NONE} -- Implementation

	parser: AP_PARSER
			-- Argument parser

	Package_file_name: STRING = "package.json"
			-- Package file name

	Eiffelhub_name: STRING = "EIFFELHUB"
			-- Eiffelhub environment variable name

	Eiffelhub_default_value: STRING = "$HOME/eiffelhub"
			-- Eiffelhub environment variable default value

	check_eiffelhub
			-- Check that the environment variable `Eiffelhub_name' is defined.
		local
			l_value: STRING
		do
			l_value := Execution_environment.variable_value (Eiffelhub_name)
			if l_value = Void then
				Execution_environment.set_variable_value (Eiffelhub_default_value, Eiffelhub_name)
			end
		end

	install_package
			-- Install the package.
		local
			l_converter: JSON_EPM_PACKAGE_CONVERTER
			l_directory: KL_DIRECTORY
			l_file: KL_TEXT_INPUT_FILE
			l_parser: JSON_PARSER
			l_package: EPM_PACKAGE
		do
			check_eiffelhub
			create l_converter.make
			json.add_converter (l_converter)
			create l_directory.make (File_system.cwd)
			l_directory.open_read
			if l_directory.is_open_read then
				create l_file.make (file_system.pathname (l_directory.name, Package_file_name))
				l_file.open_read
				if l_file.is_open_read then
					l_file.read_string (l_file.count)
					create l_parser.make_parser (l_file.last_string)
					if attached l_parser.parse as jv and l_parser.is_parsed then
						l_package ?= json.object (jv, "EPM_PACKAGE")
						io.put_string ("Installing package " + l_package.name + " version " + l_package.version + "...")
						File_system.recursive_copy_directory (l_directory.name,
							File_system.pathname (Execution_environment.variable_value (Eiffelhub_name),
							File_system.dirname (l_directory.name)))
						io.put_string ("done")
						io.put_new_line
					else
						io.put_string ("Unable to parse " + l_file.last_string)
	                end
				else
					io.put_string ("Unable to open file " + l_file.name)
				end
			else
				io.put_string ("Unable to open directory " + l_directory.name)
			end
		end

end
