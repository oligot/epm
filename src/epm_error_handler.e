note
	description: "epm error handler."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	EPM_ERROR_HANDLER

inherit
	UT_ERROR_HANDLER
		redefine
			report_error_message,
			report_info_message
		end

create
	make_standard,
	make_null

feature -- Basic operations

	report_error_message (an_error: detachable STRING)
			-- Report `an_error'.
		local
			l_message: STRING
		do
			create l_message.make_empty
			l_message.append_string (Epm)
			l_message.append_string (" ERR! ")
			l_message.append_string (an_error)
			Precursor (l_message)
		end

	report_info_message (an_info: detachable STRING)
			-- Report `an_info'.
		local
			l_message: STRING
		do
			create l_message.make_empty
			l_message.append_string (Epm)
			l_message.append_character (' ')
			l_message.append_string (an_info)
			Precursor (l_message)
		end

feature {NONE} -- Implementation

	Epm: STRING = "epm"

end
