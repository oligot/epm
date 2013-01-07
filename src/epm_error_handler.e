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
			report_info_message
		end

create
	make_standard,
	make_null

feature -- Basic operations

	report_info_message (an_info: detachable STRING)
			-- Report `an_info'.
		do
			Precursor ("epm " + an_info)
		end

end
