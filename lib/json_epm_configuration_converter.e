note
	description: "JSON converter for the configuration."
	author: "Olivier Ligot"

class
	JSON_EPM_CONFIGURATION_CONVERTER

inherit
    JSON_CONVERTER

create
    make

feature {NONE} -- Initialization

    make
        do
            create object.make_default
        end

feature -- Access

    value: detachable JSON_OBJECT

    object: EPM_CONFIGURATION

feature -- Conversion

    from_json (j: attached like value): detachable like object
        do
            if attached {JSON_STRING} j.item (K_directory) as l_directory then
            	create Result.make (l_directory.item)
            end
        end

    to_json (o: like object): like value
        do

        end

feature {NONE} -- Implementation

	K_directory: STRING = "directory"

end
