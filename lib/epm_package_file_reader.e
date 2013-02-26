note
	description: "Read a package from a file."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	EPM_PACKAGE_FILE_READER

inherit
	KL_SHARED_FILE_SYSTEM
	SHARED_EJSON

create
	make,
	make_with_error_handler

feature {NONE} -- Initialization

	make
		do
			create error_handler.make_standard
			directory := File_system.cwd
		end

	make_with_error_handler (an_error_handler: like error_handler)
		do
			make
			error_handler := an_error_handler
		ensure
			error_handler_set: error_handler = an_error_handler
		end

feature -- Access

	directory: STRING
			-- Directory

	package: detachable EPM_PACKAGE
			-- Package

feature -- Element change

	set_directory (a_directory: like directory)
			-- Set `directory' to `a_directory'.
		do
			directory := a_directory
		ensure
			directory_set: directory = a_directory
		end

feature -- Basic operations

	read
			-- Read the package definition.
		local
			l_file: KL_TEXT_INPUT_FILE
			l_count: INTEGER
			l_parser: JSON_PARSER
		do
			create l_file.make (File_system.pathname (directory, Package_file_name))
			l_count := l_file.count
			l_file.open_read
			if l_file.is_open_read then
				l_file.read_string (l_count)
				create l_parser.make_parser (l_file.last_string)
				if attached l_parser.parse as jv and l_parser.is_parsed then
					if attached {EPM_PACKAGE} json.object (jv, "EPM_PACKAGE") as l_package then
						package := l_package
					end
				else
					error_handler.report_error_message ("Unable to parse " + l_file.last_string)
                end
			else
				error_handler.report_error_message ("Unable to open file " + l_file.name)
			end
		end

feature -- Constants

	Package_file_name: STRING = "system.json"
			-- Package file name

feature {NONE} -- Implementation

	error_handler: UT_ERROR_HANDLER
			-- Error handler

end
