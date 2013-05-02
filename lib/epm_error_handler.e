note
	description: "epm error handler."
	author: "Olivier Ligot"

class
	EPM_ERROR_HANDLER

inherit
	UT_ERROR_HANDLER
		redefine
			report_error_message,
			report_info_message,
			message
		end

create
	make_standard,
	make_null

feature -- Basic operations

	report_error_message (an_error: STRING)
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

	report_info_message (an_info: STRING)
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

	message (an_error: UT_ERROR): STRING
			-- Message built out of `an_error'
			-- Redefinition is needed by ISE compiler
			-- as GOBO is not fully Void-safe yet
		do
			if attached Precursor (an_error) as l_result then
				Result := l_result
			else
				create Result.make_empty
			end
		end

	Epm: STRING = "epm"

end
