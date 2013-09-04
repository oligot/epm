note
	description: "EPM configuration."
	author: "Olivier Ligot"

class
	EPM_CONFIGURATION

create
	make,
	make_default

feature {NONE} -- Initialization

	make (a_directory: STRING)
		do
			directory := a_directory
		ensure
			directory_set: directory = a_directory
		end

	make_default
		do
			directory := Eiffel_library_directory
		end

feature -- Access

	directory: STRING
			-- The path in which installed components should be saved
			-- If not specified this defaults to `Eiffel_library_directory'.

feature -- Constants

	Eiffel_library_directory: STRING = "eiffel_library"
			-- Eiffel library directory

end
