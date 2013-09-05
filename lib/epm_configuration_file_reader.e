note
	description: "Read a configuration from a file."
	author: "Olivier Ligot"

class
	EPM_CONFIGURATION_FILE_READER

inherit
	KL_SHARED_FILE_SYSTEM
	SHARED_EJSON

create
	make,
	make_default

feature {NONE} -- Initialization

	make (an_error_handler: like error_handler)
		do
			error_handler := an_error_handler
		ensure
			error_handler_set: error_handler = an_error_handler
		end

	make_default
		do
			make (create {UT_ERROR_HANDLER}.make_standard)
		end

feature -- Access

	configuration: detachable EPM_CONFIGURATION
			-- Configuration

feature -- Basic operations

	read
			-- Read the configuration.
		local
			l_file: KL_TEXT_INPUT_FILE
			l_count: INTEGER
			l_parser: JSON_PARSER
			l_content: STRING
		do
			create l_file.make (File_system.pathname (File_system.cwd, Configuration_file_name))
			l_count := l_file.count
			l_file.open_read
			if l_file.is_open_read then
				l_file.read_string (l_count)
				l_content := l_file.last_string.as_attached
				create l_parser.make_parser (l_content)
				if attached l_parser.parse as jv and l_parser.is_parsed then
					if attached {EPM_CONFIGURATION} json.object (jv, "EPM_CONFIGURATION") as l_configuration then
						configuration := l_configuration
					end
				else
					error_handler.report_error_message ("Unable to parse " + l_content)
                end
			end
		end

feature -- Constants

	Configuration_file_name: STRING = ".epmrc"
			-- Configuration file name

feature {NONE} -- Implementation

	error_handler: UT_ERROR_HANDLER
			-- Error handler

end
